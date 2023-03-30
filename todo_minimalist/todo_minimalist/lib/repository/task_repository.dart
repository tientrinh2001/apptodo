import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref ref;
  TaskRepository(this.ref, this._firebaseFirestore);

  static const String tableName = Task.tableName;

  late CollectionReference _task;

  Stream<List<Task>> load(String projectId) async* {
    var snapshot = _firebaseFirestore
        .collection(tableName)
        .where(Task.projectIdCol, isEqualTo: projectId)
        .snapshots();
    var result = snapshot
        .map((event) => event.docs.map((e) => Task.fromMap(e.data())).toList());
    yield* result;
  }

  Future<void> create(Task task) async {
    try {
      _task = _firebaseFirestore.collection(tableName);
      await _task.add(task.toMap());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> update(Task task) async {
    // _category = _firebaseFirestore.collection(tableName);

    // try {
    //   QuerySnapshot querySnapshot = await _category
    //       .where(Category.categoryCodeCol, isEqualTo: category.categoryCode)
    //       .get();
    //   QueryDocumentSnapshot doc = querySnapshot.docs[0];
    //   DocumentReference documentReference = doc.reference;
    //   await documentReference.update(category.toJson());
    // } catch (e) {
    //   return Future.error(e);
    // }
  }

  Future<void> delete(Task task) async {
    // try {
    //   List<Todo> todoList =
    //       await ref.watch(todoRepositoryProvider).loadTodoByCat(category);
    //   WriteBatch batch = _firebaseFirestore.batch();
    //   batch.delete(await getDoc(category));
    //   if (todoList.isNotEmpty) {
    //     for (var element in todoList) {
    //       var todoDoc = await ref.watch(todoRepositoryProvider).getDoc(element);
    //       batch.delete(todoDoc);
    //     }
    //   }
    //   batch.commit();
    // } catch (e) {
    //   return Future.error(e);
    // }
  }
}
