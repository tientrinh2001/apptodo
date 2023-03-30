// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_minimalist/model/user_model.dart';
import 'package:uuid/uuid.dart';

class Project {
  static const tableName = 'Project';
  static const idCol = 'id';
  static const userIdCol = 'userId';
  static const memberCol = 'member';
  final String id;
  final String userId;
  final String chatId;
  final String name;
  final Color color;

  final List<User> member;
  final Timestamp createdDateTime;

  Project(
    this.id,
    this.userId,
    this.chatId,
    this.name,
    this.color,
    this.member,
    this.createdDateTime,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'chatId': chatId,
      'name': name,
      'color': color.value,
      'member': member.map((e) => e.toJson()).toList(),
      'createdDateTime': createdDateTime,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      map['id'] as String,
      map['userId'] as String,
      map['chatId'] as String,
      map['name'] as String,
      Color(map["color"]),
      (map['member']).isNotEmpty
          ? (map['member'] as List).map((e) => User.fromMap(e)).toList()
          : [],
      map['createdDateTime'] as Timestamp,
    );
  }
  factory Project.newProject({
    required String userId,
    required String name,
    required Color color,
  }) {
    var uuid = const Uuid();
    return Project(
      uuid.v4(),
      userId,
      uuid.v1(),
      name,
      color,
      [],
      Timestamp.fromDate(DateTime.now()),
    );
  }

  Project addMember(List<User> newMemberList) {
    return Project(
      id,
      userId,
      chatId,
      name,
      color,
      newMemberList,
      createdDateTime,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, uid: $userId, name: $name, member: $member, createdDateTime: $createdDateTime)';
  }

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        listEquals(other.member, member) &&
        other.createdDateTime == createdDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        member.hashCode ^
        createdDateTime.hashCode;
  }
}
