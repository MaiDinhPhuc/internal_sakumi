import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final int classId, courseId;
  final String description, endTime, startTime, note, classCode, status;
  final List listStudent, listTeacher;

  ClassModel(
      {required this.classId,
      required this.courseId,
      required this.description,
      required this.endTime,
      required this.startTime,
      required this.note,
      required this.classCode,
      required this.status,
      required this.listStudent,
      required this.listTeacher});
  factory ClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ClassModel(
        classId: data['class_id'],
        courseId: data['course_id'],
        description: data['description'],
        endTime: data['end_time'],
        startTime: data['start_time'],
        note: data['note'],
        classCode: data['class_code'],
        status: data['status'],
        listStudent: data['list_student'].toList(),
        listTeacher: data['list_teacher'].toList());
  }
}
