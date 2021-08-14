import 'package:flutter/material.dart';
import '../logic.dart';
import '../utils_widgets.dart';

class SubjectEdit extends StatefulWidget {
  const SubjectEdit({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SubjectEdit> createState() => _SubjectEditState();
}

class _SubjectEditState extends State<SubjectEdit> {
  // Subject subject;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        //backgroundColor: Colors.transparent,
        //elevation: 0,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            FixedHeightImage(height: 175, image: NetworkImage(
                'https://www.world-insight.de/fileadmin/data/Headerbilder/landingpages/Japan_1440x600.jpg'))
          ],
        ),
      ),
    );
  }
}