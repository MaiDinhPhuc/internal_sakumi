import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTagModel {
  final int date, type, ownId;
  final List<dynamic> tags;

  const ManageTagModel( {
    required this.date, required this.type, required this.ownId, required this.tags,
  });
  ManageTagModel copyWith({
    int? date,
    int? type,
    int? ownId,
    List<dynamic>? tags,
  }) {
    return ManageTagModel(
      date: date ?? this.date,
      type: type ?? this.type,
      ownId: ownId ?? this.ownId,
      tags: tags ?? this.tags,
    );
  }
  factory ManageTagModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ManageTagModel(
        date: data["date"] ?? 0,
        type: data["type"] ?? 0,
        ownId: data["own_id"] ?? 0,
        tags: data["tags"] ?? [],
    );
  }

  factory ManageTagModel.fromMap(
      Map<String, dynamic> data) {
    return ManageTagModel(
      date: data["date"] ?? 0,
      type: data["type"] ?? 0,
      ownId: data["own_id"] ?? 0,
      tags: data["tags"] ?? [],);
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'own_id': ownId,
      'tags': tags,
    };
  }
}