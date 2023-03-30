import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/category_model.dart';
import 'category_reorderable_listview.dart';

class CategoryTab extends ConsumerWidget {
  const CategoryTab({required this.catList, super.key});
  final List<Category> catList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CategoryReorderableListView(catList: catList);
  }
}
