import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/category_model.dart';
import 'category_dialog.dart';

class CategoryPopupMenu extends ConsumerWidget {
  const CategoryPopupMenu({
    required this.category,
    Key? key,
  }) : super(key: key);
  final Category category;
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
                    Icons.delete,
                  ),
                  SizedBox(width: 10),
                  Text('Xoá'),
                ],
              ),
              onTap: () {
                Future.delayed(
                  const Duration(seconds: 0),
                  () => deleteCategory(context, category),
                );
              },
            ),
          ];
        },
        icon: const Icon(
          Icons.more_vert,
        ));
  }
}
