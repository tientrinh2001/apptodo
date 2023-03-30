import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/project_model.dart';
import '../../provider/project_controller.dart';
import '../../provider/states/user_state.dart';
import '../../provider/user_controller.dart';
import '../auth/widget/user_listview.dart';
import '../widget/custom_text_form_field.dart';
import '../widget/show_modal_bottom_sheet_custom.dart';

Future<void> addUser(
  BuildContext context,
  WidgetRef ref,
  Project project,
) async {
  await showModalBottomSheetCustom(
    context,
    ref,
    'Thêm người dùng',
    AddUserButton(project: project),
    [
      EmailTextField(project: project),
      const SizedBox(height: 10),
      Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(userControllerProvider);
          if (state is UserStateLoadSuccess) {
            var userList = state.user;
            return UserListView(userList: userList);
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}

class EmailTextField extends ConsumerWidget {
  const EmailTextField({
    required this.project,
    Key? key,
  }) : super(key: key);
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: CustomTextFormField(
        controller: TextEditingController(),
        keyboardType: TextInputType.name,
        hintText: 'Nhập email',
        icon: const Icon(Icons.email),
        onSubmit: (value) async {
          await ref
              .read(userControllerProvider.notifier)
              .search(value, project);
        },
      ),
    );
  }
}

class AddUserButton extends StatelessWidget {
  const AddUserButton({
    required this.project,
    Key? key,
  }) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final state = ref.watch(userControllerProvider);
        return IconButton(
          onPressed: (state is UserStateLoadSuccess && state.user.isNotEmpty)
              ? () async {
                  await ref.read(projectControllerProvider.notifier).addMember(
                      project,
                      state.user
                          .where((element) => element.selected!)
                          .toList());
                }
              : null,
          icon: const Icon(Icons.save),
        );
      }),
    );
  }
}
