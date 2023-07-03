import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}
