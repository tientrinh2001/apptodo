import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/user_model.dart';
import '../provider/auth_controller.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref ref;
  UserRepository(this.ref, this._firebaseFirestore);

  static const String tableName = User.tableName;

  late CollectionReference _user;

  Future<void> create() async {
    final user = ref.watch(authRepositoryProvider).getUser!;
    final userNew = User(
      id: user.uid,
      groupId: [],
      email: user.email!,
      displayName: user.displayName,
      createdDate: Timestamp.fromDate(
        DateTime.now(),
      ),
    );
    _user = _firebaseFirestore.collection(tableName);
    try {
      await _user.add(userNew.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<User>> search(String email, String currentEmail) async {
    try {
      var snapshot = _firebaseFirestore
          .collection(tableName)
          .where(User.emailCol, isNotEqualTo: currentEmail)
          .where(User.emailCol, isGreaterThanOrEqualTo: email)
          .where(User.emailCol, isLessThan: '${email}z')
          .get();

      var result = snapshot.then(
          (value) => value.docs.map((e) => User.fromMap(e.data())).toList());
      return result;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> getUser(String uid) async {
    try {
      var snapshot = await _firebaseFirestore
          .collection(tableName)
          .where(User.idCol, isEqualTo: uid)
          .get();
      var result = snapshot.docs.map((e) => User.fromMap(e.data())).first;
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
