import 'package:flutter/material.dart';

PreferredSizeWidget? friendAppBar(BuildContext context) {
  final double screenSize = MediaQuery.of(context).size.width;

  return AppBar(
    title: const Text('message'),
    actions: [
      Padding(
        padding: EdgeInsets.only(
          right: screenSize * 0.03,
          left: screenSize * 0.02,
        ),
        child: const Icon(Icons.open_in_new),
      ),
    ],
  );
}
