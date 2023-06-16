import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String name, note, phone, studentCode, url, status;
  final int userId;
  final bool inJapan;

  const StudentModel(
      {required this.name,
      required this.url,
      required this.note,
      required this.userId,
      required this.inJapan,
      required this.phone,
      required this.studentCode,
      required this.status});

  factory StudentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentModel(
        name: data["name"],
        note: data["note"],
        userId: data['user_id'],
        phone: data["phone"],
        studentCode: data["student_code"],
        url: data['url'],
        inJapan: data['in_jp'],
        status: data['status']);
  }
}
