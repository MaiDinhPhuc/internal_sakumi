import 'package:cloud_firestore/cloud_firestore.dart';

class GroupTagModel {
  final String name, description, code;
  final List<dynamic> tags;
  final int id;

  const GroupTagModel({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.tags,
  });

  factory GroupTagModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return GroupTagModel(
        id: data["id"] ?? 0,
        name: data["name"] ?? '',
        description: data['description'] ?? '',
        code: data['code'] ?? '',
        tags: data['tags'] ?? []);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'tags': tags,
    };
  }
}
