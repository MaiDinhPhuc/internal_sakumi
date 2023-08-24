import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static UserRepository fromContext(BuildContext context) =>
      RepositoryProvider.of<UserRepository>(context);

  Future<StudentModel> getStudentInfo(int userId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("students")
        .where("user_id", isEqualTo: userId)
        .get();
    final studentInfo =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return studentInfo;
  }

  Future<UserModel> getUser(String email) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("users").where("email", isEqualTo: email).get();
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return user;
  }
  Future<UserModel> getUserTeacherById(int id) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
    await db.collection("users").where("user_id", isEqualTo: id).get();
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return user;
  }
  Future<ClassModel> getClassByClassId(int classId, int courseId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("class")
        .where("class_id", isEqualTo: classId)
        .where("course_id", isEqualTo: courseId)
        .get();
    final classByClassId =
        snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).single;
    return classByClassId;
  }

  Future<String?> getName() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.getString(PrefKeyConfigs.name);
  }

  Future<void> saveUser(String email, String role, int uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email, 'roles': role, 'user_id': uid});
  }

  Future<List<UserModel>> getAllUser() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection("users").get();
    final lists =
    snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return lists;
  }

  Future<bool> createNewStudent(BuildContext context, StudentModel model, UserModel user) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("users")
        .where('email', isEqualTo: user.email)
        .get();

    if(temp.docs.isEmpty){
     await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      await saveUser(user.email, user.role, model.userId);
      await db
          .collection('students')
          .doc("student_user_${user.id}")
          .set({
        'in_jp': model.inJapan,
        'name': model.name,
        'note': model.note,
        'phone': model.phone,
        'student_code': model.studentCode,
        'url': model.url,
        'user_id': model.userId,
        'status': model.studentCode});
      return true;
    } else{
      return false;
    }
  }

  Future<bool> createNewTeacher(BuildContext context, TeacherModel model, UserModel user) async {
    final db = FirebaseFirestore.instance;

    final temp = await db
        .collection("users")
        .where('email', isEqualTo: user.email)
        .get();

    if(temp.docs.isEmpty){
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      await saveUser(user.email, user.role, model.userId);
      await db
          .collection('teacher')
          .doc("teacher_user_${user.id}")
          .set({
        'name': model.name,
        'note': model.note,
        'phone': model.phone,
        'status': model.status,
        'teacher_code': model.teacherCode,
        'url': model.url,
        'user_id': model.userId,
      });
      return true;
    } else{
      return false;
    }
  }
}