import 'package:flutter/material.dart';
import 'package:iternia/pages/card_add.dart';
import 'package:iternia/pages/subject_mod.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';

// TODO standardize and cleanup
class CardsView extends StatefulWidget {
  const CardsView({Key? key, required this.title, required this.subject, required this.deck}) : super(key: key);

  final String title;
  final Subject subject;
  final Deck deck;

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  late List<bool> isSelected;

  bool get inSelection {
    return isSelected.any((element) => element);
  }

  @override
  void initState() {
    isSelected = List.generate(widget.deck.cards.length, (index) => false);
    super.initState();
  }

  void _selectCard(int index) {
    setState(() {
      isSelected[index] = isSelected[index] ? false : true;
    });
  }

  void _selectAllCards() {
    setState(() {
      isSelected = isSelected.map((e) => true).toList();
    });
  }

  void _deleteSelectedCards() {
    var selectionMap = isSelected.asMap().map((key, value) => MapEntry(key, value));
    selectionMap.removeWhere((key, value) => !value);
    var selectionList = selectionMap.keys.toList().reversed;

    setState(() {
      for (var selectedCardIndex in selectionList) {
        widget.deck.cards.removeAt(selectedCardIndex);
      }
      isSelected = widget.deck.cards.map((e) => false).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Text(widget.title),
        actions: inSelection
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () => _selectAllCards(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteSelectedCards(),
                )
              ]
            : <Widget>[],
      ),
      body: Center(
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: widget.deck.cards.length,
          itemBuilder: (context, index) => Container(
            decoration: isSelected[index] ? BoxDecoration(color: Colors.grey[300]) : const BoxDecoration(),
            child: CardView(
              card: widget.deck.cards[index],
              onTap: () => inSelection ? _selectCard(index) : _navigateToCardEdit(context, index),
              onLongPress: () => _selectCard(index),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add card'),
        icon: const Icon(Icons.add),
        heroTag: 'add',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () => _navigateToCardAdd(context),
      ),
    );
  }

  void _navigateToCardAdd(BuildContext context) async {
    final FlashCard? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardAdd(title: 'Add card', subject: widget.subject,)),
    );

    if (result != null) {
      setState(() {
        widget.deck.cards.add(result);
        isSelected = List.generate(widget.deck.cards.length, (index) => false);
      });
      _navigateToCardAdd(context);
    }
  }

  void _navigateToCardEdit(BuildContext context, int index) async {
    final FlashCard? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CardAdd(
                title: 'Edit card',
                subject: widget.subject,
                flashCard: widget.deck.cards[index],
              )),
    );

    if (result != null) {
      setState(() {
        widget.deck.cards[index] = result;
      });
    }
  }
}

class CardView extends StatelessWidget {
  const CardView({Key? key, required this.card, required this.onTap, required this.onLongPress}) : super(key: key);

  final FlashCard card;
  final Function onTap;
  final Function onLongPress;

  Widget _buildDueCircle(BuildContext context) {
    Duration dueTime = Duration(minutes: card.dueTime);
    String dueTimeString = getOptimalDurationString(dueTime);

    return Container(
      width: MediaQuery.of(context).size.width * 0.125,
      height: MediaQuery.of(context).size.width * 0.125,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: dueTime.isNegative ? Colors.red.withOpacity(0.3) : Colors.yellow.withOpacity(0.3),
          shape: BoxShape.circle),
      child: dueTime.isNegative ? const Icon(Icons.quickreply) : Text(dueTimeString),
    );
  }

  Widget _buildCardProgressIndicator(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.125,
      height: MediaQuery.of(context).size.width * 0.0375,
      child: LinearProgressIndicator(
        value: card.progress,
        color:
            HSVColor.lerp(HSVColor.fromColor(Colors.red), HSVColor.fromColor(Colors.green), card.progress)!.toColor(),
        backgroundColor: Colors.grey.withOpacity(0.3),
        semanticsLabel: 'Linear progress indicator',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: _buildDueCircle(context),
              title: Text(card.front),
              subtitle: Text(card.back),
              trailing: _buildCardProgressIndicator(context),
            ),
          ],
        ),
      ),
    );
  }
}
