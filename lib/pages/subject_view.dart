import 'package:flutter/material.dart';
import 'package:iternia/pages/subject_add.dart';
import 'package:iternia/logic.dart';
import 'package:iternia/common.dart';

class SubjectView extends StatefulWidget {
  SubjectView({
    Key? key,
    required this.title,
    required this.subjects,
  }) : super(key: key);

  final String title;
  List<Subject> subjects;

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: widget.subjects.length,
          itemBuilder: (context, index) =>
              SubjectCard(subject: widget.subjects[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubjectAdd()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({Key? key, required this.subject}) : super(key: key);

  final Subject subject;

  /*
  Widget _buildCardInformation() {

  }
  */

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
                child: SubjectCardContent(subject: subject),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCardContent extends StatelessWidget {
  const SubjectCardContent({Key? key, required this.subject}) : super(key: key);

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(subject.name, style: Theme.of(context).textTheme.headline6),
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
                      size: Theme.of(context).textTheme.caption!.fontSize,
                    ),
                  ),
                  TextSpan(text: ' ${subject.amountOfDecks}  \u2022 '),
                  WidgetSpan(
                    child: Icon(
                      Icons.auto_awesome_motion_sharp,
                      color: Colors.grey,
                      size: Theme.of(context).textTheme.caption!.fontSize,
                    ),
                  ),
                  TextSpan(text: ' ${subject.amountOfCards}'),
                ],
              ),
            ),
            const Spacer(),
            Text('<XXX>', style: Theme.of(context).textTheme.caption),
          ],
        ),
      ],
    );
  }
}
