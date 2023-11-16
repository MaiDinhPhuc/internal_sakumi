import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTestModel {
  final int classId, score, studentId, testID;
  final String doingTime;

  const StudentTestModel(
      {required this.classId,
      required this.score,
      required this.studentId,
      required this.testID,
      required this.doingTime});

  factory StudentTestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentTestModel(
      classId: data["class_id"] ?? 0,
      score: data["score"] ?? 0,
      studentId: data['student_id'] ?? 0,
      testID: data["test_id"] ?? 0,
      doingTime:  data["test_time"] ?? ""
    );
  }
}
