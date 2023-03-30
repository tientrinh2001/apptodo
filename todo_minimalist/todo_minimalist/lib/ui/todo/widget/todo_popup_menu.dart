import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/todo_model.dart';
import '../../../provider/todo_controller.dart';
import 'todo_dialog.dart';

class TodoPopupMenu extends ConsumerWidget {
  const TodoPopupMenu({
    required this.todo,
    Key? key,
  }) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: null,
              child: Row(
                children: [
                  Icon(
                    !todo.isDone ? Icons.check : Icons.work,
                  ),
                  const SizedBox(width: 10),
                  Text(!todo.isDone ? 'Đã hoàn tất' : 'Chưa hoàn tất'),
                ],
              ),
              onTap: () {
                ref.read(todoControllerProvider.notifier).makeDone(
                      isDone: !todo.isDone,
                      todo: todo,
                    );
              },
            ),
            PopupMenuItem(
              value: null,
              child: Row(
                children: const [
                  Icon(
                    Icons.delete,
                  ),
                  SizedBox(width: 10),
                  Text('Xoá'),
                ],
              ),
              onTap: () {
                Future.delayed(
                  const Duration(seconds: 0),
                  () => deleteTodo(context, todo),
                );
              },
            ),
          ];
        },
        icon: const Icon(Icons.more_vert));
  }
}
