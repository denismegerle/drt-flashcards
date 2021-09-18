import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../logic.dart';
import '../common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO standardize and cleanup
class FlashCardMod extends StatefulWidget {
  FlashCardMod({Key? key, required this.title, required this.subject, this.flashCard}) : super(key: key);

  final String title;
  final Subject subject;
  final FlashCard? flashCard;

  @override
  State<FlashCardMod> createState() => _FlashCardModState();
}

class _FlashCardModState extends State<FlashCardMod> {
  late TextEditingController _frontController;
  late TextEditingController _backController;
  late FlashCard newCard;

  @override
  void initState() {
    super.initState();
    if (widget.flashCard != null) {
      _frontController = TextEditingController(text: widget.flashCard!.front);
      _backController = TextEditingController(text: widget.flashCard!.back);
    } else {
      _frontController = TextEditingController();
      _backController = TextEditingController();
    }

    newCard = widget.flashCard != null ? widget.flashCard!.clone() : FlashCard();
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MinimalistAppBar(
          title: Text(widget.title),
          context: context,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Text(AppLocalizations.of(context)!.card_front,
                      style: Theme.of(context).textTheme.headline6)),
              Tab(
                  icon: Text(AppLocalizations.of(context)!.card_back,
                      style: Theme.of(context).textTheme.headline6)),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  newCard.front = _frontController.value.text;
                  newCard.back = _backController.value.text;
                  Navigator.pop(context, newCard);
                },
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _frontController,
                    decoration:
                        InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.card_front_filler),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                    onSubmitted: (String value) {},
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _backController,
                    decoration:
                    InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.card_back_filler),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                    onSubmitted: (String value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
