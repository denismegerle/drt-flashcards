import 'package:flutter/material.dart';
import 'package:iternia/pages/subject_add.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';

import 'cards_view.dart';

class DeckView extends StatefulWidget {
  const DeckView({Key? key, required this.title, required this.subject})
      : super(key: key);

  final String title;
  final Subject subject;

  @override
  State<DeckView> createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _navigateToCardsView(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardsView(
          title: widget.subject.decks[index].name,
          deck: widget.subject.decks[index],
        ),
      ),
    );
  }

  void _createDeck() {
    Navigator.pop(context);
    setState(() {
      widget.subject.decks
          .add(Deck(name: _titleController.value.text, cards: <FlashCard>[]));
      _titleController.clear();
      _descriptionController.clear();
    });
  }

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
          itemCount: widget.subject.decks.length,
          itemBuilder: (context, index) => DeckCard(
            deck: widget.subject.decks[index],
            onTap: () => _navigateToCardsView(context, index),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              isDismissible: true,
              isScrollControlled: true,
              builder: (context) {
                return DeckBottomSheet(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  onCreateDeck: _createDeck,
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeckCard extends StatelessWidget {
  const DeckCard({Key? key, required this.deck, this.onTap}) : super(key: key);

  final Deck deck;
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
              title: Text(deck.name),
              subtitle: Row(
                children: [
                  Text('Deck description (TODO)'),
                ],
              ),
              trailing: TextButton(
                child: Text('Study'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeckBottomSheet extends StatelessWidget {
  const DeckBottomSheet(
      {Key? key,
      required this.titleController,
      required this.descriptionController,
      this.onCreateDeck})
      : super(key: key);

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Function? onCreateDeck;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'deck name...',
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'deck description...',
              ),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => onCreateDeck!(),
                icon: const Icon(Icons.send),
              )
            ],
          )
        ],
      ),
    );
  }
}
