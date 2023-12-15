import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CourseModel {
  final int courseId, lessonCount, termId, version;
  final String description,
      level,
      termName,
      title,
      type,
      token,
      code,
      suffix,
      prefix;
  final bool enable;

  CourseModel(
      {required this.courseId,
      required this.description,
      required this.lessonCount,
      required this.level,
      required this.termId,
      required this.termName,
      required this.title,
      required this.type,
      required this.token,
      required this.code,
      required this.enable,
      required this.version,
      required this.prefix,
      required this.suffix});

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

  String get bigTitle {
    return "$name $level $termName";
  }

  static Future<bool> check(String jsonData) async {
    final data = json.decode(jsonData);
    for (var i in data) {
      int courseCount = await FireBaseProvider.instance
          .getCountWithCondition("courses", "course_id", i['course_id']);
      if (courseCount != 0) {
        return false;
      }
    }
    return true;
  }

  factory CourseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CourseModel(
        courseId: data['course_id'],
        description: data['description'] ?? "",
        lessonCount: data['lesson_count'],
        level: data['level'],
        termId: data['term_id'],
        termName: data['term_name'] ?? "",
        title: data['title'] ?? "",
        token: data['token'] ?? "",
        type: data['type'] ?? "general",
        code: data['code'] ?? "",
        enable: data['enable'] ?? true,
        version: data['dataversion'] ?? 1,
        prefix: data['prefix'] ?? "",
        suffix: data['suffix'] ?? "");
  }
}
