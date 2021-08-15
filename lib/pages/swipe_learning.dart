import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../logic.dart';
import '../common.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:flip_card/flip_card.dart';

class SwipeLearning extends StatefulWidget {
  const SwipeLearning({Key? key, required this.title, required this.cardList})
      : super(key: key);

  final String title;
  final List<FlashCard> cardList;

  @override
  State<SwipeLearning> createState() => _SwipeLearningState();
}

class _SwipeLearningState extends State<SwipeLearning> {
  double _learningProgress = 0.0;
  int _currentCardIndex = 0;

  void _nextCard() {
    setState(() {
      _learningProgress += 1.0 / widget.cardList.length;
      _currentCardIndex++;
      if (_currentCardIndex >= widget.cardList.length) {
        // Navigator.pop(context);
      }
    });
  }

  Widget _createStandardSplashCard(FlashCard card) {
    return SplashCard(
      /* key is just to force a new instance of SplashCard */
      key: Key(card.front),
      onSwipeRight: (details) => _nextCard(),
      front: SplashCardContent(content: Text(card.front, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold))),
      back: SplashCardContent(content: Text(card.back, style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        titleTextStyle: Theme.of(context).textTheme.headline6,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: Colors.grey,
            value: _learningProgress,
          ),
          Expanded(
            child:
                _createStandardSplashCard(widget.cardList[_currentCardIndex]),
          ),
        ],
      ),
    );
  }
}

class SplashCard extends StatelessWidget {
  const SplashCard(
      {Key? key,
      required this.front,
      required this.back,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.onSwipeUp})
      : super(key: key);

  final SplashCardContent front;
  final SplashCardContent back;
  final void Function(Offset finalPosition)? onSwipeLeft;
  final void Function(Offset finalPosition)? onSwipeRight;
  final void Function(Offset finalPosition)? onSwipeUp;

  @override
  Widget build(BuildContext context) {
    return Swipable(
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      onSwipeUp: onSwipeUp,
      onPositionChanged: (details) {},
      onSwipeCancel: (position, details) {},
      onSwipeDown: (finalPosition) {},
      onSwipeEnd: (position, details) {},
      onSwipeStart: (details) {},
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: front,
        back: back,
      ),
    );
  }
}

class SplashCardContent extends StatelessWidget {
  const SplashCardContent({Key? key, required this.content}) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0,),
          child: content,
        ),
      ),
    );
  }
}
