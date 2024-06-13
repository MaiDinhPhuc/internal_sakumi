import 'package:cloud_firestore/cloud_firestore.dart';

class CourseSuggestModel {
  final int id , idCourse;
  const CourseSuggestModel({
    required this.id,
    required this.idCourse,
  });
  CourseSuggestModel copyWith({
    int? id,
    int? idCourse,

  }) {
    return CourseSuggestModel(
      id: id ?? this.id,
      idCourse: idCourse ?? this.idCourse,
    );
  }
  factory CourseSuggestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CourseSuggestModel(
        id: data["id"] ?? 0,
        idCourse: data["id_course"] ?? 0,
       );
  }

  factory CourseSuggestModel.fromMap(
      Map<String, dynamic> data) {
    return CourseSuggestModel(
        id: data["id"] ?? 0,
        idCourse: data["id_course"] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_course': idCourse,
    };
  }

}