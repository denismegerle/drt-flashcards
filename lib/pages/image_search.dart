import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common.dart';
import '../constants.dart' as constants;

class ImageSearch extends StatefulWidget {
  const ImageSearch({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  late TextEditingController _controller;
  List<String> queryResults = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateReturnImageLink(BuildContext context, int linkIndex) {
    Navigator.pop(context, queryResults[linkIndex]);
  }

  void _applyNewQuery(String query) async {
    FocusScope.of(context).unfocus();
    queryResults = await loadImagesFromGoogleTask(context, query);
    setState(() {});
  }

  _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _applyNewQuery(_controller.value.text),
        ),
      ),
      onSubmitted: (query) => _applyNewQuery(query),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: _buildSearchBar(context),
      ),
      body: GridView.builder(
        itemCount: queryResults.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _navigateReturnImageLink(context, index),
            child: Image.network(
              queryResults[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) =>
                  (loadingProgress == null) ? child : const CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  constants.errorImageLink,
                  fit: BoxFit.cover,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
