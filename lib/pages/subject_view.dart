import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../common.dart';
import '../constants.dart' as constants;
import '../logic.dart';
import '../themes.dart';
import 'deck_view.dart';
import 'subject_mod.dart';
import 'swipe_learning.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({
    Key? key,
    required this.subjects,
  }) : super(key: key);

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
          title: AppLocalizations.of(context)!.subject_add,
          subject: Subject(name: _titleController.value.text, description: _descriptionController.value.text, decks: []),
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
          title: AppLocalizations.of(context)!.subject_edit,
          subject: widget.subjects[index],
        ),
      ),
    );

    if (result != null) updateWidget();
  }

  void _navigateToSubjectStudy(BuildContext context, int index) async {
    List<FlashCard> dueCards = widget.subjects[index].dueCardList;

    if (dueCards.isEmpty) {
      showSimpleSnackbarNotification(context, AppLocalizations.of(context)!.swipelearning_nocards);
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SwipeLearning(
          title: AppLocalizations.of(context)!.swipelearning_heading(widget.subjects[index].name),
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
    widget.subjects.add(Subject(name: _titleController.value.text, description: _descriptionController.value.text, decks: []));
    updateWidget();
  }

  Future<void> updateWidget() async {
    setState(() {});
  }

  _buildFocusMenuItems(BuildContext context, int index) {
    return [
      widget.subjects[index].description.isNotEmpty
          ? FocusedMenuItem(
              title: Flexible(
                child: Text(widget.subjects[index].description, style: Theme.of(context).textTheme.caption),
              ),
              onPressed: () => {},
            )
          : FocusedMenuItem(
              title: Flexible(
                child: Text(AppLocalizations.of(context)!.subject_description_empty,
                    style: Theme.of(context).textTheme.caption),
              ),
              onPressed: () {}),
      FocusedMenuItem(
        title: Text(AppLocalizations.of(context)!.open),
        trailingIcon: const Icon(Icons.open_in_new),
        onPressed: () => _navigateToDeckView(context, index),
      ),
      FocusedMenuItem(
        title: Text(AppLocalizations.of(context)!.edit),
        trailingIcon: const Icon(Icons.edit),
        onPressed: () => _navigateToSubjectEdit(context, index),
      ),
      FocusedMenuItem(
        title: Text(AppLocalizations.of(context)!.share),
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
        title: Text(
          AppLocalizations.of(context)!.delete,
          style: const TextStyle(color: Colors.redAccent),
        ),
        trailingIcon: const Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
        onPressed: () => _deleteSubject(index),
      ),
    ];
  }

  _buildBottomSheet(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: Row(
          children: [
            Text(AppLocalizations.of(context)!.subjects),
            const Spacer(),
            TextButton(
              onPressed: () {
                ThemeDataProvider themeDataProvider = Provider.of(context, listen: false);
                themeDataProvider.toggleTheme();
              },
              child: Text(
                constants.appLogoTitle,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => updateWidget(),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3.5 : 2.5),
            padding: const EdgeInsets.only(bottom: constants.edgeInsetFloatingActionButton),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.subjects.length,
            itemBuilder: (context, index) => FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width * 0.5,
              menuBoxDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              menuItemExtent: 35,
              menuItems: _buildFocusMenuItems(context, index),
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
        label: Text(AppLocalizations.of(context)!.subject_add),
        icon: const Icon(Icons.add),
        heroTag: 'add',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          isDismissible: true,
          isScrollControlled: true,
          enableDrag: true,
          builder: (context) => _buildBottomSheet(context),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(subject.imageLink),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SubjectCardContent(subject: subject, onStudy: onStudy),
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

  _buildSubjectCardInfo(context) {
    return Column(
      children: [
        Text(subject.name, style: Theme.of(context).textTheme.headline6),
        //const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.caption,
                children: [
                  const TextSpan(text: ''),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSubjectCardInfo(context),
        TextButton(
          child: Text(AppLocalizations.of(context)!.study),
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

  final Function? onCreateSubject;

  final TextEditingController titleController;
  final TextEditingController descriptionController;

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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.subject_name_filler,
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.subject_description_filler,
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
