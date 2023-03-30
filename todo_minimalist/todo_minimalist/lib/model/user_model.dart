import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const tableName = 'User';
  static const emailCol = 'email';
  static const groupIdCol = 'groupId';
  static const idCol = 'id';
  final String id;
  final List<String> groupId;
  final String email;
  final bool? selected;
  final String? displayName;
  final Timestamp createdDate;
  User({
    required this.id,
    required this.email,
    this.selected,
    required this.groupId,
    required this.displayName,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'groupId': groupId,
        'displayName': displayName,
        'createdDate': createdDate,
      };

  User copyWith({
    String? id,
    List<String>? groupId,
    String? email,
    bool? selected,
    String? displayName,
    Timestamp? createdDate,
  }) {
    return User(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      email: email ?? this.email,
      selected: selected ?? this.selected,
      displayName: displayName ?? this.displayName,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      groupId: (map['groupId'] as List).map((e) => e.toString()).toList(),
      email: map['email'] as String,
      selected: false,
      displayName: map['displayName'] as String,
      createdDate: map['createdDate'] as Timestamp,
    );
  }
}
