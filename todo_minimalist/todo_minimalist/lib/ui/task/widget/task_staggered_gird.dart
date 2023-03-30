import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'task_item.dart';

import '../../../model/project_model.dart';
import '../../../model/task_model.dart';
import '../../../provider/home_controller.dart';

class TaskStaggeredGrid extends ConsumerWidget {
  const TaskStaggeredGrid({
    required this.taskList,
    required this.project,
    Key? key,
  }) : super(key: key);
  final List<Task?> taskList;
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGrid.count(
        crossAxisCount: homeController.crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: taskList
            .map((e) => TaskItem(task: e!, color: project.color))
            .toList(),
      ),
    );
  }
}
