import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';

enum FlashCardOrder { none, random }
enum FlashCardSwipe { left, right, up }

// TODO standardize and cleanup
class Subject {
  String name;
  String description;
  List<Deck> decks;
  String imageLink;

  bool easyBonus;
  FlashCardOrder learningOrder;
  int initialSpreadTime;
  RangeValues spreadFactorRange;
  double initialSpreadFactor;

  static const sampleImageLink =
      'https://www.world-insight.de/fileadmin/data/Headerbilder/landingpages/Japan_1440x600.jpg';

  int get amountOfDecks {
    return decks.length;
  }

  int get amountOfCards {
    return decks.fold(0, (previousValue, element) => previousValue + element.amountOfCards);
  }

  int get amountOfDueCards {
    return decks.fold(0, (previousValue, element) => previousValue + element.amountOfDueCards);
  }

  List<FlashCard> get dueCardList {
    return decks.fold(<FlashCard>[], (previousValue, element) => previousValue + element.dueCardList);
  }

  Subject({
    this.name = '',
    this.description = '',
    this.decks = const <Deck>[],
    this.imageLink = sampleImageLink,
    this.easyBonus = true,
    this.learningOrder = FlashCardOrder.none,
    this.initialSpreadTime = 10, // in minutes
    this.spreadFactorRange = const RangeValues(2.0, 3.0),
    this.initialSpreadFactor = 2.5,
  });
}

class Deck {
  String name;
  String description;
  List<FlashCard> cards;

  int get amountOfCards {
    return cards.length;
  }

  int get amountOfDueCards {
    return cards.fold(0, (previousValue, element) => previousValue + (element.isDue ? 1 : 0));
  }

  List<FlashCard> get dueCardList {
    return cards.where((value) => value.isDue).toList();
  }

  Deck({
    this.name = '',
    this.description = '',
    this.cards = const <FlashCard>[],
  });
}

class FlashCard {
  String front;
  String back;

  int lastReviewTime;
  int spreadTime; // spread time in minutes
  double spreadFactor;

  bool get isDue {
    return true;
  } // TODO calc this based on whatever algorithm chosen..., probably need getter then

  int get nextReviewTime {
    return lastReviewTime + spreadTime;
  }

  int get dueTime {
    // TODO make getter dueTime
    return 20000; // TODO proper calculation
  }

  double get progress {
    return Random().nextDouble(); // prob dependend on spread time?
  }


  FlashCard({
    this.front = '',
    this.back = '',
    this.lastReviewTime = 0,
    this.spreadTime = 10 * 60,
    this.spreadFactor = 2.5,
  });

  FlashCard clone({String? front, String? back, int? lastReviewTime, int? spreadTime, double? spreadFactor,}) {
    return FlashCard(
      front: front ?? this.front,
      back: back ?? this.back,
      lastReviewTime: lastReviewTime ?? this.lastReviewTime,
      spreadTime: spreadTime ?? this.spreadTime,
      spreadFactor: spreadFactor ?? this.spreadFactor,
    );
  }

  void update(Subject subject, FlashCardSwipe swipeDirection) {
    // updated based on swipe direction and subject (constraints, bonus etc)
    // isDue = false; // TODO obviously change...

    // TODO algorithm...
    /*
      1. update nextReviewTime (
     */
  }
}
