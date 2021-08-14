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