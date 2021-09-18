import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'swipe_learning.dart';

import '../common.dart';
import '../logic.dart';
import '../constants.dart' as constants;
import 'deck_view.dart';
import 'subject_mod.dart';

// TODO standardize and cleanup

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

  void _navigateToSubjectCreation(BuildContext context) async {
    final Subject? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectMod(
          title: 'Add subject',
          subject: Subject(name: _titleController.value.text, description: _descriptionController.value.text),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        widget.subjects.add(result);
      });
    }
  }

  void _navigateToDeckView(BuildContext context, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckView(
          title: widget.subjects[index].name,
          subject: widget.subjects[index],
        ),
      ),
    );

    updateWidget();
  }

  void _navigateToSubjectEdit(BuildContext context, int index) async {
    final Subject? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectMod(
          title: 'Edit subject',
          subject: widget.subjects[index],
        ),
      ),
    );

    if (result != null) updateWidget();
  }

  void _navigateToSubjectStudy(BuildContext context, int index) async {
    List<FlashCard> dueCards = widget.subjects[index].dueCardList;

    if (dueCards.isEmpty) {
      showSimpleSnackbarNotification(context, 'Nothing to study');
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SwipeLearning(
          title: 'Learning ${widget.subjects[index].name}',
          subject: widget.subjects[index],
          cardList: dueCards,
        ),
      ),
    );

    updateWidget();
  }

  void _deleteSubject(int index) {
    widget.subjects.removeAt(index);
    updateWidget();
  }

  void _createSubject() {
    widget.subjects.add(Subject(name: _titleController.value.text, description: _descriptionController.value.text));
    updateWidget();
  }

  Future<void> updateWidget() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Row(
          children: [
            Text(widget.title),
            const Spacer(),
            TextButton(
                onPressed: () {  },
                child: Text(
              '𝕚𝕥𝕖𝕣𝕟𝕚𝕒',
              style: Theme.of(context).textTheme.headline5,
            ),),
          ],
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => updateWidget(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: constants.edgeInsetFloatingActionButton),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.subjects.length,
            itemBuilder: (context, index) => FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width,
              menuBoxDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              menuItemExtent: 45,
              menuOffset: 10.0,
              menuItems: [
                widget.subjects[index].description.isNotEmpty
                    ? FocusedMenuItem(
                        title: Text(widget.subjects[index].description, style: Theme.of(context).textTheme.caption),
                        onPressed: () => {},
                      )
                    : FocusedMenuItem(
                        title: Text('description empty...', style: Theme.of(context).textTheme.caption),
                        onPressed: () {}),
                FocusedMenuItem(
                  title: const Text("Open"),
                  trailingIcon: const Icon(Icons.open_in_new),
                  onPressed: () => _navigateToDeckView(context, index),
                ),
                FocusedMenuItem(
                  title: const Text("Edit"),
                  trailingIcon: const Icon(Icons.edit),
                  onPressed: () => _navigateToSubjectEdit(context, index),
                ),
                FocusedMenuItem(
                  title: const Text("Share"),
                  trailingIcon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO need to implement export feature
                    const snackBar = SnackBar(
                      content: Text('Export not yet implemented'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
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
                  onPressed: () => _deleteSubject(index),
                ),
              ],
              onPressed: () {},
              child: SubjectCard(
                subject: widget.subjects[index],
                onClick: () => _navigateToDeckView(context, index),
                onStudy: () => _navigateToSubjectStudy(context, index),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add subject'),
        icon: const Icon(Icons.add),
        heroTag: 'add',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          isDismissible: true,
          isScrollControlled: true,
          enableDrag: true,
          builder: (context) {
            return NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if (notification.extent >= 0.6) {
                  _navigateToSubjectCreation(context);
                }
                return true;
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) => ListView(
                    controller: scrollController,
                    children: [
                      SubjectBottomSheet(
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        onCreateSubject: () {
                          _createSubject();
                          Navigator.pop(context);
                          _titleController.clear();
                          _descriptionController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({Key? key, required this.subject, required this.onClick, required this.onStudy}) : super(key: key);

  final Function onClick;
  final Function onStudy;

  final Subject subject;
  final double subjectCardSizeFactor = 0.375;
  final double imageHeightFactor = 0.55;
  final double infoHeightFactor = 0.33;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * subjectCardSizeFactor,
      child: Card(
        /* rounded corners */
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(12.0),
        /* card image and description */
        child: InkWell(
          onTap: () => onClick(),
          //onLongPress: () => _navigateToSubjectEdit(context),
          child: Column(
            children: [
              FixedHeightImage(
                height: MediaQuery.of(context).size.height * subjectCardSizeFactor * imageHeightFactor,
                image: subject.imageLink,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * subjectCardSizeFactor * infoHeightFactor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SubjectCardContent(subject: subject, onStudy: onStudy),
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
  const SubjectCardContent({Key? key, required this.subject, required this.onStudy}) : super(key: key);

  final Function onStudy;

  final Subject subject;

  InlineSpan _buildDueNotification(BuildContext context) {
    return subject.amountOfDueCards == 0
        ? WidgetSpan(
            child: Icon(
              Icons.check_circle_sharp,
              color: Colors.green,
              size: Theme.of(context).textTheme.caption!.fontSize,
            ),
          )
        : TextSpan(
            text: ' ${subject.amountOfDueCards}',
            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.red),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
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
                      TextSpan(text: ' ${subject.amountOfCards}  \u2022 '),
                      _buildDueNotification(context),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        TextButton(
          child: const Text('Study'),
          onPressed: () => onStudy(),
        ),
      ],
    );
  }
}

class SubjectBottomSheet extends StatelessWidget {
  const SubjectBottomSheet(
      {Key? key, required this.titleController, required this.descriptionController, this.onCreateSubject})
      : super(key: key);

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Function? onCreateSubject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.01,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Theme.of(context).primaryColor),
            ),
          ),
          ListTile(
            title: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Subject name',
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Subject description',
              ),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => onCreateSubject!(),
                icon: const Icon(Icons.send),
              )
            ],
          ),
        ],
      ),
    );
  }
}
