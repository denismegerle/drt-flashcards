import 'package:flutter/cupertino.dart';

class Subject {
  String name = 'Untitled';
  List<Deck> decks = <Deck>[];
  String imageLink = sampleImageLink;

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

  Subject.fresh();
  Subject({required this.name, required this.decks});

// TODO image (suggest saving thumbnails and using these, much smaller versions instead)
// TODO add decks, flashcards, more infos about it
// more infos: last learned, ...
// since we only add online images we might aswell only save the link to the image!
// additional information:
// - creation date
  final ImageProvider image = const NetworkImage(
      'https://www.world-insight.de/fileadmin/data/Headerbilder/landingpages/Japan_1440x600.jpg');
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

  bool get isDue {
    return true; // TODO calc this based on whatever algorithm chosen...
  }

  FlashCard.fresh();
  FlashCard({required this.front, required this.back});

  clone() => FlashCard(front: front, back: back);

/*
  String name;
  int lastReviewTime;
  double forgettingRate;
  double q, alpha, beta;
  */
// FlashCard(...)
// computeForgettingRate
// computeRecallProbability
// computeReviewingIntensity
// sampleNextReviewTime
//
}
