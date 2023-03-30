import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../provider/states/user_state.dart';
import '../../provider/user_controller.dart';
import '../../model/project_model.dart';
import '../../provider/project_controller.dart';
import 'project_bottom_sheet.dart';
import 'project_staggered_gird.dart';

import '../../../provider/auth_controller.dart';

class ProjectTab extends ConsumerWidget {
  const ProjectTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UserState>(userControllerProvider, ((previous, state) async {
      if (state is UserStateOpenProjectSheet) {
        await addUser(context, ref, state.project);
      }
    }));
    final uid = ref.watch(authRepositoryProvider).getUser!.uid;

    return StreamBuilder(
      stream: CombineLatestStream.list([
        ref.watch(projectRepositoryProvider).load(uid),
        ref.watch(projectRepositoryProvider).load1(uid),
      ]),
      builder: (context, snapshot) {
        List<Project> projectList = [];
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        if (snapshot.error != null) {
          return Center(child: Text('someErrorOccurred'.tr()));
        }

        var result = snapshot.data as List<List<Project>>;
        if (result.isNotEmpty) {
          for (var element in result) {
            projectList.addAll(element);
          }
          projectList
              .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
        }
        return ProjectStaggeredGrid(projectList: projectList);
      },
    );
  }
}
