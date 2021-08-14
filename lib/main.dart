import 'package:flutter/material.dart';
import 'logic.dart';
import 'pages/subject_view.dart';
import 'pages/subject_add.dart';
import 'pages/swipe_learning.dart';

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
      home: const SwipeLearning(
        title: 'Due Cards',
        cardList: [
          FlashCard(front: 'hello', back: 'hallo'),
          FlashCard(front: 'I', back: 'ich'),
          FlashCard(front: 'you', back: 'du'),
          FlashCard(front: 'he', back: 'er'),
          FlashCard(front: 'she', back: 'sie'),
          FlashCard(front: 'it', back: 'es'),
          FlashCard(front: 'we', back: 'wir'),
          FlashCard(front: 'you', back: 'ihr'),
          FlashCard(front: 'they', back: 'sie'),
          FlashCard(front: 'goodbye', back: 'tschüss'),
        ],
      ),
    );
  }
}
