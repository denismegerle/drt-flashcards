import 'package:flutter/material.dart';

import '../common.dart';
import '../logic.dart';
import 'image_search.dart';

class SubjectAdd extends StatefulWidget {
  const SubjectAdd({Key? key, required this.title, required this.subject})
      : super(key: key);

  final String title;
  final Subject subject;

  @override
  State<SubjectAdd> createState() => _SubjectAddState();
}

class _SubjectAddState extends State<SubjectAdd> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  static const changeImageButtonText = 'Change Image';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.name);
    _descriptionController = TextEditingController(text: widget.subject.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _navigateToChangeImageLink(BuildContext context) async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageSearch()),
    );

    if (result != null) {
      setState(() {
        widget.subject.imageLink = result;
      });
    }
  }

  Widget _buildTopImage(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        FixedHeightImage(
          height: MediaQuery.of(context).size.height * 0.33,
          image: widget.subject.imageLink,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () => _navigateToChangeImageLink(context),
            child: const Text(changeImageButtonText),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
                hintText: 'title...'
            ),
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration.collapsed(
                hintText: 'description...'
            ),
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsHeading(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Advanced',
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.caption?.copyWith(
            fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10.0),
      child: ListView(
        /* this is to scroll through the whole page when scrolling, instead of only the list view */
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          ListTile(
            title: const Text('Enable Easy-Bonus'),
            subtitle: const Text('Spread increase for simple flashcards'),
            trailing: Switch(
                value: widget.subject.easyBonus,
                onChanged: (value) {
                  setState(() {
                    widget.subject.easyBonus = value;
                  });
                }),
          ),
          ListTile(
            title: const Text('FlashCard Order'),
            subtitle: Text(widget.subject.learningOrder.toString()),
            trailing: PopupMenuButton<FlashCardOrder>(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: FlashCardOrder.none,
                    child: Text(FlashCardOrder.none.toString()),
                  ),
                  PopupMenuItem(
                    value: FlashCardOrder.random,
                    child: Text(FlashCardOrder.random.toString()),
                  )
                ];
              },
              onSelected: (FlashCardOrder value) {
                setState(() {
                  widget.subject.learningOrder = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Spread Factor Range'),
            subtitle: RangeSlider(
              values: widget.subject.spreadFactorRange,
              min: 1.0,
              max: 5.0,
              divisions: 40,
              labels: RangeLabels('${widget.subject.spreadFactorRange.start}',
                  '${widget.subject.spreadFactorRange.end}'),
              onChanged: (value) {
                setState(() {
                  if (value.start < widget.subject.defaultSpreadFactor &&
                      value.end > widget.subject.defaultSpreadFactor) {
                    widget.subject.spreadFactorRange = value;
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Default Spread Factor'),
            subtitle: Slider(
              value: widget.subject.defaultSpreadFactor,
              min: widget.subject.spreadFactorRange.start,
              max: widget.subject.spreadFactorRange.end,
              label: '${widget.subject.defaultSpreadFactor}',
              onChanged: (value) {
                setState(() {
                  widget.subject.defaultSpreadFactor = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        title: Text(widget.title),
        context: context,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                widget.subject.name = _titleController.value.text;
                Navigator.pop(context, widget.subject);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTopImage(context),
            _buildTitleTextField(context),
            _buildAdvancedSettingsHeading(context),
            _buildAdvancedSettings(context),
          ],
        ),
      ),
    );
  }
}
