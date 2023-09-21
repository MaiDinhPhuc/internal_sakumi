import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/response_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/api/api_provider.dart';

import 'firebase_provider.dart';

class FireStoreDb {
  FireStoreDb._privateConstructor();

  static final FireStoreDb instance = FireStoreDb._privateConstructor();
  final db = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestionByUrl(String url) async {
    APIResponseModel response = await APIProvider.instance
        .get(url);

    if (response.statusCode == 200) {
      return (response.json as List).map((e) => QuestionModel.fromMap(e)).toList();
    } else {
      debugPrint("=======>error ${response.statusCode}");
      return [];
    }
  }

  Future<TeacherModel> getTeacherByTeacherCode(String teacherCode) async {
    final snapshot = await db
        .collection("teacher")
        .where("teacher_code", isEqualTo: teacherCode)
        .get();
    final teacher =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;

    debugPrint("==========>get db from \"teacher\"");

    return teacher;
  }

  Future<TeacherModel> getTeacherById(int id) async {
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();
    final teacher =
        snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).single;

    debugPrint("==========>get db from \"teacher\"");

    return teacher;
  }

  Future<List<TeacherClassModel>> getTeacherClassById(
      String string, int id) async {
    final snapshot =
        await db.collection("teacher_class").where(string, isEqualTo: id).get();
    final listTeacher =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();

    debugPrint("==========>get db from \"teacher_class\"");

    return listTeacher;
  }

  Future<List<TeacherClassModel>> getTeacherClassByStatus(
      int id, String status) async {
    final snapshot = await db
        .collection("teacher_class")
        .where('user_id', isEqualTo: id)
        .where('class_status', isEqualTo: status)
        .get();
    final list =
        snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();

    debugPrint("==========>get db from \"teacher_class\"");
    return list;
  }

  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    final snapshot =
        await db.collection("lessons").where('course_id', isEqualTo: id).get();
    final lessons =
        snapshot.docs.map((e) => LessonModel.fromSnapshot(e)).toList();
    lessons.sort((a, b) => a.lessonId.compareTo(b.lessonId));
    debugPrint("==========>get db from \"lessons\"");
    return lessons;
  }

  Future<List<LessonModel>> getAllLesson() async {
    final snapshot = await db.collection("lessons").get();
    final lessons =
        snapshot.docs.map((e) => LessonModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"lessons\"");
    return lessons;
  }

  Future<ClassModel> getClassById(int id) async{
    final snapshot =
    await db.collection("class").where('class_id', isEqualTo: id).get();
    final result = snapshot.docs
        .map((e) => ClassModel.fromSnapshot(e))
        .single;
    debugPrint("==========>get db from \"class\"");
    return result;
  }

  Future<CourseModel> getCourseById(int id) async {
    final snapshot =
    await db.collection("courses").where("course_id", isEqualTo: id).get();
    final course =
        snapshot.docs
            .map((e) => CourseModel.fromSnapshot(e))
            .single;
    debugPrint("==========>get db from \"courses\"");
    return course;
  }

  Future<List<LessonResultModel>> getLessonResultByClassId(int id) async {
    final snapshot = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: id)
        .get();

    final list =
    snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"lesson_result\"");
    //list.sort((a, b) => a.lessonId.compareTo(b.lessonId));

    return list;
  }

  Future<List<LessonResultModel>> getAllLessonResult() async {
    final snapshot = await db.collection('lesson_result').get();

    final list =
    snapshot.docs.map((e) => LessonResultModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"lesson_result\"");
    return list;
  }

  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(int classId, int lessonId) async {

    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    final list =
    snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"student_lesson\"");
    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<LessonResultModel> getLessonResultByLessonId(int id, int classId) async {
    final snapshot = await db
        .collection("lesson_result")
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: id)
        .get();
    final result =
        snapshot.docs
            .map((e) => LessonResultModel.fromSnapshot(e))
            .single;
    debugPrint("==========>get db from \"lesson_result\"");
    return result;
  }

  Future<List<CourseModel>> getAllCourse() async {
    final snapshot = await db.collection("courses").get();
    final courses =
    snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"courses\"");
    return courses;
  }

  Future<List<StudentClassModel>> getStudentClassInClass(int classId) async {
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .get();
    final list =
    snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"student_class\"");
    return list;
  }

  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(int classId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .get();

    final list =
    snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"student_lesson\"");
    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<List<AnswerModel>> getListAnswer(int id, int classId) async {
    final snapshot = await db
        .collection('answer')
        .where('parent_id', isEqualTo: id)
        .where('class_id', isEqualTo: classId)
        .get();

    final list = snapshot.docs.map((e) => AnswerModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"answer\"");
    return list;
  }

  Future<List<StudentLessonModel>> getAllStudentLessons() async {
    final snapshot = await db.collection('student_lesson').get();

    final list =
    snapshot.docs.map((e) => StudentLessonModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"student_lesson\"");
    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return list;
  }

  Future<LessonModel> getLesson(int courseId, int lessonId) async {
    final snapshot = await db
        .collection('lessons')
        .where('course_id', isEqualTo: courseId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    final lesson = snapshot.docs
        .map((e) => LessonModel.fromSnapshot(e))
        .single;
    debugPrint("==========>get db from \"lessons\"");

    return lesson;
  }

  Future<void> updateTimekeeping(int userId, int lessonId, int classId, int attendId) async{
    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'time_keeping': attendId,
    });
    debugPrint("==========>update db from \"student_lesson\"");
  }

  Future<void> updateTeacherNote(int userId, int lessonId, int classId, String note) async {
    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
    debugPrint("==========>update db from \"student_lesson\"");
  }

  Future<void> updateStudentStatus(int userId, int classId, int point, String type) async {
    await db
        .collection('student_class')
        .doc("student_${userId}_class_$classId")
        .update({
      type: point,
    });
    debugPrint("==========>update db from \"student_class\"");
  }

  Future<void> changeStatusLesson(int lessonId, int classId, String status) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'status': status,
    } );
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> noteForAllStudentInClass(int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'student_note': note,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> updateTeacherInLessonResult(int lessonId, int classId, int studentId) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'teacher_id': studentId,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> noteForSupport(int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'support_note': note,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> noteForAnotherSensei(int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<bool> addStudentLesson(StudentLessonModel model) async {
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
      debugPrint("==========>get and add db from \"student_lesson\"");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkLessonResult(int lessonId, int classId) async {

    final temp = await db
        .collection("lesson_result")
        .doc("lesson_${lessonId}_class_$classId")
        .get();

    debugPrint("==========>get db from \"lesson_result\"");
    if (temp.exists == false) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> addLessonResult(LessonResultModel model) async {
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
      debugPrint("==========>get and add db from \"lesson_result\"");
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfileTeacher(String id, TeacherModel model) async {

    await db.collection('teacher').doc("teacher_user_$id").update({
      'name': model.name,
      'note': model.note,
      'url': model.url,
      'status': model.status,
      'teacher_code': model.teacherCode,
      'phone': model.phone,
      'user_id': model.userId,
    });
    debugPrint("==========>update db from \"teacher\"");
  }

  Future<List<TestModel>> getListTestByCourseId(int courseId) async {
    final snapshot =
    await db.collection("test").where("course_id", isEqualTo: courseId).get();
    debugPrint("==========>get db from \"test\"");
    final test = snapshot.docs.map((e) => TestModel.fromSnapshot(e)).toList();
    test.sort((a, b) => a.id.compareTo(b.id));
    return test;
  }

  Future<List<StudentTestModel>> getListStudentTest(int classId, int testId) async {
    final snapshot =
    await db.collection("student_test").where("class_id", isEqualTo: classId).where("test_id",isEqualTo: testId).get();
    debugPrint("==========>get db from \"student_test\"");
    if(snapshot.docs.isEmpty){
      return [];
    }
    final list = snapshot.docs.map((e) => StudentTestModel.fromSnapshot(e)).toList();
    return list;
  }
  Future<List<StudentTestModel>> getAllStudentTest(int classId) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', isEqualTo: classId)
        .get();

    final list =
    snapshot.docs.map((e) => StudentTestModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"student_test\"");
    return list;
  }

  Future<List<TestResultModel>> getListTestResult(int classId) async {
    final snapshot =
    await db.collection("test_result").where("class_id", isEqualTo: classId).get();
    final list = snapshot.docs.map((e) => TestResultModel.fromSnapshot(e)).toList();
    debugPrint("==========>get db from \"test_result\"");
    list.sort((a, b) => a.testId.compareTo(b.testId));
    return list;
  }

  Future<StudentModel> getStudentInfo(int userId) async {
    final snapshot = await db
        .collection("students")
        .where("user_id", isEqualTo: userId)
        .get();
    debugPrint("==========>get db from \"students\"");
    final studentInfo =
        snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).single;
    return studentInfo;
  }

  Future<UserModel> getUser(String email) async {
    final snapshot =
    await db.collection("users").where("email", isEqualTo: email).get();
    debugPrint("==========>get db from \"users\"");
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return user;
  }

  Future<UserModel> getUserById(int id) async {
    final snapshot =
    await db.collection("users").where("user_id", isEqualTo: id).get();
    debugPrint("==========>get db from \"users\"");
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return user;
  }

  Future<void> saveUser(String email, String role, int uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email, 'roles': role, 'user_id': uid});

    debugPrint("==========>add db from \"users\"");
  }

  Future<List<UserModel>> getAllUser() async {
    final snapshot = await db.collection("users").get();
    debugPrint("==========>get db from \"users\"");
    final lists =
    snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return lists;
  }

  Future<bool> createNewStudent(StudentModel model, UserModel user) async {
    final temp = await db
        .collection("users")
        .where('email', isEqualTo: user.email)
        .get();
    debugPrint("==========>get db from \"users\"");
    if(temp.docs.isEmpty){
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      await FireBaseProvider.instance.saveUser(user.email, user.role, model.userId);
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
      debugPrint("==========>add db for \"students\"");
      return true;
    } else{
      return false;
    }
  }

  Future<bool> createNewTeacher(TeacherModel model, UserModel user) async {
    final temp = await db
        .collection("users")
        .where('email', isEqualTo: user.email)
        .get();
    debugPrint("==========>get db from \"users\"");
    if(temp.docs.isEmpty){
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
      await FireBaseProvider.instance.saveUser(user.email, user.role, model.userId);
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
      debugPrint("==========>add db for \"teacher\"");
      return true;
    } else{
      return false;
    }
  }

  Future<List<ClassModel>> getListClassNotRemove() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    debugPrint("==========>get db from \"class\"");
    final listClass =
    snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).toList();
    listClass.sort((a, b) => a.classId.compareTo(b.classId));
    return listClass;
  }

  Future<List<ClassModel>> getAllClass() async {
    final snapshot = await db
        .collection("class")
        .get();
    debugPrint("==========>get db from \"class\"");
    final listClass =
    snapshot.docs.map((e) => ClassModel.fromSnapshot(e)).toList();
    listClass.sort((a, b) => a.classId.compareTo(b.classId));
    return listClass;
  }

  Future<List<StudentClassModel>> getAllStudentInClass() async {
    final snapshot = await db.collection("student_class").get();
    debugPrint("==========>get db from \"student_class\"");
    final listStudent =
    snapshot.docs.map((e) => StudentClassModel.fromSnapshot(e)).toList();
    return listStudent;
  }

  Future<List<TeacherClassModel>> getAllTeacherInClass() async {
    final snapshot = await db.collection("teacher_class").get();
    debugPrint("==========>get db from \"teacher_class\"");
    final listSensei =
    snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listSensei;
  }

  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(int classId) async {
    final snapshot = await db
        .collection("teacher_class")
        .where('class_id', isEqualTo: classId)
        .get();
    debugPrint("==========>get db from \"teacher_class\"");
    final listTeacher =
    snapshot.docs.map((e) => TeacherClassModel.fromSnapshot(e)).toList();
    return listTeacher;
  }

  Future<List<StudentModel>> getAllStudent() async {
    final snapshot = await db.collection("students").get();
    debugPrint("==========>get db from \"students\"");
    final lists =
    snapshot.docs.map((e) => StudentModel.fromSnapshot(e)).toList();
    return lists;
  }

  Future<List<TeacherModel>> getAllTeacher() async {
    final snapshot = await db.collection("teacher").get();
    debugPrint("==========>get db from \"teacher\"");
    final lists =
    snapshot.docs.map((e) => TeacherModel.fromSnapshot(e)).toList();
    return lists;
  }

  Future<List<TagModel>> getTags() async {
    final snapshot = await db.collection("tags").get();
    debugPrint("==========>get db from \"tags\"");
    final tags = snapshot.docs.map((e) => TagModel.fromSnapshot(e)).toList();
    return tags;
  }

  Future<AdminModel> getAdminById(int id) async {
    final snapshot =
    await db.collection("admin").where("user_id", isEqualTo: id).get();
    debugPrint("==========>get db from \"admin\"");
    final admin = snapshot.docs.map((e) => AdminModel.fromSnapshot(e)).single;
    return admin;
  }

  Future<CourseModel> getCourseByName(String title, String term) async {
    final snapshot = await db
        .collection("courses")
        .where('title', isEqualTo: title)
        .where('term_name', isEqualTo: term)
        .get();
    debugPrint("==========>get db from \"courses\"");
    final course = snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).single;
    return course;
  }

  Future<bool> createNewClass(ClassModel model) async {

    final temp = await db
        .collection("class")
        .where('class_code', isEqualTo: model.classCode)
        .get();
    debugPrint("==========>get db from \"class\"");
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
        'class_status': model.classStatus,
        'class_type' : model.classType
      });
      debugPrint("==========>add db for \"class\"");
      return true;
    } else {
      debugPrint('===============> check var 000 ${model.classCode}');
      return false;
    }
  }

  Future<bool> addStudentToClass(StudentClassModel model) async {
    final temp = await db
        .collection("student_class")
        .doc("student_${model.userId}_class_${model.classId}")
        .get();

    debugPrint("==========>get db from \"student_class\"");

    if (!temp.exists) {
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
      debugPrint("==========>add db for \"student_class\"");
      return true;
    } else {
      await db
          .collection("student_class")
          .doc("student_${model.userId}_class_${model.classId}").update({
        'class_status': "InProgress"
      });
      debugPrint("==========>update db for \"student_class\"");
      return false;
    }
  }

  Future<bool> addTeacherToClass(TeacherClassModel model) async {
    final temp = await db
        .collection("teacher_class")
        .doc("teacher_${model.userId}_class_${model.classId}")
        .get();
    debugPrint("==========>get db from \"teacher_class\"");
    if (!temp.exists) {
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
      debugPrint("==========>add db for \"teacher_class\"");
      return true;
    } else {
      return false;
    }
  }
}
