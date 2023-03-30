import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: null);
    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
    );
  }

  static Future<void> showNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledDate,
  ) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'todo_list',
              'Todo Channel',
              channelDescription: "Todo minimalist",
              importance: Importance.max,
              priority: Priority.max,
            ),
            iOS: null),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      throw e.toString();
    }
  }
}
