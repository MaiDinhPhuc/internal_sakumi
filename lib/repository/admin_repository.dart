import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

class AdminRepository {
  static Future<List<ClassModel>> getListClass() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("class").get();
    final listClass =
        snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).toList();
    return listClass;
  }

  static Future<List<StudentModel>> getListStudent() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("students").get();
    final listStudent =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  static Future<List<TeacherModel>> getListTeacher() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("teacher").get();
    final lists =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList();
    return lists;
  }

  static Future<StudentModel> getUserByUserId(int userId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('students')
        .where('user_id', isEqualTo: userId)
        .get();
    final result =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return result;
  }
}
