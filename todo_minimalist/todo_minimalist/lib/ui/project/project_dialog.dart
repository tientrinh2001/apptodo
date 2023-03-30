import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enum.dart';
import '../../model/project_model.dart';
import '../../provider/project_controller.dart';
import '../../utils.dart';
import '../widget/block_picker.dart';
import '../widget/custom_text_form_field.dart';

Future<void> createOrUpdateProject(
  BuildContext context,
  ProjectAction action,
  Project? project,
  WidgetRef ref,
) async {
  final controller = TextEditingController();

  if (action == ProjectAction.update) {
    controller.text = project!.name;
  }
  showDialog(
      context: context,
      builder: (context, [bool mounted = true]) {
        return ContentDialog(controller: controller, mounted: mounted);
      });
}

class ContentDialog extends StatelessWidget {
  const ContentDialog({
    Key? key,
    required this.controller,
    required this.mounted,
  }) : super(key: key);

  final TextEditingController controller;
  final bool mounted;
  @override
  Widget build(BuildContext context) {
    Color defaultColor = const Color.fromARGB(255, 175, 165, 78);

    return Consumer(builder: ((context, ref, child) {
      return AlertDialog(
        title: const Text('Tạo dự án'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              keyboardType: TextInputType.name,
              hintText: 'Nhập tên dự án',
              icon: projectIcon,
            ),
            const SizedBox(height: 20),
            BlockPicker(
                pickerColor: defaultColor,
                onColorChanged: (newColor) {
                  defaultColor = newColor;
                })
          ],
        ),
        actions: [
          ElevatedButton(
              child: Text('close'.tr()),
              onPressed: () {
                if (!mounted) return;
                Navigator.pop(context);
              }),
          ElevatedButton(
              child: const Text('Thêm'),
              onPressed: () async {
                await ref
                    .read(projectControllerProvider.notifier)
                    .create(controller.text, defaultColor);
              })
        ],
      );
    }));
  }
}
