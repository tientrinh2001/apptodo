import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/category_model.dart';
import '../model/todo_model.dart';
import '../provider/todo_controller.dart';

class CategoryRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref ref;
  CategoryRepository(this.ref, this._firebaseFirestore);

  static const String tableName = Category.tableName;

  late CollectionReference _category;

  Stream<List<Category>> load(String uid) async* {
    var snapshot1 = _firebaseFirestore
        .collection(tableName)
        .where(Category.userIdCol, isEqualTo: uid)
        .snapshots();
    var result = snapshot1.map(
        (event) => event.docs.map((e) => Category.fromJson(e.data())).toList());
    yield* result;
  }

  Future<void> create(Category category) async {
    _category = _firebaseFirestore.collection(tableName);
    try {
      await _category.add(category.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> update(Category category) async {
    _category = _firebaseFirestore.collection(tableName);

    try {
      QuerySnapshot querySnapshot = await _category
          .where(Category.categoryCodeCol, isEqualTo: category.categoryCode)
          .get();
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference documentReference = doc.reference;
      await documentReference.update(category.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updateWithTodoList(Category category) async {
    try {
      List<Todo> todoList =
          await ref.watch(todoRepositoryProvider).loadTodoByCat(category);
      WriteBatch batch = _firebaseFirestore.batch();
      batch.set(await getDoc(category), category.toJson());
      if (todoList.isNotEmpty) {
        for (var element in todoList) {
          var todoDoc = await ref.watch(todoRepositoryProvider).getDoc(element);
          batch.set(todoDoc, element.copyWith(category: category).toJson());
        }
      }
      batch.commit();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> delete(Category category) async {
    try {
      List<Todo> todoList =
          await ref.watch(todoRepositoryProvider).loadTodoByCat(category);
      WriteBatch batch = _firebaseFirestore.batch();
      batch.delete(await getDoc(category));
      if (todoList.isNotEmpty) {
        for (var element in todoList) {
          var todoDoc = await ref.watch(todoRepositoryProvider).getDoc(element);
          batch.delete(todoDoc);
        }
      }
      batch.commit();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updateMultiRecord(List<Category> catList) async {
    try {
      WriteBatch batch = _firebaseFirestore.batch();
      for (var element in catList) {
        batch.set(await getDoc(element), element.toJson());
      }
      batch.commit();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<DocumentReference> getDoc(Category category) async {
    _category = _firebaseFirestore.collection(tableName);

    QuerySnapshot querySnapshot = await _category
        .where(Category.categoryCodeCol, isEqualTo: category.categoryCode)
        .get();
    QueryDocumentSnapshot doc = querySnapshot.docs[0];
    return doc.reference;
  }

  Future<int> count(String uid) async {
    _category = _firebaseFirestore.collection(tableName);
    try {
      var result = await _category
          .where(Category.userIdCol, isEqualTo: uid)
          .count()
          .get();
      return result.count;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Category?> getById(String categoryCode) async {
    _category = _firebaseFirestore.collection(tableName);
    QuerySnapshot querySnapshot = await _category
        .where(Category.categoryCodeCol, isEqualTo: categoryCode)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    var category = querySnapshot.docs.first.data() as Map<String, dynamic>;
    return Category.fromJson(category);
  }
}
