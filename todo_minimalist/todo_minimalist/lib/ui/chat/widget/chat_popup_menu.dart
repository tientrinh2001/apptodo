import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/project_model.dart';

class ChatPopupMenu extends ConsumerWidget {
  const ChatPopupMenu({required this.project, super.key});
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: null,
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  const Text('Tất cả thành viên'),
                ],
              ),
              onTap: () {
                Future.delayed(
                    const Duration(seconds: 0),
                    () => Navigator.pushNamed(context, '/userList',
                        arguments: {'project': project}));
              },
            ),
          ];
        },
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ));
  }
}
