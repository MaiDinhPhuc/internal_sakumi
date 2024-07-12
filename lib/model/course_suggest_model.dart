import 'package:cloud_firestore/cloud_firestore.dart';

class CourseSuggestModel {
  final int id , idCourse;
  final bool favorite;
  const CourseSuggestModel({
    required this.id,
    required this.idCourse,
    required this.favorite
  });
  CourseSuggestModel copyWith({
    int? id,
    int? idCourse,
    bool? favorite
  }) {
    return CourseSuggestModel(
        id: id ?? this.id,
        idCourse: idCourse ?? this.idCourse,
        favorite: favorite ?? this.favorite
    );
  }
  factory CourseSuggestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CourseSuggestModel(
        id: data["id"] ?? 0,
        idCourse: data["id_course"] ?? 0,
        favorite: data["favorite"] ?? false
    );
  }

  factory CourseSuggestModel.fromMap(
      Map<String, dynamic> data) {
    return CourseSuggestModel(
        id: data["id"] ?? 0,
        idCourse: data["id_course"] ?? 0,
        favorite: data['favorite'] ?? false
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_course': idCourse,
      'favorite': favorite
    };
  }

}