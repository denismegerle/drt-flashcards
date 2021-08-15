import 'package:flutter/material.dart';

class FixedHeightImage extends StatelessWidget {
  const FixedHeightImage({Key? key, required this.height, required this.image})
      : super(key: key);

  final double height;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: image,
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottom: bottom,
          actions: actions,
        );
}
