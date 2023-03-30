import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/todo_model.dart';
import '../../../provider/home_controller.dart';
import '../../../utils.dart';
import 'todo_popup_menu.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);
    return InkWell(
      onTap: (() {
        Navigator.pushNamed(context, '/todo', arguments: {'todo': todo});
      }),
      child: Card(
        color: todo.color,
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
                    Expanded(
                        child: Text(
                      todo.detail,
                      style: TextStyle(
                          decoration:
                              todo.isDone ? TextDecoration.lineThrough : null),
                    )),
                    TodoPopupMenu(todo: todo),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      homeController.code == 'listView' ? 5 : 0, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: homeController.code == 'listView'
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      todo.reminderDateTime != null
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                    timeFormat
                                        .format(todo.reminderDateTime!)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ))
                              ],
                            )
                          : const SizedBox.shrink(),
                      todo.reminderDateTime != null
                          ? const SizedBox(width: 10)
                          : const SizedBox.shrink(),
                      Text(todo.date,
                          style: const TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
