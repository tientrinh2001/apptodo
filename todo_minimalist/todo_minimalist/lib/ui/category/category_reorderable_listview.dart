import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/category_model.dart';
import 'category_item.dart';

class CategoryReorderableListView extends ConsumerStatefulWidget {
  const CategoryReorderableListView({required this.catList, super.key});
  final List<Category> catList;

  @override
  ConsumerState<CategoryReorderableListView> createState() =>
      _CategoryReorderableListViewState();
}

class _CategoryReorderableListViewState
    extends ConsumerState<CategoryReorderableListView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      children: <Widget>[
        for (int index = 0; index < widget.catList.length; index += 1)
          CategoryItem(key: ValueKey('$index'), category: widget.catList[index])
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          // if (oldIndex < newIndex) {
          //   newIndex -= 1;
          // }
          // final Category item = widget.catList.removeAt(oldIndex);
          // widget.catList.insert(newIndex, item);
          // ref.read(catControllerProvider.notifier).changeIndex(
          //       category: widget.catList[newIndex],
          //       newIndex: widget.catList[newIndex].index,
          //     );
          // ref.read(catControllerProvider.notifier).changeIndex(
          //       category: widget.catList[oldIndex],
          //       newIndex: widget.catList[oldIndex].index,
          //     );
        });
      },
    );
  }
}
