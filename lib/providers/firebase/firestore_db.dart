import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/admin_model.dart';
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
      if(response.json is String){
        return [];
      }
      return (response.json as List).map((e) => QuestionModel.fromMap(e)).toList();
    } else {
      debugPrint("=======>error ${response.statusCode}");
      return [];
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherByTeacherCode(String teacherCode) async {
    final snapshot = await db
        .collection("teacher")
        .where("teacher_code", isEqualTo: teacherCode)
        .get();

    debugPrint("==========>get db from \"teacher\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherById(int id) async {
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();


    debugPrint("==========>get db from \"teacher\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherClassById(
      String string, int id) async {
    final snapshot =
        await db.collection("teacher_class").where(string, isEqualTo: id).get();


    debugPrint("==========>get db from \"teacher_class\" : ${snapshot.docs.length}");

    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByCourseId(int id) async {
    final snapshot =
        await db.collection("lessons").where('course_id', isEqualTo: id).get();
    debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTeacherByListId(List<int> teacherIds) async {
    final snapshot =
      await db
        .collection("teacher")
        .where("user_id", whereIn: teacherIds)
        .get();
    debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getClassById(int id) async{
    final snapshot =
    await db.collection("class").where('class_id', isEqualTo: id).get();
    debugPrint("==========>get db from \"class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseById(int id) async {
    final snapshot =
    await db.collection("courses").where("course_id", isEqualTo: id).get();
    debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseByListId(List<int> ids) async {
    final snapshot =
    await db.collection("courses").where("course_id", whereIn: ids).get();
    debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultByClassId(int id) async {
    final snapshot = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: id)
        .get();

    debugPrint("==========>get db from \"lesson_result\" : ${snapshot.docs.length}");

    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonInLesson(int classId, int lessonId) async {

    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();
    debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultByLessonId(int id, int classId) async {
    final snapshot = await db
        .collection("lesson_result")
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: id)
        .get();

    debugPrint("==========>get db from \"lesson_result\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllCourse() async {
    final snapshot = await db.collection("courses").get();
    debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassInClass(int classId) async {
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassInClassNotRemove(int classId) async {
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonsInListClassId(List<int> classId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', whereIn: classId)
        .get();
    debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");
    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return snapshot;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonsInClass(int classId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .get();
    debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassAvailable(int classId, List<int> studentIds) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('student_id', whereIn: studentIds)
        .get();
    debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListAnswer(int id, int classId) async {
    final snapshot = await db
        .collection('answer')
        .where('parent_id', isEqualTo: id)
        .where('class_id', isEqualTo: classId)
        .get();


    debugPrint("==========>get db from \"answer\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLesson(int courseId, int lessonId) async {
    final snapshot = await db
        .collection('lessons')
        .where('course_id', isEqualTo: courseId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();
    debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    return snapshot;
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


  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentLessonByDocs(String docs) async {
    final temp = await db
        .collection("student_lesson")
        .doc(docs)
        .get();
    return temp;
  }

  Future<void> addStudentLesson(StudentLessonModel model) async {

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

  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkLessonResult(int lessonId, int classId) async {

    final temp = await db
        .collection("lesson_result")
        .doc("lesson_${lessonId}_class_$classId")
        .get();
    debugPrint("==========>get db from \"lesson_result\" : 1");

    return temp;
  }

  Future<void> addLessonResult(LessonResultModel model) async {
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

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestByCourseId(int courseId) async {
    final snapshot =
    await db.collection("test").where("course_id", isEqualTo: courseId).get();
    debugPrint("==========>get db from \"test\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentTest(int classId) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', isEqualTo: classId)
        .get();

    debugPrint("==========>get db from \"student_test\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestResult(int classId) async {
    final snapshot =
    await db.collection("test_result").where("class_id", isEqualTo: classId).get();
    debugPrint("==========>get db from \"test_result\": ${snapshot.docs.length}");

    return snapshot;
  }


  // Future<UserModel> getUser(String email) async {
  //   final snapshot =
  //   await db.collection("users").where("email", isEqualTo: email).get();
  //   debugPrint("==========>get db from \"users\": ${snapshot.docs.length}");
  //   final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
  //   return user;
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserById(int id) async {
    final snapshot =
    await db.collection("users").where("user_id", isEqualTo: id).get();
    debugPrint("==========>get db from \"users\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<void> saveUser(String email, String role, int uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email, 'roles': role, 'user_id': uid});

    debugPrint("==========>add db from \"users\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUser() async {
    final snapshot = await db.collection("users").get();
    debugPrint("==========>get db from \"users\": ${snapshot.docs.length}");

    return snapshot;
  }

  Future<void> createNewStudent(StudentModel model, UserModel user) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
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

  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String email) async {
    final snapshot = await db
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    debugPrint("==========>get db from \"users\"");

    return snapshot;
  }

  Future<void> createNewTeacher(TeacherModel model, UserModel user) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    await FirebaseAuth.instance.currentUser!.updateEmail(user.email);

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
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassNotRemove() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    debugPrint("==========>get db from \"class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassAvailableForTeacher() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", whereIn: ["InProgress", "Completed","Preparing"])
        .get();
    debugPrint("==========>get db from \"class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllClassAvailable() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    debugPrint("==========>get db from \"class\": ${snapshot.docs.length}");
    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClass() async {
    final snapshot = await db.collection("teacher_class").get();
    debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClassByClassId(int classId) async {
    final snapshot = await db
        .collection("teacher_class")
        .where('class_id', isEqualTo: classId)
        .get();
    debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudent() async {
    final snapshot = await db.collection("students").get();
    debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get10StudentFirst() async {
    final snapshot = await db.collection("students").orderBy('user_id', descending: true)
        .limit(10)
        .get();
    debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get10Student(int lastId) async {
    final snapshot = await db.collection("students").orderBy('user_id', descending: true)
        .startAfter([lastId])
        .limit(10)
        .get();
    debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<AggregateQuerySnapshot> getCount(String tableName) async {
    final count = await db.collection(tableName).count().get();
    debugPrint("==========>get count db from \"$tableName\"");
    return count;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacher() async {
    final snapshot = await db.collection("teacher").get();
    debugPrint("==========>get db from \"teacher\": ${snapshot.docs.length}");
    return snapshot;
  }

  // Future<List<TagModel>> getTags() async {
  //   final snapshot = await db.collection("tags").get();
  //   debugPrint("==========>get db from \"tags\": ${snapshot.docs.length}");
  //   final tags = snapshot.docs.map((e) => TagModel.fromSnapshot(e)).toList();
  //   return tags;
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getAdminById(int id) async {
    final snapshot =
    await db.collection("admin").where("user_id", isEqualTo: id).get();
    debugPrint("==========>get db from \"admin\": ${snapshot.docs.length}");

    return snapshot;
  }

  Future<CourseModel> getCourseByName(String title, String term) async {
    final snapshot = await db
        .collection("courses")
        .where('title', isEqualTo: title)
        .where('term_name', isEqualTo: term)
        .get();
    debugPrint("==========>get db from \"courses\": ${snapshot.docs.length}");
    final course = snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).single;
    return course;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassByClassCode(String classCode)async{
    final temp = await db
        .collection("class")
        .where('class_code', isEqualTo: classCode)
        .get();
    debugPrint("==========>get db from \"class\"");
    return temp;
  }

  Future<void> createNewClass(ClassModel model) async {
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
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentClassByDoc(String doc)async{
    final temp = await db
        .collection("student_class")
          .doc(doc)
        .get();

    debugPrint("==========>get db from \"student_class\"");
    return temp;
  }

  Future<void> addStudentToClass(StudentClassModel model) async {
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
  }
  Future<void> updateStudentToClass(StudentClassModel model) async {
    await db
        .collection("student_class")
        .doc("student_${model.userId}_class_${model.classId}").update({
      'class_status': "InProgress"
    });
    debugPrint("==========>update db for \"student_class\"");
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

  Future<void> changeClassStatus(ClassModel classModel, String newStatus, ManageGeneralCubit cubit, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('class')
        .doc('class_${classModel.classId}_course_${classModel.courseId}')
        .update({
      'class_status': newStatus
    }).whenComplete(() {
      debugPrint("==========>update db for \"class\"");
      cubit.loadAfterChangeClassStatus();
      Navigator.pop(context);
    });
  }

  Future<void> updateClassInfo(ClassModel model) async {
    FirebaseFirestore.instance
        .collection('class')
        .doc('class_${model.classId}_course_${model.courseId}')
        .update({
      'description': model.description,
      'end_time': model.endTime,
      'start_time': model.startTime,
      'note': model.note,
      'class_code': model.classCode,
      'class_status': model.classStatus,
      'class_type' : model.classType
    });
    debugPrint("==========>update db for \"class\"");
  }



  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentInFoInClass(List<int> listStdId) async {
    final snapshot =
    await db.collection("students").where("user_id", whereIn: listStdId).get();
    debugPrint("==========>get db from \"students\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByLessonId(List<int> ids) async {
    final snapshot =
    await db.collection("lessons").where("lesson_id", whereIn: ids).get();
    debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentTestByIds(List<int> ids) async {
    final snapshot =
    await db.collection("student_test").where("test_id", whereIn: ids).get();
    debugPrint("==========>get db from \"student_test\" : ${snapshot.docs.length}");
    return snapshot;
  }
}
