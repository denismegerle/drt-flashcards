import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as constants;

class FixedHeightImage extends StatelessWidget {
  const FixedHeightImage({Key? key, required this.height, required this.image}) : super(key: key);

  final double height;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        ),
      ),
    );
  }
}

class MinimalistAppBar extends AppBar {
  MinimalistAppBar({
    Key? key,
    required BuildContext context,
    required Widget title,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
  }) : super(
          key: key,
          title: title,
          titleTextStyle: Theme.of(context).textTheme.headline6,
          elevation: 0,
          bottom: bottom,
          actions: actions,
        );
}

Future<List<String>> loadImagesFromGoogleTask(BuildContext context, String query) async {
  if (kDebugMode || constants.serpapiKey.isEmpty) {
    /* for testing */
    debugPrint('Fake searching for $query, no api key or debug mode!');
    return constants.imageLinkDebugList;
  }

  /* correct method */
  final queryParameters = {
    'q': query,
    'tbm': 'isch',
    'ijn': '0',
    'api_key': constants.serpapiKey,
  };

  final uri = Uri.https('serpapi.com', '/search.json', queryParameters);

  final response = await http.get(uri);

  List<String> links = <String>[];

  if (response.statusCode == 200) {
    var document = json.decode(response.body);
    for (var element in document['images_results']) {
      links.add(element['original'].toString());
    }
    return links;
  } else {
    showSimpleSnackbarNotification(context, 'Failed image loading, retry later...');
    return [];
  }
}

void showSimpleSnackbarNotification(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Text(text),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String getOptimalDurationString(Duration duration) {
  var fnxList = [
    (duration) => duration.inSeconds > Duration.secondsPerMinute ? null : '${duration.inSeconds}s',
    (duration) => duration.inMinutes > Duration.minutesPerHour ? null : '${duration.inMinutes}m',
    (duration) => duration.inHours > Duration.hoursPerDay ? null : '${duration.inHours}h',
    (duration) => duration.inDays > DateTime.daysPerWeek ? null : '${duration.inDays}d',
    (duration) => duration.inDays / DateTime.daysPerWeek > constants.weeksPerMonth
        ? null
        : '${(duration.inDays / DateTime.daysPerWeek).round()}W',
    (duration) => duration.inDays / constants.daysPerMonth > DateTime.monthsPerYear
        ? '${(duration.inDays / constants.daysPerYear).round()}Y'
        : '${(duration.inDays / constants.daysPerMonth).round()}M',
  ];

  var strList = fnxList.map((fnx) => fnx(duration)).where((element) => element != null);
  return strList.first!; // it exists in any case!
}
