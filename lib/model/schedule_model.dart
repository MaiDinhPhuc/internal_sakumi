import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final int id, teacherId, classId, date, startDate, endDate;
  final String status, type;
  final List role;
  final Map calendar;

  ScheduleModel(
      {required this.id,
      required this.teacherId,
      required this.status,
      required this.classId,
      required this.type,
      required this.calendar,
      required this.role,
      required this.date,
      required this.startDate,
      required this.endDate});
  factory ScheduleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ScheduleModel(
        id: data['id'],
        teacherId: data['teacher_id'],
        status: data['status'] ?? 'Teaching',
        classId: data['class_id'] ?? 0,
        calendar: data['calendar'] ?? {},
        type: data['type'] ?? 'cyclic',
        startDate: data['start_date'] ?? 0,
        endDate: data['end_date'] ?? 0,
        role: data['role'] ?? [],
        date: data['date'] ?? 0);
  }
}
