import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/model/custom_lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class LessonModel {
  final int lessonId,
      courseId,
      btvn,
      alphabet,
      flashcard,
      grammar,
      kanji,
      listening,
      order,
      vocabulary,
      reading;
  final String description, content, title;
  final bool enable, isCustom;
  final List<dynamic> customLessonInfo;

  LessonModel(
      {required this.lessonId,
      required this.courseId,
      required this.description,
      required this.content,
      required this.title,
      required this.btvn,
      required this.vocabulary,
      required this.listening,
      required this.kanji,
      required this.grammar,
      required this.flashcard,
      required this.alphabet,
      required this.order,
      required this.reading,
      required this.enable,
      required this.customLessonInfo,
      required this.isCustom});

  static Future<bool> check(String jsonData) async {
    final data = json.decode(jsonData);
    for (var i in data) {
      int lessonCount = await FireBaseProvider.instance
          .getCountWithCondition("lessons", "lesson_id", i['lesson_id']);
      if (lessonCount != 0) {
        return false;
      }
    }
    return true;
  }

  LessonModel copyWith({CustomLessonsModel? customLesson}) {
    return LessonModel(
        lessonId: customLesson!.customLessonId,
        courseId: -1,
        description: customLesson.description,
        content: "",
        title: customLesson.title,
        btvn: 0,
        vocabulary: 0,
        listening: 0,
        kanji: 0,
        grammar: 0,
        flashcard: 0,
        alphabet: 0,
        order: 0,
        reading: 0,
        enable: true,
        customLessonInfo: customLesson.lessonInfo,
        isCustom: true);
  }

  factory LessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LessonModel(
        lessonId: data['lesson_id'] ?? 0,
        courseId: data['course_id'] ?? 0,
        description: data['description'] ?? "",
        content: data['content'] ?? "",
        title: data['title'] ?? "",
        btvn: data['btvn'] ?? 0,
        vocabulary: data['vocabulary'] ?? 0,
        listening: data['listening'] ?? 0,
        kanji: data['kanji'] ?? 0,
        grammar: data['grammar'] ?? 0,
        flashcard: data['flashcard'] ?? 0,
        alphabet: data['alphabet'] ?? 0,
        order: data['order'] ?? 0,
        reading: data['reading'] ?? 0,
        enable: data['enable'] ?? true,
        customLessonInfo: [],
        isCustom: false);
  }
}
