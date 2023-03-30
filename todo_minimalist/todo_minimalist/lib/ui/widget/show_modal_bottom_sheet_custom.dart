import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:todo_minimalist/provider/user_controller.dart';

Future<void> showModalBottomSheetCustom(
  BuildContext context,
  WidgetRef ref,
  String title,
  Widget button,
  List<Widget> widgets,
) async {
  await showMaterialModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(title),
          centerTitle: true,
          actions: [button],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: widgets),
        ),
      );
    },
  ).whenComplete(
    () => ref.read(userControllerProvider.notifier).closeBottomSheet(),
  );
}
