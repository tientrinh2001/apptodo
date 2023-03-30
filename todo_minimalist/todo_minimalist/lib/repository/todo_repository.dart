import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/auth_controller.dart';

import '../model/category_model.dart';
import '../model/todo_model.dart';

class TodoRepository {
  final Ref ref;
  final FirebaseFirestore _firebaseFirestore;
  TodoRepository(this.ref, this._firebaseFirestore);

  static const String tableName = Todo.tableName;

  late CollectionReference _todo;
  Stream<List<Todo>> load(
    String uid,
    Category? cat,
    String date,
  ) async* {
    try {
      var snapshot1 = _firebaseFirestore
          .collection(tableName)
          .where(Todo.userIdCol, isEqualTo: uid);

      var snapshot2 = snapshot1.where(Todo.dateTimeCol, isEqualTo: date);

      var snapshot3 = snapshot2
          .where(Todo.categoryCodeCol, isEqualTo: cat?.categoryCode)
          .snapshots();
      var result = snapshot3.map(
          (event) => event.docs.map((e) => Todo.fromJson(e.data())).toList());
      yield* result;
    } catch (e) {
      Stream.value(e);
    }
  }

  Stream<List<Todo>> loadForCalendar(
    String uid,
  ) async* {
    try {
      var snapshot = _firebaseFirestore
          .collection(tableName)
          .where(Todo.userIdCol, isEqualTo: uid);
      var result = snapshot.snapshots().map(
          (event) => event.docs.map((e) => Todo.fromJson(e.data())).toList());
      yield* result;
    } catch (e) {
      Stream.value(e);
    }
  }

  Future<List<Todo>> loadTodoByCat(Category category) async {
    try {
      var uid = ref.watch(authRepositoryProvider).getUser!.uid;
      var snapshot1 = _firebaseFirestore
          .collection(tableName)
          .where(Todo.userIdCol, isEqualTo: uid);
      var snapshot2 = snapshot1
          .where(Todo.categoryCodeCol, isEqualTo: category.categoryCode)
          .get();
      return snapshot2.then(
          (value) => value.docs.map((e) => Todo.fromJson(e.data())).toList());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> create(Todo todo) async {
    _todo = _firebaseFirestore.collection(tableName);
    try {
      await _todo.add(todo.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<DocumentReference> getDoc(Todo todo) async {
    try {
      _todo = _firebaseFirestore.collection(tableName);

      QuerySnapshot querySnapshot =
          await _todo.where(Todo.idCol, isEqualTo: todo.id).get();
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      return doc.reference;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(Todo todo) async {
    _todo = _firebaseFirestore.collection(tableName);
    try {
      QuerySnapshot querySnapshot =
          await _todo.where(Todo.idCol, isEqualTo: todo.id).get();
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference documentReference = doc.reference;
      await documentReference.update(todo.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> delete(Todo todo) async {
    _todo = _firebaseFirestore.collection(tableName);
    try {
      QuerySnapshot querySnapshot =
          await _todo.where(Todo.idCol, isEqualTo: todo.id).get();
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference documentReference = doc.reference;
      await documentReference.delete();
    } catch (e) {
      return Future.error(e);
    }
  }
}
