import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({
    required this.index,
    required this.pages,
    Key? key,
  }) : super(key: key);
  final List<Widget> pages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (index != 1)
          ? SingleChildScrollView(
              child: pages.elementAt(index),
            )
          : pages.elementAt(index),
    );
  }
}
