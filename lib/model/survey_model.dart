import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String surveyCode, title, description;
  final int id;
  final List<dynamic> detail;
  final bool enable, active;
  const SurveyModel(
      {required this.surveyCode,
      required this.title,
      required this.description,
      required this.id,
      required this.detail,
      required this.enable,
      required this.active});

  SurveyModel copyWith(
      {String? surveyCode,
      String? title,
      int? id,
      String? description,
      List<dynamic>? detail,
      bool? enable,
      bool? active}) {
    return SurveyModel(
        surveyCode: surveyCode ?? this.surveyCode,
        title: title ?? this.title,
        id: id ?? this.id,
        description: description ?? this.description,
        detail: detail ?? this.detail,
        enable: enable ?? this.enable,
        active: active ?? this.active);
  }

  factory SurveyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SurveyModel(
        surveyCode: data["survey_code"] ?? "",
        title: data["title"] ?? "",
        description: data['description'] ?? "",
        id: data["id"] ?? 0,
        detail: data["detail"] ?? [],
        enable: data['enable'] ?? true,
        active: data['active'] ?? false);
  }
}
