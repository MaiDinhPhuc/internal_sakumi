import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/homework_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

class TeacherRepository {
  static TeacherRepository fromContext(BuildContext context) =>
      RepositoryProvider.of<TeacherRepository>(context);

  Future<TeacherModel> getTeacher(String teacherCode) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("teacher")
        .where("teacher_code", isEqualTo: teacherCode)
        .get();
    final classByClassId =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;
    return classByClassId;
  }

  Future<TeacherModel> getTeacherById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();
    final classByClassId =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;
    return classByClassId;
  }

  Future<List<TeacherClassModel>> getTeacherClassById(
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

    //list.sort((a, b) => a.lessonId.compareTo(b.lessonId));

    return list;
  }

  Future<LessonResultModel> getLessonResultByLessonId(
      int id, int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("lesson_result")
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: id)
        .get();
    final result =
        snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).single;
    return result;
  }

  Future<StudentLessonModel> getStudentLessonInClass(
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

  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(
      int classId) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .get();

    final list =
        snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(
      int classId, int lessonId) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    final list =
        snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<List<AnswerModel>> getAnswerOfQuestion(
      int questionId, int lessonId, int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('answer')
        .where('parent_id', isEqualTo: lessonId)
        .where('question_id', isEqualTo: questionId)
        .where('class_id', isEqualTo: classId)
        .get();

    final list =
        snapshot.docs.map((e) => AnswerModel.fromSnapshot(e)).toList();
    return list;
  }
  
  

  Future<List<StudentLessonModel>> getAllStudentLessons() async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db.collection('student_lesson').get();

    final list =
        snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<HomeworkModel?> getHomework(int lessonId, int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("homework")
        .where("lesson_id", isEqualTo: lessonId)
        .where("class_id", isEqualTo: classId)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final homework =
        snapshot.docs.map((e) => HomeworkModel.fromSnapshot(e)).single;
    return homework;
  }

  Future<QuestionModel> getQuestionByQuestionId(int questionId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("questions")
        .where("id", isEqualTo: questionId)
        .get();
    final question =
        snapshot.docs.map((e) => QuestionModel.fromSnapshot(e)).single;
    return question;
  }

  Future<List<QuestionModel>> getDefaultHwQuestionByLessonId(
      int lessonId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("questions")
        .where("lesson_id", isEqualTo: lessonId)
        .where("is_hw_default", isEqualTo: true)
        .get();
    final questions =
    snapshot.docs.map((e) => QuestionModel.fromSnapshot(e)).toList();
    return questions;
  }

  Future<void> updateTimekeeping(
      int id, int lessonId, int classId, int attendId) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('student_lesson')
        .doc("student_${id}_lesson_${lessonId}_class_$classId")
        .update({
      'time_keeping': attendId,
    });
  }

  Future<void> changeStatusLesson(
      int lessonId, int classId, String status) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'status': status,
    });
  }

  Future<void> noteForAllStudentInClass(
      int lessonId, int classId, String note) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId + 1}_class_$classId")
        .update({
      'student_note': note,
    });
  }
}
