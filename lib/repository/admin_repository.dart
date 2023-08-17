import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

class AdminRepository {
  static AdminRepository fromContext(BuildContext context) =>
      RepositoryProvider.of<AdminRepository>(context);

  Future<List<ClassModel>> getListClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("class").get();
    final listClass =
        snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).toList();
    return listClass;
  }

  Future<List<StudentClassModel>> getStudentClassByClassId(int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .get();
    final listStudent =
        snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    debugPrint('===============> getStudentClassByClassId ${listStudent.length} == ${listStudent.first.userId}');
    return listStudent;
  }

  Future<List<StudentClassModel>> getAllStudentInClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("student_class").get();
    final listStudent =
        snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  Future<List<TeacherClassModel>> getAllTeacherInClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher_class").get();
    final listSensei =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listSensei;
  }

  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(
      int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("teacher_class")
        .where('class_id', isEqualTo: classId)
        .get();
    final listTeacher =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listTeacher;
  }

  Future<List<StudentModel>> getAllStudent() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("students").get();
    final lists =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).toList();
    print("============> sflsdkflsdklf");
    return lists;
  }

  Future<List<TeacherModel>> getAllTeacher() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher").get();
    final lists =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList();
    return lists;
  }

  Future<StudentModel> getStudentByUserId(int userId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('students')
        .where('user_id', isEqualTo: userId)
        .get();
    final result =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return result;
  }

  Future<List<TagModel>> getTags() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("tags").get();
    final tags = snapshot.docs.map((e) => TagModel.fromSnapshot(e)).toList();
    return tags;
  }

  Future<AdminModel> getAdminById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("admin").where("user_id", isEqualTo: id).get();
    final admin = snapshot.docs.map((e) => AdminModel.fromSnapshot(e)).single;
    return admin;
  }

  Future<List<CourseModel>> getAllCourse() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("courses").get();
    final courses =
        snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    return courses;
  }

  Future<CourseModel> getCourseByName(String title, String term) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("courses")
        .where('title', isEqualTo: title)
        .where('term_name', isEqualTo: term)
        .get();
    final course = snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).single;
    return course;
  }

  Future<bool> createNewClass(ClassModel model, BuildContext context) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("class")
        .where('class_code', isEqualTo: model.classCode)
        .get();

    if (temp.docs.isEmpty) {
      debugPrint('===============> check var ${model.classCode}');
      await db
          .collection("class")
          .doc("class_${model.classId}_course_${model.courseId}")
          .set({
        'class_id': model.classId,
        'course_id': model.courseId,
        'description': model.description,
        'end_time': model.endTime,
        'start_time': model.startTime,
        'note': model.note,
        'class_code': model.classCode,
      });
      return true;
    } else {
      debugPrint('===============> check var 000 ${model.classCode}');
      return false;
    }
  }

  Future<bool> addStudentToClass(StudentClassModel model) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("student_class").doc("student_${model.userId}_class_${model.classId}")
        .get();

    if(!temp.exists){
      await db
          .collection("student_class")
          .doc("student_${model.userId}_class_${model.classId}")
          .set({
        'active_status': model.activeStatus,
        'class_id': model.classId,
        'class_status': model.classStatus,
        'date': model.date,
        'id': model.id,
        'learning_status': model.learningStatus,
        'move_to': model.moveTo,
        'user_id': model.userId,
      });
      return true;
    } else{
      return false;
    }
  }

  Future<bool> addTeacherToClass(TeacherClassModel model) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("teacher_class").doc("teacher_${model.userId}_class_${model.classId}")
        .get();

    if(!temp.exists){
      await db
          .collection("teacher_class")
          .doc("teacher_${model.userId}_class_${model.classId}")
          .set({
        'class_id': model.classId,
        'class_status': model.classStatus,
        'date': model.date,
        'id': model.id,
        'user_id': model.userId,
      });
      return true;
    } else{
      return false;
    }
  }
}
