import 'package:flutter/material.dart';
import 'package:iternia/pages/card_add.dart';
import 'package:iternia/pages/subject_add.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';

class CardsView extends StatefulWidget {
  const CardsView({Key? key, required this.title, required this.deck})
      : super(key: key);

  final String title;
  final Deck deck;

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: widget.deck.cards.length,
          itemBuilder: (context, index) => CardView(
            card: widget.deck.cards[index],
            onTap: () => _navigateToCardEdit(context, index),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCardAdd(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCardAdd(BuildContext context) async {
    final FlashCard? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CardAdd(title: 'Add card')),
    );

    if (result != null) {
      setState(() {
        widget.deck.cards.add(result);
      });
    }
  }

  void _navigateToCardEdit(BuildContext context, int index) async {
    final FlashCard? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardAdd(title: 'Edit card', flashCard: widget.deck.cards[index],)),
    );

    if (result != null) {
      setState(() {
        widget.deck.cards[index] = result;
      });
    }
  }
}

class CardView extends StatelessWidget {
  const CardView({Key? key, required this.card, this.onTap}) : super(key: key);

  final FlashCard card;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap!(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.auto_awesome_motion_sharp),
              title: Text(card.front),
              subtitle: Row(
                children: [
                  Text(card.back),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
