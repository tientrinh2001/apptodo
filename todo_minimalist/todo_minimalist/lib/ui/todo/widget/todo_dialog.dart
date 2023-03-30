import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/todo_model.dart';
import '../../../provider/todo_controller.dart';
import 'reminder_gird_view.dart';

Future<void> choosePeriodTime(
  BuildContext context,
  Todo? todo,
) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('selectTime'.tr()),
            ],
          ),
          content: ReminderGirdView(todo: todo),
        );
      });
}

Future<void> deleteTodo(
  BuildContext context,
  Todo todo,
) async {
  showDialog(
      context: context,
      builder: (context, [bool mounted = true]) {
        return Consumer(
            builder: ((context, ref, child) => AlertDialog(
                  title: const Text('Xoá công việc'),
                  content: const Text('Bạn có chắc chắn muốn xoá công việc'),
                  actions: [
                    ElevatedButton(
                        child: Text('close'.tr()),
                        onPressed: () {
                          if (!mounted) return;
                          Navigator.pop(context);
                        }),
                    ElevatedButton(
                        child: const Text('Chắc chắn'),
                        onPressed: () async {
                          await ref
                              .read(todoControllerProvider.notifier)
                              .delete(todo: todo);
                        })
                  ],
                )));
      });
}
