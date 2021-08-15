import 'package:flutter/material.dart';
import 'logic.dart';
import 'pages/subject_view.dart';
import 'pages/subject_add.dart';
import 'pages/swipe_learning.dart';
import 'pages/card_add.dart';
import 'pages/deck_view.dart';

void main() {
  runApp(MyApp());
}

/*
  TODO:
  - edit card add to also be able to edit (take in card, if null then add, if card then edit)
  - edit subject add to also be able to edit subjects, same idea as in card add
 */
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  List<Subject> data = _generateSampleData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SubjectView(
        title: 'Subjects',
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
      decks: [
        Deck(
          name: 'Maths Lesson 1',
          cards: List<int>.generate(13, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 10).toString()))
              .toList(),
        ),
        Deck(
          name: 'Maths Lesson 2',
          cards: List<int>.generate(43, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 20).toString()))
              .toList(),
        ),
      ],
    ),
    Subject(
      name: 'Japanese',
      decks: [
        Deck(
          name: 'Japanese Lesson 1',
          cards: List<int>.generate(111, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 30).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 2',
          cards: List<int>.generate(42, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 40).toString()))
              .toList(),
        ),
        Deck(
          name: 'Japanese Lesson 3',
          cards: List<int>.generate(19, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 50).toString()))
              .toList(),
        ),
      ],
    ),
    Subject(
      name: 'English',
      decks: [
        Deck(
          name: 'English Lesson 1',
          cards: List<int>.generate(133, (i) => i + 1)
              .map((i) =>
                  FlashCard(front: i.toString(), back: (i * 60).toString()))
              .toList(),
        ),
      ],
    ),
  ];
}
