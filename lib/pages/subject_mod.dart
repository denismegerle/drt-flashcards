import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common.dart';
import '../logic.dart';
import 'image_search.dart';

class SubjectMod extends StatefulWidget {
  const SubjectMod({Key? key, required this.title, required this.subject}) : super(key: key);

  final String title;
  final Subject subject;

  @override
  State<SubjectMod> createState() => _SubjectModState();
}

class _SubjectModState extends State<SubjectMod> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

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

  void _navigateToSpreadTimeEdit(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
    String? newSpreadTimeString = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.subject_settings_initial_spread_time,
                    hintText: AppLocalizations.of(context)!.subject_settings_initial_spread_time_hint),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                Navigator.pop(context, _controller.text);
              }),
        ],
      ),
    );

    if (newSpreadTimeString == null) return;
    int? newSpreadTime = int.tryParse(newSpreadTimeString);
    if (newSpreadTime == null || newSpreadTime < 1) return;

    setState(() {
      widget.subject.initialSpreadTime = newSpreadTime;
    });
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
            child: Text(AppLocalizations.of(context)!.subject_settings_changeimage),
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
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.subject_name_filler),
            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.subject_description_filler),
            style: Theme.of(context).textTheme.caption?.copyWith(fontWeight: FontWeight.bold),
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
        AppLocalizations.of(context)!.subject_settings_advanced,
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
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
            title: Text(AppLocalizations.of(context)!.subject_settings_enable_easy),
            subtitle: Text(AppLocalizations.of(context)!.subject_settings_enable_easy_description),
            trailing: Switch(
                value: widget.subject.easyBonus,
                onChanged: (value) {
                  setState(() {
                    widget.subject.easyBonus = value;
                  });
                }),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.subject_settings_flashcard_order),
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
            title: Text(AppLocalizations.of(context)!.subject_settings_initial_spread_time),
            subtitle: Text('${widget.subject.initialSpreadTime}'),
            onTap: () => _navigateToSpreadTimeEdit(context),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.subject_settings_spread_factor_range),
            subtitle: RangeSlider(
              values: widget.subject.spreadFactorRange,
              min: 1.0,
              max: 5.0,
              divisions: 40,
              labels:
                  RangeLabels('${widget.subject.spreadFactorRange.start}', '${widget.subject.spreadFactorRange.end}'),
              onChanged: (value) {
                setState(() {
                  if (value.start < widget.subject.initialSpreadFactor &&
                      value.end > widget.subject.initialSpreadFactor) {
                    widget.subject.spreadFactorRange = value;
                  }
                });
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.subject_settings_initial_spread_factor),
            subtitle: Slider(
              value: widget.subject.initialSpreadFactor,
              min: widget.subject.spreadFactorRange.start,
              max: widget.subject.spreadFactorRange.end,
              divisions:
                  ((widget.subject.spreadFactorRange.end - widget.subject.spreadFactorRange.start) / 0.1).round(),
              label: '${widget.subject.initialSpreadFactor}',
              onChanged: (value) {
                setState(() {
                  widget.subject.initialSpreadFactor = value;
                });
              },
            ),
          ),
          ListTile(
            subtitle:
                Text(AppLocalizations.of(context)!.subject_settings_spreading_results(_calcSampleSpreadResults())),
          ),
        ],
      ),
    );
  }

  String _calcSampleSpreadResults() {
    FlashCard sampleCard = FlashCard(
      spreadTime: widget.subject.initialSpreadTime,
      spreadFactor: widget.subject.initialSpreadFactor,
    );

    return List<String>.generate(5, (i) {
      sampleCard.update(widget.subject, FlashCardSwipe.right);
      return getOptimalDurationString(Duration(minutes: sampleCard.dueTime));
    }).toList().toString();
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
