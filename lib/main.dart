import 'package:flutter/material.dart';
import 'logic.dart';
import 'pages/subject_view.dart';
import 'pages/subject_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SubjectEdit(title: 'Iternia Flash'),
    );
  }
}

