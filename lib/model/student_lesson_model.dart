import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class StudentLessonModel {
  final int grammar,
      hw,
      id,
      kanji,
      lessonId,
      classId,
      listening,
      studentId,
      timekeeping,
      vocabulary;
  final String teacherNote, supportNote;

  Color get attendColor {
    if(timekeeping == 5) return const Color(0xffF57F17);
    if(timekeeping == 6) return const Color(0xffB71C1C);
    if(timekeeping < 5) return const Color(0xff33691E);

    return primaryColor;
  }

  String get attendTitle {
    if(timekeeping == 6) return AppText.txtAbsent.text;
    if(timekeeping == 5) return AppText.txtPermitted.text;
    if(timekeeping < 5) return AppText.txtPresent.text;

    return AppText.txtNotTimeKeeping.text;
  }

  StudentLessonModel(
      {required this.grammar,
      required this.hw,
      required this.id,
      required this.classId,
      required this.kanji,
      required this.lessonId,
      required this.listening,
      required this.studentId,
      required this.timekeeping,
      required this.vocabulary,
      required this.teacherNote, required this.supportNote});

  factory StudentLessonModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentLessonModel(
        grammar: data["grammar"],
        hw: data["hw"],
        id: data['id'],
        classId: data['class_id'] ?? 0,
        kanji: data["kanji"],
        lessonId: data["lesson_id"],
        listening: data['listening'],
        studentId: data['student_id'],
        timekeeping: data['time_keeping'],
        teacherNote: data['teacher_note'],
        vocabulary: data['vocabulary'], supportNote: data['support_note']??'');
  }
}
