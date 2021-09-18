import 'package:flutter/material.dart';
import 'package:iternia/pages/subject_mod.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';
import 'package:iternia/pages/swipe_learning.dart';

import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../constants.dart' as constants;
import 'cards_view.dart';

// TODO standardize and cleanup
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

  void _navigateToCardsView(BuildContext context, int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardsView(
          title: widget.subject.decks[index].name,
          subject: widget.subject,
          deck: widget.subject.decks[index],
        ),
      ),
    );
  }

  void _navigateToDeckStudy(BuildContext context, int index) async {
    List<FlashCard> dueCards = widget.subject.decks[index].dueCardList;

    if (dueCards.isEmpty) {
      showSimpleSnackbarNotification(context, 'Nothing to study');
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SwipeLearning(
          title: 'Learning ${widget.subject.decks[index].name}',
          subject: widget.subject,
          cardList: dueCards,
        ),
      ),
    );
    updateWidget();
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

  void _deleteDeck(int index) {
    setState(() {
      widget.subject.decks.removeAt(index);
    });
  }

  Future<void> updateWidget() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Text(widget.title),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => updateWidget(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: constants.edgeInsetFloatingActionButton),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.subject.decks.length,
            itemBuilder: (context, index) => FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width,
              menuBoxDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              menuItemExtent: 45,
              menuOffset: 10.0,
              menuItems: [
                widget.subject.decks[index].description.isNotEmpty
                    ? FocusedMenuItem(
                  title: Text(widget.subject.decks[index].description,
                      style: Theme.of(context).textTheme.caption),
                  onPressed: () => {},
                )
                    : FocusedMenuItem(
                    title: Text('description empty...',
                        style: Theme.of(context).textTheme.caption),
                    onPressed: () {}),
                FocusedMenuItem(
                  title: const Text("Open"),
                  trailingIcon: const Icon(Icons.open_in_new),
                  onPressed: () => _navigateToCardsView(context, index),
                ),
                FocusedMenuItem(
                  title: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailingIcon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _deleteDeck(index),
                ),
              ],
              onPressed: () {},
              child: DeckCard(
                deck: widget.subject.decks[index],
                onTap: () => _navigateToCardsView(context, index),
                onStudy: () => _navigateToDeckStudy(context, index),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add deck'),
        icon: const Icon(Icons.add),
        heroTag: 'add',
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
      ),
    );
  }
}

class DeckCard extends StatelessWidget {
  const DeckCard({Key? key, required this.deck, required this.onTap, required this.onStudy})
      : super(key: key);

  final Deck deck;
  final Function onTap;
  final Function onStudy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome_motion_sharp),
                  Text(
                    '${deck.amountOfDueCards}/${deck.amountOfCards}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              title: Text(deck.name),
              subtitle: Wrap(
                children: [
                  Text(deck.description),
                ],
              ),
              trailing: TextButton(
                child: Text('Study'),
                onPressed: () => onStudy(),
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
