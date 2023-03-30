import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Category {
  static const tableName = 'Category';
  static const userIdCol = 'userId';
  static const categoryCodeCol = 'categoryCode';
  static const categoryNameCol = 'categoryCode';
  static const createdTimeCol = 'createdTime';
  Category({
    required this.userId,
    required this.index,
    required this.categoryName,
    required this.categoryCode,
    required this.color,
    required this.totalOfDone,
    required this.totalOfTask,
    required this.createdTime,
  });

  String userId;
  int index;
  String categoryName;
  String categoryCode;
  Color color;
  int totalOfDone;
  int totalOfTask;
  Timestamp createdTime;

  Category copyWith({
    String? userId,
    int? index,
    String? categoryName,
    String? categoryCode,
    Color? color,
    int? totalOfDone,
    int? totalOfTask,
    Timestamp? createdTime,
  }) {
    return Category(
      userId: userId ?? this.userId,
      index: index ?? this.index,
      categoryName: categoryName ?? this.categoryName,
      categoryCode: categoryCode ?? this.categoryCode,
      color: color ?? this.color,
      totalOfDone: totalOfDone ?? this.totalOfDone,
      totalOfTask: totalOfTask ?? this.totalOfTask,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  factory Category.newCategory({
    required String userId,
    required int index,
    required String categoryName,
    required Color color,
  }) {
    var uuid = const Uuid();
    return Category(
      userId: userId,
      index: index,
      categoryCode: uuid.v4(),
      categoryName: categoryName,
      color: color,
      totalOfDone: 0,
      totalOfTask: 0,
      createdTime: Timestamp.fromDate(DateTime.now()),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        userId: json["userId"],
        index: json["index"],
        categoryCode: json["categoryCode"],
        categoryName: json["categoryName"],
        color: Color(json["color"]),
        totalOfDone: json["totalOfDone"],
        totalOfTask: json["totalOfTask"],
        createdTime: json["createdTime"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "index": index,
        "categoryCode": categoryCode,
        "categoryName": categoryName,
        "color": color.value,
        "totalOfDone": totalOfDone,
        "totalOfTask": totalOfTask,
        "createdTime": createdTime,
      };
}
