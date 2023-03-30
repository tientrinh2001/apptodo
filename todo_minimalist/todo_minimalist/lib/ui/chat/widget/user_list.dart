import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'user_item.dart';
import '../../../model/project_model.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final project = args['project'] as Project;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thành viên'),
      ),
      body: ListView.builder(
        itemCount: project.member.length,
        itemBuilder: ((context, index) {
          return UserItem(user: project.member[index]);
        }),
      ),
    );
  }
}
