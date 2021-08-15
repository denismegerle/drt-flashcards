import 'package:flutter/material.dart';

import '../common.dart';
import '../logic.dart';
import 'deck_view.dart';
import 'subject_add.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({
    Key? key,
    required this.title,
    required this.subjects,
  }) : super(key: key);

  final String title;
  final List<Subject> subjects;

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  void _navigateToSubjectCreation(BuildContext context) async {
    final Subject? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SubjectAdd(
                title: 'Add subject',
                subject: Subject.fresh(),
              )),
    );

    if (result != null) {
      setState(() {
        widget.subjects.add(result);
      });
    }
  }

  void _updateState() {
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
        child: ListView.builder(
          itemCount: widget.subjects.length,
          itemBuilder: (context, index) =>
              SubjectCard(subject: widget.subjects[index], updateCallback: _updateState,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToSubjectCreation(context),
        label: const Text('Add subject'),
        icon: const Icon(Icons.add),
        heroTag: 'add',
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({Key? key, required this.subject, this.updateCallback}) : super(key: key);

  final Function? updateCallback;

  final Subject subject;
  final double subjectCardSizeFactor = 0.375;
  final double imageHeightFactor = 0.55;
  final double infoHeightFactor = 0.33;

  void _navigateToDeckView(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeckView(
                title: subject.name,
                subject: subject,
              )),
    );
  }

  void _navigateToSubjectEdit(context) async {
    final Subject? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SubjectAdd(
                title: 'Edit subject',
                subject: subject,
              )),
    );

    if (result != null) {
      updateCallback!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * subjectCardSizeFactor,
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
          onTap: () => _navigateToDeckView(context),
          onLongPress: () => _navigateToSubjectEdit(context),
          child: Column(
            children: [
              FixedHeightImage(
                height: MediaQuery.of(context).size.height *
                    subjectCardSizeFactor *
                    imageHeightFactor,
                image: subject.imageLink,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    subjectCardSizeFactor *
                    infoHeightFactor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SubjectCardContent(subject: subject),
                ),
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
        const Spacer(),
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




/*
old shit
floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToSubjectCreation(context),
        label: const Text('Add subject'),
        icon: const Icon(Icons.add),
        heroTag: 'add',
      ),
      
 */