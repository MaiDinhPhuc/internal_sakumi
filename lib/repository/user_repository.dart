import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static Future<StudentModel> getStudentInfo(int userId) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection("students")
        .where("user_id", isEqualTo: userId)
        .get();
    final studentInfo =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return studentInfo;
  }

  static Future<UserModel> getUser(String email) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("users").where("email", isEqualTo: email).get();
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return user;
  }

  static Future<ClassModel> getClassByClassId(int classId, int courseId) async {
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

  static Future<String?> getName() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.getString(PrefKeyConfigs.name);
  }
}
