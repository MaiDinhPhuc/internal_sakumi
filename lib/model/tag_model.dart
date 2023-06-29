import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  final String title, background, textColor;
  final int id;

  const TagModel({
    required this.id,
    required this.title,
    required this.background,
    required this.textColor,
  });

  factory TagModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TagModel(
        id: data["id"],
        title: data["title"],
        background: data['color'],
        textColor: data['text_color']);
  }
}
