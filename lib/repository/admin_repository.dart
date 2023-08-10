import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
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
    return listStudent;
  }

  Future<List<StudentClassModel>> getAllStudentInClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("student_class").get();
    final listStudent =
        snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher_class").where('class_id', isEqualTo: classId).get();
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
}
