import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_minimalist/provider/home_controller.dart';
import '../../../model/todo_model.dart';
import '../../../provider/category_controller.dart';
import '../../../provider/reminder_controller.dart';
import '../../../provider/todo_controller.dart';

class CreateOrUpdateButton extends ConsumerWidget {
  const CreateOrUpdateButton({
    required this.todo,
    required this.detailTextEditingController,
    required this.dateTextEditingController,
    super.key,
  });
  final Todo? todo;

  final TextEditingController detailTextEditingController;
  final TextEditingController dateTextEditingController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: ((context, ref, child) {
      final reminderState = ref.watch(reminderControllerProvider(todo));
      final reminderTypeState = ref.watch(reminderTypeControllerProvider(todo));
      final catList = ref.watch(catListProvider);
      var index = ref.watch(indexCatProvider);

      return SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(todo == null ? 'add'.tr() : 'update'.tr()),
            onPressed: () async {
              todo == null
                  ? await ref.read(todoControllerProvider.notifier).create(
                        detail: detailTextEditingController.text,
                        createdDate: dateTextEditingController.text,
                        category: catList[index!],
                        reminder: reminderState,
                        reminderType: reminderTypeState,
                      )
                  : await ref.read(todoControllerProvider.notifier).update(
                        todo: todo!,
                        detail: detailTextEditingController.text,
                        createdDate: dateTextEditingController.text,
                        category: catList[index!],
                        reminder: reminderState,
                        reminderType: reminderTypeState,
                      );
            },
          ));
    }));
  }
}
