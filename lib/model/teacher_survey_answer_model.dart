import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherSurveyAnswerModel {

  final int id, teacherId, surveyId, dateAssign;
  final List<dynamic> detail;

  const TeacherSurveyAnswerModel(
      {required this.teacherId,
        required this.surveyId,
        required this.id,
        required this.detail,
        required this.dateAssign
       });

  factory TeacherSurveyAnswerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TeacherSurveyAnswerModel(
        detail: data["detail"] ?? [],
        teacherId: data["teacher_id"] ?? 0,
        surveyId: data['survey_id'] ?? 0,
        dateAssign: data['date_assign'] ?? 0,
        id: data["id"] ?? 0);
  }
}