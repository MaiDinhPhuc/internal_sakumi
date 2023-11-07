import 'package:cloud_firestore/cloud_firestore.dart';

class LessonResultModel {
  final int id, lessonId, classId, teacherId;
  final String? noteForTeacher, noteForStudent, noteForSupport, status, date, supportNoteForTeacher;

  LessonResultModel(
      {required this.id,
      required this.classId,
      required this.lessonId,
      required this.teacherId,
      required this.status,
      required this.date,
      required this.noteForStudent,
      required this.noteForSupport,
      required this.noteForTeacher, required this.supportNoteForTeacher});
  factory LessonResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LessonResultModel(
        id: data['id'],
        lessonId: data['lesson_id'],
        classId: data['class_id'],
        teacherId: data['teacher_id'],
        status: data['status'],
        date: data['date'],
        noteForStudent: data['student_note'],
        noteForSupport: data['support_note'],
        noteForTeacher: data['teacher_note'], supportNoteForTeacher: data["support_note_for_teacher"]??"");
  }
}
