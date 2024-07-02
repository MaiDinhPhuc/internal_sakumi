import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String image, title, text, description, html;
  final int id;
  const BannerModel({
    required this.id,
    required this.image,
    required this.title,
    required this.text,
    required this.description,
    required this.html,
  });
  BannerModel copyWith({
    int? id,
    String? image,
    String? title,
    String? text,
    String? description,
    String? html,
  }) {
    return BannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      text: text ?? this.text,
      description: description ?? this.description,
      html: html ?? this.html,
    );
  }
  factory BannerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BannerModel(
        id: data["id"] ?? 0,
        image: data["image"] ?? '',
        title: data["title"] ?? '',
        text: data['text'] ?? '',
        html: data['html'] ?? '',
        description: data['description'] ?? '');
  }

  factory BannerModel.fromMap(
      Map<String, dynamic> data) {
    return BannerModel(
        id: data["id"] ?? 0,
        image: data["image"] ?? '',
        title: data["title"] ?? '',
        text: data['text'] ?? '',
        html: data['html'] ?? '',
        description: data['description'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'text': text,
      'html': html,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BannerModel &&
        other.image == image &&
        other.title == title &&
        other.text == text &&
        other.description == description &&
        other.html == html;
  }

  @override
  int get hashCode {
    return image.hashCode ^
    title.hashCode ^
    text.hashCode ^
    description.hashCode ^
    html.hashCode;
  }

}