import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/category_model.dart';
import '../repository/category_repository.dart';
import 'auth_controller.dart';
import 'states/category_state.dart';

final catRepositoryProvider = Provider.autoDispose<CategoryRepository>((ref) {
  return CategoryRepository(ref, FirebaseFirestore.instance);
});

final catListProvider = StateProvider<List<Category>>((ref) {
  return [];
});
final catControllerProvider =
    StateNotifierProvider.autoDispose<CategoryController, CategoryState>((ref) {
  return CategoryController(ref);
});

class CategoryController extends StateNotifier<CategoryState> {
  CategoryController(this.ref) : super(const CategoryStateInitial());
  final Ref ref;

  Future<void> create({
    required String uid,
    required String categoryName,
    required Color color,
  }) async {
    state = const CategoryStateLoading();
    try {
      String uid = ref.watch(authRepositoryProvider).getUser!.uid;
      if (categoryName.isEmpty) {
        state = CategoryStateError('folderNotEmpty'.tr());
      } else {
        int totalOfCat = await ref.read(catRepositoryProvider).count(uid);
        var newCat = Category.newCategory(
          userId: uid,
          index: totalOfCat == 0 ? 0 : totalOfCat,
          categoryName: categoryName,
          color: color,
        );
        await ref.read(catRepositoryProvider).create(newCat);
        state = const CategoryCreateSuccess();
      }
    } catch (e) {
      state = CategoryStateError(e.toString());
    }
  }

  Future<void> update({
    required String categoryName,
    required Color color,
    required Category category,
  }) async {
    state = const CategoryStateLoading();

    try {
      if (categoryName.isEmpty) {
        state = CategoryStateError('folderNotEmpty'.tr());
      } else {
        var newCat =
            category.copyWith(categoryName: categoryName, color: color);
        await ref.read(catRepositoryProvider).updateWithTodoList(newCat);
        state = const CategoryCreateSuccess();
      }
    } catch (e) {
      state = CategoryStateError(e.toString());
    }
  }

  Future<void> delete({
    required Category category,
  }) async {
    state = const CategoryStateLoading();
    try {
      await ref.read(catRepositoryProvider).delete(category);
      state = const CategoryDeleteSuccess();
    } catch (e) {
      state = CategoryStateError(e.toString());
    }
  }
}
