import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/category_model.dart';
import '../../../provider/home_controller.dart';
import 'category_dialog.dart';
import 'category_popup_menu.dart';

class CategoryItem extends ConsumerWidget {
  const CategoryItem({required this.category, Key? key}) : super(key: key);
  final Category category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeWidget = ref.watch(homeControllerProvider);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
            onTap: () async {
              await createOrUpdateCategory(
                context,
                CatAction.update,
                category,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: category.color,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: homeWidget.code == 'listView'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(category.categoryName),
                            Row(
                              children: [
                                Text(
                                  '${category.totalOfDone} / ${category.totalOfTask}',
                                ),
                                const SizedBox(width: 20),
                                CategoryPopupMenu(category: category)
                              ],
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(category.categoryName),
                                CategoryPopupMenu(category: category)
                              ],
                            ),
                            Text(
                              '${category.totalOfDone} / ${category.totalOfTask}',
                            ),
                          ],
                        )),
            )));
  }
}
