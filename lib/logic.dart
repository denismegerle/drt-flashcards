import 'package:flutter/cupertino.dart';

class Subject {
  final String name;
  final int amountOfDecks;  // TODO remove and change to list...
  final int amountOfCards;
  final ImageProvider image = const NetworkImage(
      'https://www.world-insight.de/fileadmin/data/Headerbilder/landingpages/Japan_1440x600.jpg');

  // TODO image (suggest saving thumbnails and using these, much smaller versions instead)
  // TODO add decks, flashcards, more infos about it
  // more infos: last learned, ...
  // since we only add online images we might aswell only save the link to the image!

  Subject(this.name, this.amountOfDecks, this.amountOfCards);
}

class Deck {}
class FlashCard {}