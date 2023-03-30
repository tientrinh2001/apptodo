import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'category_choice_chip.dart';
import 'category_dialog.dart';

class CatListView extends ConsumerWidget {
  const CatListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CatChoiceChipList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: IconButton(
                  onPressed: () async {
                    await createOrUpdateCategory(
                        context, CatAction.create, null);
                  },
                  icon: Icon(
                    Icons.create_new_folder,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  )),
            ),
          ],
        )
      ],
    );
  }
}
