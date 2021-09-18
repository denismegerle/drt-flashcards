import 'package:flutter/material.dart';
import 'logic.dart';
import 'pages/subject_view.dart';
import 'pages/subject_mod.dart';
import 'pages/swipe_learning.dart';
import 'pages/flashcard_mod.dart';
import 'pages/deck_view.dart';
import 'pages/image_search.dart';
import 'themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart' as constants;

void main() {
  runApp(MyApp());
}

/*
  TODO:
  - refactor all smaller widgets to take onX methods and implement these only in the main state!
  - refactor all navigation between screens to _navigate* methods
  - subject cards in grid view packen und die iwie sizemäßig anpassen

  - FINISHING TOUCHES: STANDARDIZE, MAKE ALL COMMAS PROPERLY, CLEANUP IMPORTS IN ALL FILES
 */
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  List<Subject> data = _generateSampleData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.appTitle,
      theme: cleanTheme,
      darkTheme: cleanThemeDark,
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
        subjects: data,
      ),
    );
  }
}






















/* JUST SOME SAMPLE METHODS */
List<Subject> _generateSampleData() {
  return [
    Subject(
      name: 'Maths',
      description: 'My basic maths equations',
      decks: [
        Deck(
          name: 'Maths Lesson 1',
          description: 'the one and only math lesson needed',
          cards: List<int>.generate(13, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 10).toString()))
              .toList(),
        ),
        Deck(
          name: 'Maths Lesson 2',
          description: 'the second and only math lesson needed',
          cards: List<int>.generate(43, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 20).toString()))
              .toList(),
        ),
      ],
    ),
    Subject(
      name: 'Japanese',
      description: 'Japanese vocabulary and grammar practices',
      decks: [
        Deck(
          name: 'Japanese Lesson 1',
          description: 'japanese for beginners 1',
          cards: List<int>.generate(111, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 30).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 2',
          description: 'japanese for beginners 2',
          cards: List<int>.generate(42, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 40).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 3',
          description: 'japanese for beginners 3',
          cards: List<int>.generate(19, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 50).toString()))
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
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 60).toString()))
              .toList(),
        ),
      ],
    ),
  ];
}
