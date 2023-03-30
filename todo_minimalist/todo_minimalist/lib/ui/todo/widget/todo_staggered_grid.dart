import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/todo_model.dart';
import '../../../provider/home_controller.dart';
import 'todo_item.dart';

class TodoStaggeredGrid extends ConsumerWidget {
  const TodoStaggeredGrid({
    required this.todos,
    Key? key,
  }) : super(key: key);
  final List<Todo?> todos;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGrid.count(
        crossAxisCount: homeController.crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: todos.map((e) => TodoItem(todo: e!)).toList(),
      ),
    );
  }
}
