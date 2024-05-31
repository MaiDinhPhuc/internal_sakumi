import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String name, note, phone, teacherCode, url, status, email;
  final int userId;
  final Map schedule;

  const TeacherModel(
      {required this.name,
      required this.url,
      required this.note,
      required this.userId,
      required this.phone,
      required this.teacherCode,
      required this.status,
      required this.schedule,
      required this.email});
  TeacherModel copyWith(
      {String? name,
      String? note,
      String? phone,
      String? teacherCode,
      String? url,
      String? status,
      int? userId,
      String? type,
      String? email,
      Map? schedule}) {
    return TeacherModel(
        name: name ?? this.name,
        note: note ?? this.note,
        phone: phone ?? this.phone,
        teacherCode: teacherCode ?? this.teacherCode,
        url: url ?? this.url,
        status: status ?? this.status,
        userId: userId ?? this.userId,
        schedule: schedule ?? this.schedule,
        email: email ?? this.email);
  }

  Color getRankColor(String rank) {
    switch (rank) {
      case 'A':
        return const Color(0xff33691e);
      case 'B':
        return const Color(0xffFFD600);
      case 'C':
        return const Color(0xffF57F17);
      case 'D':
        return const Color(0xffE65100);
      case 'F':
      case 'E':
        return const Color(0xffB71C1C);
      default:
        return const Color(0xff33691e);
    }
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
        status: data['status'] ?? 'Chính thức',
        schedule: data['schedule'] ??
            {
              'Mon': [],
              'Tue': [],
              'Wed': [],
              'Thu': [],
              'Fri': [],
              'Sat': [],
              'Sun': []
            },
        email: data["email"]);
  }
}
