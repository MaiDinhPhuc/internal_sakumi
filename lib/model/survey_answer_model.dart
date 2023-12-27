import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyAnswerModel {
  final String studentName, studentAvt;
  final int id, classId, surveyId, studentId;
  final List<dynamic> detail;

  const SurveyAnswerModel(
      {required this.classId,
      required this.surveyId,
      required this.id,
      required this.detail,
      required this.studentId,
      required this.studentAvt,
      required this.studentName});

  factory SurveyAnswerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyAnswerModel(
        detail: data["detail"] ?? [],
        classId: data["class_id"] ?? 0,
        surveyId: data['survey_id'] ?? 0,
        id: data["id"] ?? 0,
        studentId: data['student_id'] ?? 0,
        studentAvt: data['student_avt'] ?? "",
        studentName: data['student_name'] ?? "");
  }
}
