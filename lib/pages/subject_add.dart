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
  late TextEditingController _controller;
  bool _isSwitched = false;

  static const changeImageButtonText = 'Change Image';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subject.name);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.33,
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
      child: TextField(
        controller: _controller,
        style: Theme
            .of(context)
            .textTheme
            .headline5
            ?.copyWith(fontWeight: FontWeight.bold),
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
        style: Theme
            .of(context)
            .textTheme
            .caption
            ?.copyWith(
            fontWeight: FontWeight.w900,
            color: Theme
                .of(context)
                .primaryColor),
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20.0),
      child: ListView(
        /* this is to scroll through the whole page when scrolling, instead of only the list view */
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          ListTile(
            leading: const Icon(Icons.switch_left),
            title: const Text('Simple sample switch'),
            trailing: Switch(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                }),
          ),
          const ListTile(
            leading: Icon(Icons.chevron_left),
            title: Text('Sick sample...'),
            trailing: Icon(Icons.chevron_right),
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
                widget.subject.name = _controller.value.text;
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