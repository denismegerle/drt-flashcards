import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'constants.dart' as constants;

part 'logic.g.dart';

enum FlashCardOrder { none, random }
enum FlashCardSwipe { left, right, up }

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Database {
  List<Subject> subjects;

  Database({required this.subjects});

  factory Database.fromJson(Map<String, dynamic> json) => _$DatabaseFromJson(json);

  Map<String, dynamic> toJson() => _$DatabaseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Subject {
  String name;
  String description;
  List<Deck> decks;
  String imageLink;

  bool easyBonus;
  FlashCardOrder learningOrder;
  int initialSpreadTime;
  double initialSpreadFactor;

  @RangeValuesSerializer()
  RangeValues spreadFactorRange;

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
    this.imageLink = constants.sampleImageLink,
    this.easyBonus = true,
    this.learningOrder = FlashCardOrder.none,
    this.initialSpreadTime = 10, // in minutes
    this.spreadFactorRange = const RangeValues(2.0, 3.0),
    this.initialSpreadFactor = 2.5,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
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

  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  Map<String, dynamic> toJson() => _$DeckToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FlashCard {
  String front;
  String back;

  int lastReviewTime;
  int spreadTime; // spread time in minutes
  double spreadFactor;

  bool get isDue {
    return dueTime < 0;
  }

  int get nextReviewTime {
    return lastReviewTime + spreadTime;
  }

  int get dueTime {
    return nextReviewTime - (DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerMinute).round();
  }

  double get progress {
    /* 10 mins are not good enough, 1 year spread time means u got the card */
    if (spreadTime < 10) return 0.0;
    if (spreadTime > constants.daysPerYear * Duration.minutesPerDay) return 1.0;

    return spreadTime / (constants.daysPerYear * Duration.minutesPerDay);
  }

  FlashCard({
    this.front = '',
    this.back = '',
    this.lastReviewTime = 0,
    this.spreadTime = 10 * 60,
    this.spreadFactor = 2.5,
  });

  FlashCard clone({
    String? front,
    String? back,
    int? lastReviewTime,
    int? spreadTime,
    double? spreadFactor,
  }) {
    return FlashCard(
      front: front ?? this.front,
      back: back ?? this.back,
      lastReviewTime: lastReviewTime ?? this.lastReviewTime,
      spreadTime: spreadTime ?? this.spreadTime,
      spreadFactor: spreadFactor ?? this.spreadFactor,
    );
  }

  void update(Subject subject, FlashCardSwipe swipeDirection) {
    /* just a random algorithm, did not research what is best for remembering elements */
    lastReviewTime = (DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerMinute).round();

    switch (swipeDirection) {
      case FlashCardSwipe.right:
        spreadTime = (spreadTime * spreadFactor).round();
        spreadFactor *= 1.1;
        if (spreadFactor > subject.spreadFactorRange.end) spreadFactor = subject.spreadFactorRange.end;
        break;
      case FlashCardSwipe.left:
        spreadTime = subject.initialSpreadTime;
        spreadFactor *= 0.9;
        if (spreadFactor < subject.spreadFactorRange.start) spreadFactor = subject.spreadFactorRange.start;
        break;
      case FlashCardSwipe.up:
        if (subject.easyBonus) {
          spreadTime = (spreadTime * spreadFactor * 2.0).round();
          spreadFactor *= 1.2;
          if (spreadFactor > subject.spreadFactorRange.end) spreadFactor = subject.spreadFactorRange.end;
        } else {
          spreadTime = (spreadTime * spreadFactor).round();
          spreadFactor *= 1.2;
          if (spreadFactor > subject.spreadFactorRange.end) spreadFactor = subject.spreadFactorRange.end;
        }
        break;
    }
  }

  factory FlashCard.fromJson(Map<String, dynamic> json) => _$FlashCardFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardToJson(this);
}

class RangeValuesSerializer implements JsonConverter<RangeValues, Map<String, dynamic>> {
  const RangeValuesSerializer();

  @override
  RangeValues fromJson(Map<String, dynamic> json) => RangeValues(json['start'], json['end']);

  @override
  Map<String, dynamic> toJson(RangeValues value) => {
        'start': value.start,
        'end': value.end,
      };
}
