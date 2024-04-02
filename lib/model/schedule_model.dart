import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final int id, teacherId, classId, date;
  final String status, type, startTime, endTime;
  final List role;

  ScheduleModel(
      {required this.id,
      required this.teacherId,
      required this.status,
      required this.classId,
      required this.type,
      required this.startTime,
      required this.endTime,
      required this.role,
      required this.date});
  factory ScheduleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ScheduleModel(
        id: data['id'],
        teacherId: data['teacher_id'],
        status: data['status'] ?? 'Teaching',
        classId: data['class_id'] ?? 0,
        endTime: data['end_time'] ?? '00:00',
        startTime: data['start_time'] ?? "00:00",
        type: data['type'] ?? 'cyclic',
        role: data['role'] ?? [],
        date: data['date'] ?? 0);
  }
}
