import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'category_model.dart';

class Todo {
  static const tableName = 'Todo';
  static const idCol = 'id';
  static const isDoneCol = 'isDone';
  static const detailCol = 'detail';
  static const userIdCol = 'userId';
  static const categoryCodeCol = 'categoryCode';
  static const dateTimeCol = 'date';
  Todo({
    required this.id,
    required this.notiId,
    required this.userId,
    required this.detail,
    required this.categoryName,
    required this.categoryCode,
    required this.isDone,
    required this.color,
    required this.reminderDateTime,
    required this.date,
    required this.createdDateTime,
    required this.updatedDateTime,
  });

  final String id;
  final int? notiId;
  final String userId;
  final String detail;
  final String categoryName;
  final String categoryCode;
  final bool isDone;
  final Color color;
  final DateTime? reminderDateTime;
  final String date;
  final Timestamp createdDateTime;
  final Timestamp updatedDateTime;

  Todo copyWith({
    String? id,
    int? notiId,
    String? userId,
    String? detail,
    Category? category,
    bool? isDone,
    DateTime? reminderDateTime,
    String? date,
    Timestamp? createdDateTime,
    Timestamp? updatedDateTime,
  }) {
    return Todo(
      id: id ?? this.id,
      notiId: notiId ?? this.notiId,
      userId: userId ?? this.userId,
      detail: detail ?? this.detail,
      categoryName: category!.categoryName,
      categoryCode: category.categoryCode,
      isDone: isDone ?? this.isDone,
      color: category.color,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
      date: date ?? this.date,
      createdDateTime: Timestamp.fromDate(DateTime.now()),
      updatedDateTime: Timestamp.fromDate(DateTime.now()),
    );
  }

  Todo copyWithForReminder({
    String? id,
    required int? notiId,
    String? userId,
    String? detail,
    Category? category,
    bool? isDone,
    required DateTime? reminderDateTime,
    String? date,
    Timestamp? createdDateTime,
    Timestamp? updatedDateTime,
  }) {
    return Todo(
      id: id ?? this.id,
      notiId: notiId,
      userId: userId ?? this.userId,
      detail: detail ?? this.detail,
      categoryName: category!.categoryName,
      categoryCode: category.categoryCode,
      isDone: isDone ?? this.isDone,
      color: category.color,
      reminderDateTime: reminderDateTime,
      date: date ?? this.date,
      createdDateTime: Timestamp.fromDate(DateTime.now()),
      updatedDateTime: Timestamp.fromDate(DateTime.now()),
    );
  }

  factory Todo.newTodo({
    required String userId,
    int? notiId,
    required String detail,
    required Category category,
    required Color color,
    DateTime? reminderDateTime,
    required String date,
    Timestamp? createdDateTime,
    Timestamp? updatedDateTime,
  }) {
    var uuid = const Uuid();
    return Todo(
      id: uuid.v4(),
      notiId: notiId,
      userId: userId,
      detail: detail,
      categoryCode: category.categoryCode,
      categoryName: category.categoryName,
      isDone: false,
      color: color,
      reminderDateTime: reminderDateTime,
      date: date,
      createdDateTime: Timestamp.fromDate(DateTime.now()),
      updatedDateTime: Timestamp.fromDate(DateTime.now()),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        notiId: json["notiId"],
        userId: json["userId"],
        detail: json["detail"],
        categoryCode: json["categoryCode"],
        categoryName: json["categoryName"],
        isDone: json["isDone"],
        color: Color(json["color"]),
        reminderDateTime: json['reminderDateTime'] != null
            ? (json['reminderDateTime'] as Timestamp).toDate()
            : null,
        date: json["date"],
        createdDateTime: json["createdDateTime"],
        updatedDateTime: json["updatedDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notiId": notiId,
        "userId": userId,
        "detail": detail,
        "categoryCode": categoryCode,
        "categoryName": categoryName,
        "isDone": isDone,
        "color": color.value,
        "reminderDateTime": reminderDateTime,
        "date": date,
        "createdDateTime": createdDateTime,
        "updatedDateTime": updatedDateTime,
      };
}
