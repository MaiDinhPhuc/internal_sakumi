import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String surveyCode, title, description;
  final int id;
  final List<Map> detail;
  const SurveyModel(
      {required this.surveyCode,
      required this.title,
      required this.description,
      required this.id,
      required this.detail});

  factory SurveyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyModel(
        surveyCode: data["surveyCode"] ?? "",
        title: data["title"] ?? "",
        description: data['description'] ?? "",
        id: data["id"] ?? 0,
        detail: data["detail"] ?? []);
  }
}
