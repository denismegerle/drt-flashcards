import 'package:flutter/material.dart';
import 'package:iternia/pages/subject_add.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';

class DeckView extends StatefulWidget {
  const DeckView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DeckView> createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  List<Deck> deckData = [
  ];

  /*
    Deck(name: 'Deck A'),
    Deck(name: 'Deck B'),
    Deck(name: 'Deck C'),
    Deck(name: 'Deck D'),
    Deck(name: 'Deck E'),
   */

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: deckData.length,
          itemBuilder: (context, index) => DeckCard(deck: deckData[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubjectAdd()),
          );
          */
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DeckCard extends StatelessWidget {
  const DeckCard({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.auto_awesome_motion_sharp),
              title: Text(deck.name),
              subtitle: Row(
                children: [
                  Text('Deck description (TODO)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
