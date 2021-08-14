import 'package:flutter/material.dart';
import 'package:iternia/pages/subject_add.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/utils_widgets.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  List<Subject> subjectData = [
    Subject('Subject A', 42, 20),
    Subject('Subject B', 13, 123),
    Subject('Subject C', 3, 42),
    Subject('Subject D', 9, 99),
    Subject('Subject E', 33, 1010)
  ];

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
          itemCount: subjectData.length,
          itemBuilder: (context, index) =>
              SubjectCard(subject: subjectData[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubjectAdd()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({Key? key, required this.subject}) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Card(
        /* rounded corners */
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(12.0),
        /* card image and description */
        child: InkWell(
          onTap: () => {},
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FixedHeightImage(
                height: 125,
                image: subject.image,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(subject.name,
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.caption,
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.auto_stories_outlined,
                                  color: Colors.grey,
                                  size: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .fontSize,
                                ),
                              ),
                              TextSpan(
                                  text: ' ${subject.amountOfDecks}  \u2022 '),
                              WidgetSpan(
                                child: Icon(
                                  Icons.auto_awesome_motion_sharp,
                                  color: Colors.grey,
                                  size: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .fontSize,
                                ),
                              ),
                              TextSpan(text: ' ${subject.amountOfCards}'),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text('XXX', style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
