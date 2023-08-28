import 'package:cloud_firestore/cloud_firestore.dart';

class TestResultModel {

  final int classId, testId, teacherId, courseId;
  final String date;


  const TestResultModel(
      {required this.classId,
        required this.testId,
        required this.courseId,
        required this.teacherId,
        required this.date
      });

  factory TestResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TestResultModel(
      classId: data["class_id"] ?? 0,
      testId: data["test_id"]??0,
      courseId: data['course_id']??0,
      teacherId: data["teacher_id"]??0,
      date: data['date']??""
    );
  }
}
