import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/category_controller.dart';
import '../../provider/states/category_state.dart';
import '../../provider/states/todo_state.dart';
import '../../provider/todo_controller.dart';
import '../widget/snack_bar.dart';
import 'widget/todo_form.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    ref.listen<TodoState>(todoControllerProvider, ((_, state) {
      if (state is TodoStateSuccess) {
        Navigator.pop(context);
        showSnackBar(context, 'success'.tr());
      } else if (state is TodoStateError) {
        showSnackBar(context, state.error);
      }
    }));
    ref.listen<CategoryState>(catControllerProvider, ((_, state) {
      if (state is CategoryStateError) {
        showSnackBar(context, state.error);
      }
    }));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(args['todo'] == null ? 'add'.tr() : 'update'.tr()),
        ),
        body: TodoForm(todo: args['todo']),
      ),
    );
  }
}
