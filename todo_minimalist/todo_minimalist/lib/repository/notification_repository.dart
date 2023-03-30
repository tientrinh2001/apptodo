import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/notification_model.dart';

final notificationRepositoryProvider =
    Provider.autoDispose<NotificationRepository>(
        (ref) => NotificationRepository(FirebaseFirestore.instance));

class NotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository(this._firebaseFirestore);

  static const String tableName = Notification.tableName;

  late CollectionReference _notification;

  Future<void> create(Notification notication) async {
    _notification = _firebaseFirestore.collection(tableName);
    try {
      await _notification.add(notication.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Notification> getTokenByUserId(String userId) async {
    try {
      var snapshot = await _firebaseFirestore
          .collection(tableName)
          .where(Notification.userIdCol, isEqualTo: userId)
          .get();
      var result =
          snapshot.docs.map((e) => Notification.fromJson(e.data())).first;
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
