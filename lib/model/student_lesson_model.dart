import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLessonModel {
  final int grammar,
      hw,
      id,
      kanji,
      lessonId,
      classId,
      listening,
      studentId,
      timekeeping,
      vocabulary;
  final String teacherNote;

  StudentLessonModel(
      {required this.grammar,
      required this.hw,
      required this.id,
      required this.classId,
      required this.kanji,
      required this.lessonId,
      required this.listening,
      required this.studentId,
      required this.timekeeping,
      required this.vocabulary,
      required this.teacherNote});

  factory StudentLessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentLessonModel(
        grammar: data["grammar"],
        hw: data["hw"],
        id: data['id'],
        classId: data['class_id'] ?? 0,
        kanji: data["kanji"],
        lessonId: data["lesson_id"],
        listening: data['listening'],
        studentId: data['student_id'],
        timekeeping: data['time_keeping'],
        teacherNote: data['teacher_note'],
        vocabulary: data['vocabulary']);
  }
}
