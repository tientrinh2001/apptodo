import 'dart:math';

import 'package:flutter/material.dart';

typedef PickerItem = Widget Function(Color color);

typedef PickerLayoutBuilder = Widget Function(
    BuildContext context, List<Color> colors, PickerItem child);

/// Customize the item shape.
typedef PickerItemBuilder = Widget Function(
    Color color, bool isCurrentColor, void Function() changeColor);

class BlockPicker extends StatefulWidget {
  const BlockPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.availableColors = _defaultColors,
    this.useInShowDialog = true,
    this.layoutBuilder = pickerLayoutBuilder,
    this.itemBuilder = _defaultItemBuilder,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final bool useInShowDialog;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  late Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.all(5),
      child: widget.layoutBuilder(
        context,
        widget.availableColors,
        (Color color) => widget.itemBuilder(
          color,
          (_currentColor.value == color.value) &&
              (widget.useInShowDialog
                  ? true
                  : widget.pickerColor.value == color.value),
          () => changeColor(color),
        ),
      ),
    );
  }
}

Widget _defaultItemBuilder(
    Color color, bool isCurrentColor, void Function() changeColor) {
  return Container(
    margin: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
            color: color.withOpacity(0.8),
            offset: const Offset(1, 2),
            blurRadius: 5)
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: changeColor,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 210),
          opacity: isCurrentColor ? 1 : 0,
          child: Icon(Icons.done,
              color: useWhiteForeground(color) ? Colors.white : Colors.black),
        ),
      ),
    ),
  );
}

const int _portraitCrossAxisCount = 5;
const int _landscapeCrossAxisCount = 4;
Widget pickerLayoutBuilder(
    BuildContext context, List<Color> colors, PickerItem child) {
  Orientation orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 140 : 100,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait
          ? _portraitCrossAxisCount
          : _landscapeCrossAxisCount,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 1.2,
      children: [for (Color color in colors) child(color)],
    ),
  );
}

bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
  // Old:
  // return 1.05 / (color.computeLuminance() + 0.05) > 4.5;

  // New:
  int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
          pow(backgroundColor.green, 2) * 0.587 +
          pow(backgroundColor.blue, 2) * 0.114)
      .round();
  return v < 130 + bias ? true : false;
}

const List<Color> _defaultColors = [
  Color.fromARGB(255, 175, 165, 78),
  Color.fromARGB(255, 77, 77, 13),
  Colors.orange,
  Colors.orangeAccent,
  Colors.blue,
  Colors.blueAccent,
  Colors.lightBlue,
  Colors.blueGrey,
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.purple,
  Colors.purpleAccent,
  Colors.yellow,
  Colors.brown,
];
