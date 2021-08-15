import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../logic.dart';

class CardAdd extends StatefulWidget {
  const CardAdd({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CardAdd> createState() => _CardAddState();
}

class _CardAddState extends State<CardAdd> {
  late TextEditingController _frontController;
  late TextEditingController _backController;

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController();
    _backController = TextEditingController();
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
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          titleTextStyle: Theme.of(context).textTheme.headline6,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Text('Front',
                      style: Theme.of(context).textTheme.headline6)),
              Tab(
                  icon: Text('Back',
                      style: Theme.of(context).textTheme.headline6)),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {},
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
                        new InputDecoration.collapsed(hintText: 'front side content ...'),
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
                    new InputDecoration.collapsed(hintText: 'back side content ...'),
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
