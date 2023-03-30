import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/category_model.dart';
import '../../provider/auth_controller.dart';
import '../../provider/category_controller.dart';
import '../../utils.dart';
import '../widget/block_picker.dart';
import '../widget/custom_text_form_field.dart';
import 'category_choice_chip.dart';

enum CatAction { create, update }

Future<void> createOrUpdateCategory(
  BuildContext context,
  CatAction action,
  Category? category,
) async {
  Color defaultColor = const Color.fromARGB(255, 175, 165, 78);
  final controller = TextEditingController();
  if (action == CatAction.update) {
    controller.text = category!.categoryName;
    defaultColor = category.color;
  }

  showDialog(
      context: context,
      builder: (context, [bool mounted = true]) {
        return Consumer(builder: ((context, ref, child) {
          final uid = ref.watch(authRepositoryProvider).getUser!.uid;
          return AlertDialog(
            title: action == CatAction.create
                ? Text('createCategory'.tr())
                : Text('updateCategory'.tr()),
            content: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: controller,
                  keyboardType: TextInputType.name,
                  hintText: 'inputCategory'.tr(),
                  icon: catIcon,
                ),
                const SizedBox(height: 20),
                BlockPicker(
                    pickerColor: defaultColor,
                    onColorChanged: (newColor) {
                      defaultColor = newColor;
                    })
              ],
            )),
            actions: [
              ElevatedButton(
                child: Text('close'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              action == CatAction.create
                  ? ElevatedButton(
                      child: Text('add'.tr()),
                      onPressed: () async {
                        await ref.read(catControllerProvider.notifier).create(
                              uid: uid,
                              categoryName: controller.text,
                              color: defaultColor,
                            );
                      })
                  : ElevatedButton(
                      child: Text('update'.tr()),
                      onPressed: () async {
                        await ref.read(catControllerProvider.notifier).update(
                              category: category!,
                              categoryName: controller.text,
                              color: defaultColor,
                            );
                      }),
            ],
          );
        }));
      });
}

Future<void> chooseCatgory(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('selectCategory'.tr()),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: const CatChoiceChipList(),
          ),
        );
      });
}

Future<void> deleteCategory(
  BuildContext context,
  Category category,
) async {
  showDialog(
      context: context,
      builder: (context, [bool mounted = true]) {
        return Consumer(builder: ((context, ref, child) {
          return AlertDialog(
            title: const Text('Xoá danh mục'),
            content: const Text('Bạn có chắc chắn muốn xoá danh mục'),
            actions: [
              ElevatedButton(
                  child: Text('close'.tr()),
                  onPressed: () {
                    if (!mounted) return;
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: const Text('Chắc chắn'),
                  onPressed: () async {
                    await ref
                        .read(catControllerProvider.notifier)
                        .delete(category: category);
                  })
            ],
          );
        }));
      });
}
