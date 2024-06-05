import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherSurveyModel {
  final String status, surveyCode, title;
  final int id, teacherId, surveyId, dateAssign;

  const TeacherSurveyModel(
      {required this.status,
        required this.teacherId,
        required this.surveyId,
        required this.id,
        required this.title,
        required this.surveyCode,
        required this.dateAssign});

  factory TeacherSurveyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TeacherSurveyModel(
        status: data["status"] ?? "",
        teacherId: data["teacher_id"] ?? 0,
        surveyId: data['survey_id'] ?? 0,
        id: data["id"] ?? 0,
        surveyCode: data['survey_code'] ?? "",
        title: data['title'] ?? "",
        dateAssign: data['date_assign'] ?? 0);
  }

//status
//delete: xoá
//assign: đã giao
//done: đã làm
}