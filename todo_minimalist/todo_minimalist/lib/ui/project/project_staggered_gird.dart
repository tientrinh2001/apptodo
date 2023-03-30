import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/project_model.dart';
import '../../../provider/home_controller.dart';
import 'project_item.dart';

class ProjectStaggeredGrid extends ConsumerWidget {
  const ProjectStaggeredGrid({
    required this.projectList,
    Key? key,
  }) : super(key: key);
  final List<Project?> projectList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGrid.count(
        crossAxisCount: homeController.crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: projectList.map((e) => ProjectItem(project: e!)).toList(),
      ),
    );
  }
}
