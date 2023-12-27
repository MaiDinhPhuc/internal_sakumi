import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResultModel {
  final String status, surveyCode, title;
  final int id, classId, surveyId, dateAssign;

  const SurveyResultModel(
      {required this.status,
      required this.classId,
      required this.surveyId,
      required this.id,
      required this.title,
      required this.surveyCode,
      required this.dateAssign});

  factory SurveyResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyResultModel(
        status: data["status"] ?? "",
        classId: data["class_id"] ?? 0,
        surveyId: data['survey_id'] ?? 0,
        id: data["id"] ?? 0,
        surveyCode: data['survey_code'] ?? "",
        title: data['title'] ?? "",
        dateAssign: data['date_assign'] ?? 0);
  }

//status
//recall: thu hồi
//waiting
//delete: xoá
//assigned: đã giao
}
