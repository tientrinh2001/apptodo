import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/category_model.dart';
import '../../../model/todo_model.dart';
import '../../../provider/auth_controller.dart';
import '../../../provider/todo_controller.dart';
import 'todo_staggered_grid.dart';

class TodoTab extends ConsumerWidget {
  const TodoTab({
    Key? key,
    required this.isDone,
    required this.cat,
    required this.date,
  }) : super(key: key);
  final bool isDone;
  final Category? cat;
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authRepositoryProvider).getUser!.uid;
    return StreamBuilder(
      stream: ref.read(todoRepositoryProvider).load(uid, cat, date),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.error != null) {
          return Center(child: Text('someErrorOccurred'.tr()));
        }
        var todoList = snapshot.data as List<Todo>;
        if (todoList.isNotEmpty) {
          todoList
              .sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
        }
        return SingleChildScrollView(
          child: cat != null
              ? TodoStaggeredGrid(
                  todos: todoList,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
