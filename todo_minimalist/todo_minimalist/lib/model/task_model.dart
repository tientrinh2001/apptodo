import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_minimalist/model/user_model.dart';
import 'package:uuid/uuid.dart';

class Task {
  static const String tableName = 'Task';
  static const String idCol = 'id';
  static const String projectIdCol = 'projectId';
  static const String userIdCol = 'userId';
  static const String assignToIdCol = 'assignToId';

  final String id;
  final String projectId;
  final String userId;
  final List<User> assignToId;
  final String name;
  final String deadline;
  final Timestamp createdDateTime;
  final Timestamp updatedDateTime;

  Task(this.id, this.projectId, this.userId, this.assignToId, this.name,
      this.deadline, this.createdDateTime, this.updatedDateTime);

  factory Task.newTask({
    required String projectId,
    required String userId,
    required List<User> assignToId,
    required String name,
    required String deadline,
  }) {
    return Task(
      const Uuid().v4(),
      projectId,
      userId,
      assignToId,
      name,
      deadline,
      Timestamp.fromDate(DateTime.now()),
      Timestamp.fromDate(DateTime.now()),
    );
  }

  Task copyWith({
    String? id,
    String? projectId,
    String? userId,
    List<User>? assignToId,
    String? name,
    String? deadline,
    Timestamp? createdDateTime,
    Timestamp? updatedDateTime,
  }) {
    return Task(
      id ?? this.id,
      projectId ?? this.projectId,
      userId ?? this.userId,
      assignToId ?? this.assignToId,
      name ?? this.name,
      deadline ?? this.deadline,
      createdDateTime ?? this.createdDateTime,
      updatedDateTime ?? this.updatedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'userId': userId,
      'assignToId': assignToId.map((e) => e.toJson()).toList(),
      'name': name,
      'deadline': deadline,
      'createdDateTime': createdDateTime,
      'updatedDateTime': updatedDateTime,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['id'] as String,
      map['projectId'] as String,
      map['userId'] as String,
      (map['assignToId']).isNotEmpty
          ? (map['assignToId'] as List).map((e) => User.fromMap(e)).toList()
          : [],
      map['name'] as String,
      map['deadline'] as String,
      map['createdDateTime'] as Timestamp,
      map['updatedDateTime'] as Timestamp,
    );
  }
}
