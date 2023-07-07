import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

class AdminRepository {
  static Future<List<ClassModel>> getListClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("class").get();
    final listClass =
        snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).toList();
    return listClass;
  }

  static Future<List<StudentClassModel>> getStudentClassByClassId(
      int classId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .get();
    final listStudent =
        snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  static Future<List<StudentClassModel>> getAllStudentInClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("student_class").get();
    final listStudent =
        snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  static Future<List<TeacherClassModel>> getAllTeacherInClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher_class").get();
    final listTeacher =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listTeacher;
  }

  static Future<List<StudentModel>> getAllStudent() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("students").get();
    final lists =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).toList();
    print("============> sflsdkflsdklf");
    return lists;
  }

  static Future<List<TeacherModel>> getAllTeacher() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher").get();
    final lists =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList();
    return lists;
  }

  static Future<StudentModel> getStudentByUserId(int userId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('students')
        .where('user_id', isEqualTo: userId)
        .get();
    final result =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return result;
  }

  static Future<List<TagModel>> getTags() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("tags").get();
    final tags = snapshot.docs.map((e) => TagModel.fromSnapshot(e)).toList();
    return tags;
  }

  static Future<AdminModel> getAdminById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("admin").where("user_id", isEqualTo: id).get();
    final admin = snapshot.docs.map((e) => AdminModel.fromSnapshot(e)).single;
    return admin;
  }
}
