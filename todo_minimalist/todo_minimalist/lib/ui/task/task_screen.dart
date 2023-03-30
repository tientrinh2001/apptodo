import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/states/task_state.dart';
import '../../provider/user_controller.dart';
import '../../model/task_model.dart';
import '../../provider/states/user_state.dart';
import '../../provider/task_controller.dart';
import '../widget/snack_bar.dart';
import 'widget/task_bottom_sheet.dart';

import '../../model/project_model.dart';
import '../../utils.dart';
import 'widget/task_staggered_gird.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<TaskState>(taskControllerProvider, ((_, state) {
      if (state is TaskStateError) {
        showSnackBar(context, state.error);
      } else if (state is TaskCreateSuccess || state is TaskUpdateSuccess) {
        Navigator.pop(context);
        showSnackBar(context, 'success'.tr());
      }
    }));
    ref.listen<UserState>(userControllerProvider, ((previous, state) async {
      if (state is UserStateOpenTaskSheet) {
        await createOrUpdateTask(
            context, TaskAction.create, null, state.project, ref);
      }
    }));
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final project = args['project'] as Project;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/chat',
                  arguments: {'project': project});
            },
            icon: chatIcon,
          )
        ],
      ),
      body: StreamBuilder(
        stream: ref.watch(taskRepositoryProvider).load(project.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            return Center(child: Text('someErrorOccurred'.tr()));
          }

          var taskList = snapshot.data as List<Task>;
          if (taskList.isNotEmpty) {
            taskList
                .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
          }
          return TaskStaggeredGrid(taskList: taskList, project: project);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(userControllerProvider.notifier).openTaskSheet(project);
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
