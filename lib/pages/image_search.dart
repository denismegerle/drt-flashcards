import 'package:flutter/material.dart';
import 'dart:convert';

import '../common.dart';
import '../logic.dart';
import 'deck_view.dart';
import 'subject_mod.dart';

// TODO standardize and cleanup
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

  static const String errorImageLink =
      'https://cdn.pixabay.com/photo/2013/07/12/12/40/abort-146096_960_720.png';

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

  void _applyNewQuery(String query) async {
    FocusScope.of(context).unfocus();
    queryResults = await loadImagesFromGoogleTask(query);
    setState(() {});
  }

  void _navigateReturnImageLink(BuildContext context, int linkIndex) {
    Navigator.pop(context, queryResults[linkIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinimalistAppBar(
        context: context,
        title: TextField(
          controller: _controller,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: " Search...",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _applyNewQuery(_controller.value.text),
            ),
          ),
          onSubmitted: (query) => _applyNewQuery(query),
          style: Theme.of(context).textTheme.headline6,
        ),
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
                    (loadingProgress == null)
                        ? child
                        : const CircularProgressIndicator(),
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    errorImageLink,
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          }),
    );
  }
}
