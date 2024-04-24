import 'package:cloud_firestore/cloud_firestore.dart';

class GroupTagModel {
  final String name, description, code;
  final int id;

  const GroupTagModel({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
  });
  GroupTagModel copyWith({
    int? id,
    String? name,
    String? description,
    String? code,
  }) {
    return GroupTagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
    );
  }
  factory GroupTagModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return GroupTagModel(
        id: data["id"] ?? 0,
        name: data["name"] ?? '',
        description: data['description'] ?? '',
        code: data['code'] ?? '',);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
    };
  }
}
