import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTagModel {
  final int date, type, ownId;
  final List<dynamic> tags;
  final Map<int, String> notes;
  const ManageTagModel( {
    required this.date, required this.type, required this.ownId, required this.tags, required this.notes
  });
  ManageTagModel copyWith({
    int? date,
    int? type,
    int? ownId,
    Map<int, String>? notes,
    List<dynamic>? tags,

  }) {
    return ManageTagModel(
      date: date ?? this.date,
      type: type ?? this.type,
      ownId: ownId ?? this.ownId,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
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
        notes: (data['notes'] as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value as String)),
    );
  }

  factory ManageTagModel.fromMap(
      Map<String, dynamic> data) {
    return ManageTagModel(
      date: data["date"] ?? 0,
      type: data["type"] ?? 0,
      ownId: data["own_id"] ?? 0,
      tags: data["tags"] ?? [],
      notes: (data['notes'] as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value as String)),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'own_id': ownId,
      'tags': tags,
      'notes': notes.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}