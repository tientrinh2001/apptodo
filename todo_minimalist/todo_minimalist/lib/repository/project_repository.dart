import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/project_model.dart';

class ProjectRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref ref;
  ProjectRepository(this.ref, this._firebaseFirestore);

  static const String tableName = Project.tableName;

  late CollectionReference _project;

  Stream<List<Project>> load(String uid) async* {
    var snapshot1 = _firebaseFirestore
        .collection(tableName)
        .where(Project.userIdCol, isEqualTo: uid)
        .snapshots();
    var result = snapshot1.map(
        (event) => event.docs.map((e) => Project.fromMap(e.data())).toList());
    yield* result;
  }

  Stream<List<Project>> load1(String uid) async* {
    var snapshot = _firebaseFirestore
        .collection(tableName)
        .where(Project.memberCol, arrayContains: uid)
        .snapshots();
    var result = snapshot.map(
        (event) => event.docs.map((e) => Project.fromMap(e.data())).toList());
    yield* result;
  }

  Future<void> create(Project project) async {
    _project = _firebaseFirestore.collection(tableName);
    try {
      await _project.add(project.toMap());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> update(Project project) async {
    _project = _firebaseFirestore.collection(tableName);
    try {
      QuerySnapshot querySnapshot =
          await _project.where(Project.idCol, isEqualTo: project.id).get();
      QueryDocumentSnapshot doc = querySnapshot.docs[0];
      DocumentReference documentReference = doc.reference;
      await documentReference.update(project.toMap());
    } catch (e) {
      return Future.error(e);
    }
  }
}
