// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  static const tableName = 'Notification';
  static const userIdCol = 'userId';
  static const tokenCol = 'token';

  final String userId;
  final String token;
  final Timestamp createdDateTime;

  Notification(this.userId, this.token, this.createdDateTime);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'token': token,
      'createdDateTime': createdDateTime,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> map) {
    return Notification(
      map['userId'] as String,
      map['token'] as String,
      map['createdDateTime'],
    );
  }

  Notification copyWith({
    String? userId,
    String? token,
    Timestamp? createdDateTime,
  }) {
    return Notification(
      userId ?? this.userId,
      token ?? this.token,
      createdDateTime ?? this.createdDateTime,
    );
  }
}
