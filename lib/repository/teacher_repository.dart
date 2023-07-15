import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

class TeacherRepository {
  static TeacherRepository fromContext(BuildContext context) =>
      RepositoryProvider.of<TeacherRepository>(context);

  static Future<TeacherModel> getTeacher(String teacherCode) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("teacher")
        .where("teacher_code", isEqualTo: teacherCode)
        .get();
    final classByClassId =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;
    return classByClassId;
  }

  static Future<TeacherModel> getTeacherById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();
    final classByClassId =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;
    return classByClassId;
  }

  static Future<List<TeacherClassModel>> getTeacherClassById(
      String string, int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("teacher_class").where(string, isEqualTo: id).get();
    final listTeacher =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listTeacher;
  }

  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("lessons").where('course_id', isEqualTo: id).get();
    final lessons =
        snapshot.docs.map((e) => LessonModel.fromSnapshot(e)).toList();
    lessons.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    return lessons;
  }

  Future<ClassModel> getClassById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("class").where('class_id', isEqualTo: id).get();
    final result = snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).single;
    return result;
  }

  Future<List<LessonResultModel>> getLessonResultByClassId(int id) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: id)
        .get();

    final list =
        snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).toList();

    list.sort((a, b) => a.lessonId.compareTo(b.lessonId));

    return list;
  }

  static Future<LessonResultModel> getLessonResultByLessonId(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("lesson_result")
        .where('lesson_id', isEqualTo: id)
        .get();
    final lesson =
        snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).single;
    return lesson;
  }

  static Future<List<CourseModel>> getAllCourse() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("courses").get();
    final courses =
        snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    return courses;
  }

  static Future<StudentLessonModel> getStudentLesson(
      int id, int lessonId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("student_lesson")
        .where('lesson_id', isEqualTo: lessonId)
        .where('student_id', isEqualTo: id)
        .get();
    final result =
        snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).single;

    return result;
  }

  Future<List<StudentLessonModel>> getStudentLessonsByLessonId(int id) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('student_lesson')
        .where('lesson_id', isEqualTo: id)
        .get();

    final list =
        snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();

    list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }
}
