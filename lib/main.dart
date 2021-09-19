import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as constants;
import 'logic.dart';
import 'pages/subject_view.dart';
import 'themes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database data = await loadDatabase(constants.saveFileName);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeDataProvider>(
          create: (_) => ThemeDataProvider(),
        ),
      ],
      child: IterniaApp(
        data: data,
      ),
    ),
  );
}

/*
  TODO:
  - subject cards in grid view packen und die iwie sizemäßig anpassen
  - dark mode on tap


  - UNCOPYRIGHT, THEN
  - FINISHING TOUCHES: STANDARDIZE, MAKE ALL COMMAS PROPERLY, CLEANUP IMPORTS IN ALL FILES
 */
class IterniaApp extends StatefulWidget {
  const IterniaApp({Key? key, required this.data}) : super(key: key);

  final Database data;

  @override
  State<IterniaApp> createState() => _IterniaAppState();
}

class _IterniaAppState extends State<IterniaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        storeDatabase(constants.saveFileName, widget.data);
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        setState(() {});
        break;
    }

    debugPrint(state.toString());
  }

  @override
  Widget build(BuildContext context) {
    ThemeDataProvider themeDataProvider = Provider.of(context);
    final ThemeData currentTheme = themeDataProvider.themeData;

    return MaterialApp(
      title: constants.appTitle,
      theme: currentTheme,
      darkTheme: currentTheme.copyWith(brightness: Brightness.dark),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      home: SubjectView(
        subjects: widget.data.subjects,
      ),
    );
  }
}

loadDatabase(String saveFile) async {
  String dataStr = await _read(constants.saveFileName);
  return Database.fromJson(jsonDecode(dataStr));
}

storeDatabase(String saveFile, Database data) async {
  String dataStr = jsonEncode(data.toJson());
  _save(dataStr, constants.saveFileName);
}

Future<String> _read(String saveFile) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$saveFile');
    debugPrint('Read data from ${file.absolute}');
    return await file.readAsString();
  } catch (e) {
    debugPrint("Generating empty data");
    if (kDebugMode) return jsonEncode(Database(subjects: _generateSampleData()));
    return jsonEncode(Database(subjects: <Subject>[]).toJson());
  }
}

Future<void> _save(String data, String saveFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$saveFile');
  await file.writeAsString(data);
  debugPrint('Saved data to ${file.absolute}');
}

/* JUST SOME SAMPLE METHODS */
List<Subject> _generateSampleData() {
  // TODO add one more item here..., maybe even more...
  return [
    Subject(
      name: 'Maths',
      description: 'My basic maths equations',
      decks: [
        Deck(
          name: 'Maths Lesson 1',
          description: 'the one and only math lesson needed',
          cards: List<int>.generate(13, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 10).toString()))
              .toList(),
        ),
        Deck(
          name: 'Maths Lesson 2',
          description: 'the second and only math lesson needed',
          cards: List<int>.generate(43, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 20).toString()))
              .toList(),
        ),
      ],
    ),
    Subject(
      name: 'Chinese',
      description: 'Chinese vocabulary and more',
      decks: List<int>.generate(75, (i) => i + 1)
          .map(
            (i) => Deck(
          name: 'Chinese Lesson $i',
          description: 'Chinese Lesson Description $i',
          cards: List<int>.generate(i, (j) => j + 1)
              .map((j) => FlashCard(front: j.toString(), back: (j * 144).toString()))
              .toList(),
        ),
      )
          .toList(),
    ),
    Subject(
      name: 'Japanese',
      description: 'Japanese vocabulary and grammar practices',
      decks: [
        Deck(
          name: 'Japanese Lesson 1',
          description: 'japanese for beginners 1',
          cards: List<int>.generate(111, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 30).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 2',
          description: 'japanese for beginners 2',
          cards: List<int>.generate(42, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 40).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 3',
          description: 'japanese for beginners 3',
          cards: List<int>.generate(19, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 50).toString()))
              .toList(),
        ),
      ],
    ),
    Subject(
      name: 'English',
      description: 'English is really simple, isn\'t it?',
      decks: [
        Deck(
          name: 'English Lesson 1',
          description: 'english CAE vocabulary',
          cards: List<int>.generate(133, (i) => i + 1)
              .map((i) => FlashCard(front: i.toString(), back: (i * 60).toString()))
              .toList(),
        ),
      ],
    ),
  ];
}
