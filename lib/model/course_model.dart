import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class CourseModel {
  final int courseId, lessonCount, termId;
  final String description, level, termName, title, type;

  CourseModel(
      {required this.courseId,
      required this.description,
      required this.lessonCount,
      required this.level,
      required this.termId,
      required this.termName,
      required this.title,
      required this.type});

  String get name {
    switch (type) {
      case 'jlpt':
        return AppText.textJlpt.text;
      case 'kaiwa':
        return AppText.textKaiwa.text;
      default:
        return AppText.textGeneral.text;
    }
  }

  factory CourseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CourseModel(
        courseId: data['course_id'],
        description: data['description'],
        lessonCount: data['lesson_count'],
        level: data['level'],
        termId: data['term_id'],
        termName: data['term_name'],
        title: data['title'],
        type: data['type']);
  }
}
