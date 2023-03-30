import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/notification_model.dart';
import '../model/project_model.dart';
import '../model/user_model.dart';
import '../repository/notification_repository.dart';

const baseUrl = 'https://fcm.googleapis.com/fcm/send';
const serveyKey =
    'AAAATA6zxHA:APA91bEmkOREBO9yiZV1yZH_NrnEPNZWRlDEBMtYYNHqL0Qah0z8INHaJSXKyHo5Rose48u1zstyHkOzUoELWy__5zcifKbuaYjN8b0B8oXsleFcfWKEe0yiVtZGlLVkR0y6kSwWiYAW';

final remoteNotificationServiceProvider =
    Provider.autoDispose<RemoteNotificationService>((ref) {
  Dio dio = Dio();
  dio.options.baseUrl = baseUrl;
  dio.options.connectTimeout = 5000;
  dio.options.receiveTimeout = 3000;
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = "key=$serveyKey";
  return RemoteNotificationService(FirebaseMessaging.instance, ref, dio);
});

class RemoteNotificationService {
  RemoteNotificationService(this._firebaseMessaging, this._ref, this._dio);
  final FirebaseMessaging _firebaseMessaging;

  final Dio _dio;
  final Ref _ref;

  Future<void> registration(String userId) async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var token = await getToken();
    var notification =
        Notification(userId, token!, Timestamp.fromDate(DateTime.now()));
    await _ref.read(notificationRepositoryProvider).create(notification);
  }

  Future<String?> getToken() async {
    var result = await _firebaseMessaging.getToken();
    return result;
  }

  Future<void> push(Project project, String text, String uid) async {
    try {
      if (project.member.isNotEmpty) {
        for (User user in project.member) {
          if (uid != user.id) {
            await send(project, text, user.id);
          }
        }
        if (uid != project.userId) {
          await send(project, text, project.userId);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> send(Project project, String text, String uid) async {
    var token =
        await _ref.read(notificationRepositoryProvider).getTokenByUserId(uid);
    var data = {
      "to": token.token,
      "notification": {
        "title": project.name,
        "body": text,
      },
      "data": {}
    };
    await _dio.post(baseUrl, data: data);
  }
}
