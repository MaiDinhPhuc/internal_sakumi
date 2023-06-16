import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';

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

  // static Future<bool> saveLogin(UserModel user, String password) async {
  //   await BaseSharedPreferences.setString('user_id', user.id.toString());
  //   await BaseSharedPreferences.setString('user_email', user.email);
  //   await BaseSharedPreferences.setString('role', user.role);
  //   await BaseSharedPreferences.setString('password', password);
  //   return true;
  // }

  // static void updateAvtStudent(StudentModel studentModel, String url) async {
  //   final db = FirebaseFirestore.instance;
  //   var collection = db.collection('students');
  //   collection.doc('student_user_${studentModel.userId}').update({"url": url});
  // }

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

  // static Future<List<StudentClassModel>> getClassByStudentId(
  //     int studentId) async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db
  //       .collection("student_class")
  //       .where("user_id", isEqualTo: studentId)
  //       .get();
  //   final classes =
  //   snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
  //   return classes;
  // }

  // static Future<List<LessonModel>> getLessonById(
  //     int classId, int courseId) async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db
  //       .collection("lessons")
  //   // .where("class_id", isEqualTo: classId)
  //       .where("course_id", isEqualTo: courseId)
  //       .get();
  //   final lessons =
  //   snapshot.docs.map((e) => LessonModel.fromSnapshot(e)).toList();
  //   return lessons;
  // }

  // static Future<List<QuestionModel>> getQuestion(
  //     int courseId, int classId, int lessonId) async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db
  //       .collection("questions")
  //       .where("class_id", isEqualTo: classId)
  //       .where("course_id", isEqualTo: courseId)
  //       .where("lesson_id", isEqualTo: lessonId)
  //       .get();
  //   final questions =
  //   snapshot.docs.map((e) => QuestionModel.fromSnapshot(e)).toList();
  //   questions.shuffle();
  //   return questions;
  // }

  // static Future<QuestionModel> getQuestionById(
  //     int classId, int courseId, int lessonId, int questionId) async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db
  //       .collection("questions")
  //       .where("question_id", isEqualTo: questionId)
  //       .where("class_id", isEqualTo: classId)
  //       .where("course_id", isEqualTo: courseId)
  //       .where("lesson_id", isEqualTo: lessonId)
  //       .get();
  //   final question =
  //       snapshot.docs.map((e) => QuestionModel.fromSnapshot(e)).single;
  //   return question;
  // }

  // static Future<List<StudentQuestionModel>> getStudentQuestion(
  //     int lessonId, int classId, int courseId, int studentId) async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db
  //       .collection("student_questions")
  //       .where("class_id", isEqualTo: classId)
  //       .where("course_id", isEqualTo: courseId)
  //       .where("lesson_id", isEqualTo: lessonId)
  //       .where("user_id", isEqualTo: studentId)
  //       .get();
  //   final questions =
  //   snapshot.docs.map((e) => StudentQuestionModel.fromSnapshot(e)).toList();
  //   questions.shuffle();
  //   return questions;
  // }

  // static Future<List<QuestionModel>> getDataFromJson() async {
  //   final jsonData = await rootBundle.loadString("assets/question.json");
  //   final response = jsonDecode(jsonData) as List<dynamic>;
  //   List<QuestionModel> question = response.isNotEmpty
  //       ? response.map((e) => QuestionModel.fromMap(e)).toList()
  //       : [];
  //   return question;
  // }
}
