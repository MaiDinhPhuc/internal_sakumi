import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final int lessonId, courseId;
  final String description, content, title;

  LessonModel(
      {required this.lessonId,
      required this.courseId,
      required this.description,
      required this.content,
      required this.title});
  factory LessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LessonModel(
        lessonId: data['lesson_id'],
        courseId: data['course_id'],
        description: data['description'],
        content: data['content'],
        title: data['title']);
  }
}
