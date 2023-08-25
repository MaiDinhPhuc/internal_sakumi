import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
        snapshot.docs
            .map((e) => TeacherModel.fromSnapshot(e))
            .single;
    return classByClassId;
  }

  Future<TeacherModel> getTeacherById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
    await db.collection("teacher").where("user_id", isEqualTo: id).get();
    final classByClassId =
        snapshot.docs
            .map((e) => TeacherModel.fromSnapshot(e))
            .single;
    return classByClassId;
  }

  Future<List<TeacherClassModel>> getTeacherClassById(String string,
      int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
    await db.collection("teacher_class").where(string, isEqualTo: id).get();
    final listTeacher =
    snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listTeacher;
  }

  Future<List<TeacherClassModel>> getTeacherClassByStatus(int id,
      String status) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("teacher_class")
        .where('user_id', isEqualTo: id)
        .where('class_status', isEqualTo: status)
        .get();
    final list =
    snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return list;
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

  Future<List<LessonModel>> getAllLesson() async {
    final db = FirebaseFirestore.instance;
    final snapshot =
    await db.collection("lessons").get();
    final lessons =
    snapshot.docs.map((e) => LessonModel.fromSnapshot(e)).toList();
    //lessons.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    return lessons;
  }

  Future<ClassModel> getClassById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
    await db.collection("class").where('class_id', isEqualTo: id).get();
    final result = snapshot.docs
        .map((e) => ClassModel.fromSnapshot(e))
        .single;
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

  Future<List<LessonResultModel>> getAllLessonResult() async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db.collection('lesson_result').get();

    final list =
    snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).toList();

    return list;
  }

  Future<LessonResultModel> getLessonResultByLessonId(int id,
      int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("lesson_result")
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: id)
        .get();
    debugPrint('===============> getLessonResultByLessonId ${snapshot.size}');
    final result =
        snapshot.docs
            .map((e) => LessonResultModel.fromSnapshot(e))
            .single;
    // debugPrint('===============> getLessonResultByLessonId ${result.lessonId}');
    return result;
  }

  Future<List<CourseModel>> getAllCourse() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("courses").get();
    final courses =
    snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    return courses;
  }

  Future<List<QuestionModel>> getQuestionByLessonId(String lessonId) async {
    final jsonData =
    await rootBundle.loadString("assets/practice/$lessonId/btvn.json");
    final response = jsonDecode(jsonData) as List<dynamic>;
    List<QuestionModel> list = response.isNotEmpty
        ? response.map((e) => QuestionModel.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<StudentLessonModel> getStudentLessonInClass(int id,
      int lessonId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("student_lesson")
        .where('lesson_id', isEqualTo: lessonId)
        .where('student_id', isEqualTo: id)
        .get();
    final result =
        snapshot.docs
            .map((e) => StudentLessonModel.fromSnapshot(e))
            .single;

    return result;
  }

  Future<List<StudentClassModel>> getStudentClassInClass(int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .get();
    final list =
    snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();

    return list;
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
    debugPrint('==============> getAllStudentLessonsInClass ${list.length}');
    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(int classId,
      int lessonId) async {
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

  Future<List<AnswerModel>> getAnswersOfQuestion(int lessonId,
      int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('answer')
        .where('parent_id', isEqualTo: lessonId)
        .where('class_id', isEqualTo: classId)
        .get();

    final list = snapshot.docs.map((e) => AnswerModel.fromSnapshot(e)).toList();
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

  Future<ClassModel> getClass(int classId) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('class')
        .where('class_id', isEqualTo: classId)
        .get();

    final result = snapshot.docs
        .map((e) => ClassModel.fromSnapshot(e))
        .single;

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return result;
  }

  Future<LessonModel> getLesson(int courseId, int lessonId) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db
        .collection('lessons')
        .where('course_id', isEqualTo: courseId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    final lesson = snapshot.docs
        .map((e) => LessonModel.fromSnapshot(e))
        .single;

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return lesson;
  }

  Future<void> updateTimekeeping(int userId, int lessonId, int classId,
      int attendId) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'time_keeping': attendId,
    });
  }

  Future<void> updateTeacherNote(int userId, int lessonId, int classId,
      String note) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
  }

  Future<void> updateStudentStatus(int userId, int classId, int point,
      String type) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('student_class')
        .doc("student_${userId}_class_$classId")
        .update({
      type: point,
    });
  }

  Future<void> changeStatusLesson(int lessonId, int classId,
      String status) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'status': status,
    });
  }

  Future<void> noteForAllStudentInClass(int lessonId, int classId,
      String note) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'student_note': note,
    });
  }

  Future<void> noteForSupport(int lessonId, int classId, String note) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'support_note': note,
    });
  }

  Future<void> noteForAnotherSensei(int lessonId, int classId,
      String note) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
  }

  Future<bool> addStudentLesson(StudentLessonModel model) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("student_lesson")
        .doc(
        "student_${model.studentId}_lesson_${model.lessonId}_class_${model
            .classId}")
        .get();

    if (!temp.exists) {
      await db
          .collection("student_lesson")
          .doc(
          "student_${model.studentId}_lesson_${model.lessonId}_class_${model
              .classId}")
          .set({
        'class_id': model.classId,
        'grammar': model.grammar,
        'hw': model.hw,
        'id': model.id,
        'kanji': model.kanji,
        'lesson_id': model.lessonId,
        'listening': model.listening,
        'student_id': model.studentId,
        'teacher_note': model.teacherNote,
        'time_keeping': model.timekeeping,
        'vocabulary': model.vocabulary
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkLessonResult(int lessonId, int classId) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("lesson_result")
        .doc("lesson_${lessonId}_class_$classId")
        .get();
    debugPrint('=============> temp.exists ${temp.exists}');
    if (temp.exists == false) {
      debugPrint('=============> temp.exists = false');
      return false;
    } else {
      debugPrint('=============> temp.exists = true');
      return true;
    }
  }

  Future<bool> addLessonResult(LessonResultModel model) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("lesson_result").doc(
        "lesson_${model.lessonId}_class_${model.classId}")
        .get();

    if (!temp.exists) {
      await db
          .collection("lesson_result")
          .doc("lesson_${model.lessonId}_class_${model.classId}")
          .set({
        'class_id': model.classId,
        'date': model.date,
        'id': model.id,
        'lesson_id': model.lessonId,
        'status': model.status,
        'student_note': model.noteForStudent,
        'support_note': model.noteForSupport,
        'teacher_id': model.teacherId,
        'teacher_note': model.noteForTeacher,
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfileTeacher(
      String id, TeacherModel model) async {
    final db = FirebaseFirestore.instance;

    await db.collection('teacher').doc("teacher_user_$id").update({
      'name': model.name,
      'note': model.note,
      'url': model.url,
      'status': model.status,
      'teacher_code': model.teacherCode,
      'phone': model.phone,
      'user_id': model.userId,

    });
  }

  Future<String> uploadImageAndGetUrl(Uint8List data ,String folder) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final ref = FirebaseStorage.instance.ref().child('$folder/$now');
    await ref.putData(data ,SettableMetadata(contentType: '.png'));
    return await ref.getDownloadURL();
  }
}