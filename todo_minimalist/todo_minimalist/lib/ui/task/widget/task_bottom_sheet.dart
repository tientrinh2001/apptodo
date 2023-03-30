import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/project_model.dart';
import '../../../model/task_model.dart';
import '../../../provider/states/user_state.dart';
import '../../../provider/task_controller.dart';
import '../../../provider/user_controller.dart';
import '../../../utils.dart';
import '../../auth/widget/user_listview.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/show_modal_bottom_sheet_custom.dart';

enum TaskAction { create, update }

Future<void> createOrUpdateTask(
  BuildContext context,
  TaskAction action,
  Task? task,
  Project project,
  WidgetRef ref,
) async {
  ref.read(userControllerProvider.notifier).loadUser(project.member);
  final controller = TextEditingController();
  if (action == TaskAction.update) {
    controller.text = task!.name;
  }

  await showModalBottomSheetCustom(
    context,
    ref,
    'Tạo công việc',
    CreateTaskButton(project: project, controller: controller),
    [
      TaskTextField(controller: controller),
      const SizedBox(height: 10),
      Consumer(builder: ((context, ref, child) {
        final state = ref.watch(userControllerProvider);

        if (state is UserStateLoadSuccess) {
          return UserListView(userList: state.user);
        }
        return const SizedBox.shrink();
      }))
    ],
  );
}

class TaskTextField extends StatelessWidget {
  const TaskTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: CustomTextFormField(
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          keyboardType: TextInputType.name,
          hintText: 'Nhập công việc',
          icon: taskIcon,
        ),
      ),
    );
  }
}

class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({
    required this.project,
    required this.controller,
    Key? key,
  }) : super(key: key);
  final Project project;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final state = ref.watch(userControllerProvider);
      return IconButton(
          onPressed: (state is UserStateLoadSuccess &&
                  state.user.isNotEmpty &&
                  controller.text.isNotEmpty)
              ? () async {
                  await ref.read(taskControllerProvider.notifier).create(
                        name: controller.text,
                        project: project,
                        userList: state.user
                            .where((element) => element.selected!)
                            .toList(),
                        deadline: DateTime.now(),
                      );
                }
              : null,
          icon: const Icon(Icons.add));
    }));
  }
}
