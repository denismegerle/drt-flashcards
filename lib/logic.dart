import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FlashCardOrder { none, random }

class Subject {
  String name;
  String description;
  List<Deck> decks;
  String imageLink;

  bool easyBonus;
  FlashCardOrder learningOrder;
  RangeValues spreadFactorRange;
  double defaultSpreadFactor;

  static const sampleImageLink =
      'https://www.world-insight.de/fileadmin/data/Headerbilder/landingpages/Japan_1440x600.jpg';

  int get amountOfDecks {
    return decks.length;
  }

  int get amountOfCards {
    return decks.fold(
        0, (previousValue, element) => previousValue + element.amountOfCards);
  }

  int get amountOfDueCards {
    return decks.fold(0,
        (previousValue, element) => previousValue + element.amountOfDueCards);
  }

  Subject({
    this.name = '',
    this.description = '',
    this.decks = const <Deck>[],
    this.imageLink = sampleImageLink,
    this.easyBonus = true,
    this.learningOrder = FlashCardOrder.none,
    this.spreadFactorRange = const RangeValues(2.0, 3.0),
    this.defaultSpreadFactor = 2.5,
  });
}

class Deck {
  final String name;

  List<FlashCard> cards;

  int get amountOfCards {
    return cards.length;
  }

  int get amountOfDueCards {
    return cards.fold(
        0, (previousValue, element) => previousValue + (element.isDue ? 1 : 0));
  }

  Deck({required this.name, required this.cards});
}

class FlashCard {
  String front = '';
  String back = '';
  int lastReviewTime = 0;
  double spreadFactor = 2.5;

  bool get isDue {
    return true; // TODO calc this based on whatever algorithm chosen...
  }

  FlashCard.fresh();

  FlashCard({required this.front, required this.back});

  clone() => FlashCard(front: front, back: back);
}
