import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskPopupMenu extends ConsumerWidget {
  const TaskPopupMenu({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (_) {
          return [];
        },
        icon: const Icon(Icons.more_vert));
  }
}
