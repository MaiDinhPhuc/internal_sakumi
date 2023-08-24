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
  TeacherModel copyWith({
    String? name,
    String? note,
    String? phone,
    String? teacherCode,
    String? url,
    String? status,
    int? userId,
  }) {
    return TeacherModel(
      name: name ?? this.name,
      note: note ?? this.note,
      phone: phone ?? this.phone,
      teacherCode: teacherCode ?? this.teacherCode,
      url: url ?? this.url,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
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
