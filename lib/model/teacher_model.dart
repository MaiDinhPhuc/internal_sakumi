import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String name, note, phone, teacherCode, url, status;
  final int userId;

  const TeacherModel(
      {required this.name,
      required this.url,
      required this.note,
      required this.userId,
      required this.phone,
      required this.teacherCode,
      required this.status});

  factory TeacherModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TeacherModel(
        name: data["name"],
        note: data["note"],
        userId: data['user_id'],
        phone: data["phone"],
        teacherCode: data["teacher_code"],
        url: data['url'],
        status: data['status']);
  }
}
