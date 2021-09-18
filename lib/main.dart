import 'package:flutter/material.dart';
import 'logic.dart';
import 'pages/subject_view.dart';
import 'pages/subject_mod.dart';
import 'pages/swipe_learning.dart';
import 'pages/card_add.dart';
import 'pages/deck_view.dart';
import 'pages/image_search.dart';
import 'themes.dart';

void main() {
  runApp(MyApp());
}

/*
  TODO:
  - edit card add to also be able to edit (take in card, if null then add, if card then edit)
  - edit subject add to also be able to edit subjects, same idea as in card add
  - rename cards view and everything in there to flashcard view etc
  - refactor all smaller widgets to take onX methods and implement these only in the main state!
  - refactor names of card_add to smth add/edit represent, same with subject add
  - think about removing subject add view and only use bottom sheet to add cards, can still take img technically
  - refactor all navigation between screens to _navigate* methods


  - FINISHING TOUCHES: STANDARDIZE, MAKE ALL COMMAS PROPERLY, CLEANUP IMPORTS IN ALL FILES
 */
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  List<Subject> data = _generateSampleData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: cleanTheme,
      darkTheme: cleanThemeDark,
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
