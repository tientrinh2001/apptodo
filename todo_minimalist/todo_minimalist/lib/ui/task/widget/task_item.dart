import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'task_popup_menu.dart';
import '../../../core/theme.dart';
import '../../../model/task_model.dart';

class TaskItem extends ConsumerWidget {
  const TaskItem({required this.task, required this.color, Key? key})
      : super(key: key);
  final Task task;
  final Color color;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: color,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(task.name, style: titleStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < task.assignToId.length; i++) ...[
                          const Icon(Icons.account_circle, color: Colors.white)
                        ]
                      ],
                    ),
                    const TaskPopupMenu(),
                  ],
                ),
                Text(task.deadline)
              ],
            )),
      ),
    );
  }
}
