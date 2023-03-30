import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_minimalist/utils.dart';
import '../model/project_model.dart';
import '../model/user_model.dart';
import 'auth_controller.dart';
import 'states/task_state.dart';

import '../model/task_model.dart';
import '../repository/task_repository.dart';

final taskRepositoryProvider = Provider.autoDispose<TaskRepository>((ref) {
  return TaskRepository(ref, FirebaseFirestore.instance);
});

final taskControllerProvider =
    StateNotifierProvider.autoDispose<TaskController, TaskState>((ref) {
  return TaskController(ref);
});

class TaskController extends StateNotifier<TaskState> {
  TaskController(this.ref) : super(const TaskStateInitial());
  final Ref ref;

  Future<void> create({
    required String name,
    required Project project,
    required List<User> userList,
    required DateTime deadline,
  }) async {
    state = const TaskStateLoading();
    try {
      String uid = ref.watch(authRepositoryProvider).getUser!.uid;
      if (name.isEmpty) {
        state = const TaskStateError('Công việc không được để trống');
      } else {
        var task = Task.newTask(
          projectId: project.id,
          userId: uid,
          assignToId: userList,
          name: name,
          deadline: dateFormat.format(deadline),
        );
        await ref.read(taskRepositoryProvider).create(task);
        state = const TaskCreateSuccess();
      }
    } catch (e) {
      state = TaskStateError(e.toString());
    }
  }
}
