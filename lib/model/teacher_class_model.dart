import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherClassModel {
  final String classStatus, date;
  final int userId, classId, id;
  final bool responsibility;

  const TeacherClassModel(
      {required this.id,
      required this.userId,
      required this.classId,
      required this.classStatus,
      required this.date,
      required this.responsibility});

  factory TeacherClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TeacherClassModel(
        id: data["id"],
        classId: data["class_id"],
        userId: data['user_id'],
        date: data["date"],
        classStatus: data['class_status'],
        responsibility: data['responsibility'] ?? false);
  }
}
