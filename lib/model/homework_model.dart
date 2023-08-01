import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkModel {
  final int id, teacherId, classId, lessonId;
  final List questions;

  HomeworkModel(
      {required this.id,
      required this.teacherId,
      required this.classId,
      required this.lessonId,
      required this.questions});
  factory HomeworkModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return HomeworkModel(
        id: data['id'],
        lessonId: data['lesson_id'],
        teacherId: data['teacher_id'],
        classId: data['class_id'],
        questions: data['questions']);
  }
}
