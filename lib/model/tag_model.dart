import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  final String name, description, code;
  final int id, background;

  const TagModel({
    required this.id,
    required this.name,
    required this.background,
    required this.description,
    required this.code,
  });

  factory TagModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TagModel(
        id: data["id"] ?? 0,
        name: data["name"] ?? '',
        background: data['background'] ?? 0,
        code: data['code'] ?? '',
        description: data['description'] ?? '');
  }

  factory TagModel.fromMap(
      Map<String, dynamic> data) {
    return TagModel(
        id: data["id"] ?? 0,
        name: data["name"] ?? '',
        background: data['background'] ?? 0,
        code: data['code'] ?? '',
        description: data['description'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'background': background,
      'code': code,
      'description': description,
    };
  }
}
