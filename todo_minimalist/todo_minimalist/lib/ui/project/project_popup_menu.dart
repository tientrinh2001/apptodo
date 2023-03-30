import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/user_controller.dart';
import '../../model/project_model.dart';

class ProjectPopupMenu extends ConsumerWidget {
  const ProjectPopupMenu({
    required this.project,
    Key? key,
  }) : super(key: key);
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: null,
              child: Row(
                children: const [
                  Icon(
                    Icons.add,
                  ),
                  SizedBox(width: 10),
                  Text('Thêm'),
                ],
              ),
              onTap: () {
                Future.delayed(
                    const Duration(seconds: 0),
                    () => {
                          ref
                              .read(userControllerProvider.notifier)
                              .openProjectSheet(project)
                        });
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
