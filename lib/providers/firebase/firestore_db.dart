import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/response_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/api/api_provider.dart';
import 'package:intl/intl.dart';

class FireStoreDb {
  FireStoreDb._privateConstructor();

  static final FireStoreDb instance = FireStoreDb._privateConstructor();
  final db = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestionByUrl(String url) async {
    APIResponseModel response = await APIProvider.instance.get(url);

    if (response.statusCode == 200) {
      if (response.json is String) {
        return [];
      }
      return (response.json as List)
          .map((e) => QuestionModel.fromMap(e))
          .toList();
    } else {
      debugPrint("=======>error ${response.statusCode}");
      return [];
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherByTeacherCode(
      String teacherCode) async {
    final snapshot = await db
        .collection("teacher")
        .where("teacher_code", isEqualTo: teacherCode)
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherByTeacherCode $teacherCode ${snapshot.size}");

    // debugPrint("==========>get db from \"teacher\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherById(int id) async {
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherById $id ${snapshot.size}");

    // debugPrint("==========>get db from \"teacher\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherClassById(
      String string, int id) async {
    final snapshot = await db
        .collection("teacher_class")
        .where(string, isEqualTo: id)
        .where("class_status", isNotEqualTo: "Remove")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherClassById $string $id ${snapshot.size}");

    // debugPrint("==========>get db from \"teacher_class\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByCourseId(
      int id) async {
    final snapshot =
        await db.collection("lessons").where('course_id', isEqualTo: id).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByCourseId $id ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTeacherByListId(
      List<int> teacherIds) async {
    final snapshot = await db
        .collection("teacher")
        .where("user_id", whereIn: teacherIds)
        .get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTeacherByListId $teacherIds ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassById(int id) async {
    final snapshot =
        await db.collection("class").where('class_id', isEqualTo: id).get();
    // debugPrint("==========>get db from \"class\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassById $id ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllCourseEnable() async {
    final snapshot =
        await db.collection("courses").where('enable', isEqualTo: true).get();
    // debugPrint("==========>get db from \"class\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllCourseEnable ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseById(int id) async {
    final snapshot =
        await db.collection("courses").where("course_id", isEqualTo: id).get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseById $id ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseByListId(
      List<int> ids) async {
    final snapshot =
        await db.collection("courses").where("course_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByListId $ids ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsResultsByListClassIds(
      List<int> ids) async {
    final snapshot = await db
        .collection("lesson_result")
        .where("class_id", whereIn: ids)
        .get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsResultsByListClassIds $ids ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultByClassId(
      int id) async {
    final snapshot = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: id)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonResultByClassId $id ${snapshot.size}");

    // debugPrint("==========>get db from \"lesson_result\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonInLesson(
      int classId, int lessonId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonInLesson $classId $lessonId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentLessonByStdId(
      int studentId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('student_id', isEqualTo: studentId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentLessonByStdId $studentId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentTestInLesson(
      int classId, int testId) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', isEqualTo: classId)
        .where('test_id', isEqualTo: testId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentTestInLesson $classId $testId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultByLessonId(
      int id, int classId) async {
    final snapshot = await db
        .collection("lesson_result")
        .where('class_id', isEqualTo: classId)
        .where('lesson_id', isEqualTo: id)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonResultByLessonId $id $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"lesson_result\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllCourse() async {
    final snapshot = await db.collection("courses").get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllCourse ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassInClass(
      int classId) async {
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .where("class_status", isNotEqualTo: "Remove")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassInClass $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassByStdId(
      int studentId) async {
    final snapshot = await db
        .collection("student_class")
        .where("user_id", isEqualTo: studentId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassByStdId $studentId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentClassValid(
      int classId) async {
    final snapshot = await db
        .collection("student_class")
        .where('class_id', isEqualTo: classId)
        .where("class_status", whereNotIn: [
      "Remove",
      "Dropped",
      "Deposit",
      "Retained",
      "Moved",
      "Viewer"
    ]).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassValid $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonsInListClassId(
      List<int> classIds) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', whereIn: classIds)
        .get();
    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonsInListClassId $classIds ${snapshot.size}");

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentClassByListIds(
      List<int> classIds) async {
    final snapshot = await db
        .collection('student_class')
        .where('class_id', whereIn: classIds)
        .get();
    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentClassByListIds $classIds ${snapshot.size}");

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentLessonsInClass(
      int classId) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .get();
    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonsInClass $classId ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentLesson(
      int classId, List<int> studentIds) async {
    final snapshot = await db
        .collection('student_lesson')
        .where('class_id', isEqualTo: classId)
        .where('student_id', whereIn: studentIds)
        .get();
    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassAvailable $classId $studentIds ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListAnswer(
      int id, int classId) async {
    final snapshot = await db
        .collection('answer')
        .where('parent_id', isEqualTo: id)
        .where('class_id', isEqualTo: classId)
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListAnswer $id $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"answer\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLesson(
      int courseId, int lessonId) async {
    final snapshot = await db
        .collection('lessons')
        .where('course_id', isEqualTo: courseId)
        .where('lesson_id', isEqualTo: lessonId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLesson $courseId $lessonId ${snapshot.size}");

    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<void> updateFeedBackStatus(
      int classId, int date, String newStatus) async {
    await db
        .collection('feedbacks')
        .doc("feedback_classId_${classId}_$date")
        .update({
      'status': newStatus,
    });
    debugPrint("==========>update db for \"feedbacks\"");
  }

  Future<void> updateFeedBackNote(
      int classId, int date, List<dynamic> listNote) async {
    await db
        .collection('feedbacks')
        .doc("feedback_classId_${classId}_$date")
        .update({
      'note': listNote,
    });
    debugPrint("==========>update db for \"feedbacks\"");
  }

  Future<void> updateTimekeeping(
      int userId, int lessonId, int classId, int attendId) async {
    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'time_keeping': attendId,
    });
    debugPrint("==========>update db from \"student_lesson\"");
  }

  Future<void> updateTeacherNote(
      int userId, int lessonId, int classId, String note) async {
    await db
        .collection('student_lesson')
        .doc("student_${userId}_lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
    debugPrint(
        "==========>update db in \"student_lesson\" for student_${userId}_lesson_${lessonId}_class_$classId");
  }

  Future<void> updateStudentStatus(
      int userId, int classId, int point, String type) async {
    await db
        .collection('student_class')
        .doc("student_${userId}_class_$classId")
        .update({
      type: point,
    });
    debugPrint("==========>update db from \"student_class\"");
  }

  Future<void> updateCourseState(CourseModel model, bool state) async {
    await db.collection('courses').doc("course_${model.courseId}").update({
      "enable": state,
    });
    debugPrint("==========>update db from \"student_class\"");
  }

  Future<void> changeStatusLesson(
      int lessonId, int classId, String status) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'status': status,
      'date': DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> noteForAllStudentInClass(
      int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'student_note': note,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> updateTeacherInLessonResult(
      int lessonId, int classId, int studentId) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'teacher_id': studentId,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<void> updateNoteInLessonResult(
      int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'support_note_for_teacher': note,
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

  Future<void> noteForAnotherSensei(
      int lessonId, int classId, String note) async {
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'teacher_note': note,
    });
    debugPrint("==========>update db from \"lesson_result\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCourseByDocs(
      String docs) async {
    final temp = await db.collection("courses").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByDocs $docs ${temp.exists}");

    return temp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getLessonByDocs(
      String docs) async {
    final temp = await db.collection("lessons").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonByDocs $docs ${temp.exists}");

    return temp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTestByDocs(
      String docs) async {
    final temp = await db.collection("test").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestByDocs $docs ${temp.exists}");

    return temp;
  }

  Future<void> deleteLessonByDocs(String docs) async {
    await db.collection("lessons").doc(docs).delete();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> deleteLessonByDocs $docs");
  }


  Future<void> deleteTestByDocs(String docs) async {
    await db.collection("test").doc(docs).delete();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> deleteTestByDocs $docs");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentLessonByDocs(
      String docs) async {
    final temp = await db.collection("student_lesson").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentLessonByDocs $docs ${temp.exists}");

    return temp;
  }

  Future<void> addStudentLesson(StudentLessonModel model) async {
    await db
        .collection("student_lesson")
        .doc(
            "student_${model.studentId}_lesson_${model.lessonId}_class_${model.classId}")
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

  Future<void> addCourse(CourseModel model) async {
    await db.collection("courses").doc("course_${model.courseId}").set({
      'code': model.code,
      'course_id': model.courseId,
      'description': model.description,
      'enable': true,
      'lesson_count': model.lessonCount,
      'level': model.level,
      'term_id': model.termId,
      'term_name': model.termName,
      'title': model.title,
      'token': model.token,
      'type': model.type,
      'dataversion': model.version,
      'prefix': model.prefix,
      "suffix":model.suffix
    });
    debugPrint("==========> add db for \"courses\"");
  }

  Future<void> addLesson(LessonModel model) async {
    await db
        .collection("lessons")
        .doc("lesson_${model.lessonId}_course_${model.courseId}")
        .set({
      "alphabet": model.alphabet,
      "btvn": model.btvn,
      "content": model.content,
      "course_id": model.courseId,
      "description": model.description,
      "flashcard": model.flashcard,
      "grammar": model.grammar,
      "kanji": model.kanji,
      "lesson_id": model.lessonId,
      "listening": model.listening,
      "order": model.order,
      "title": model.title,
      "vocabulary": model.vocabulary
    });
    debugPrint("==========> add db for \"lessons\"");
  }

  Future<void> addTest(TestModel model) async {
    await db
        .collection("test")
        .doc("test_${model.id}_course_${model.courseId}")
        .set({
      "course_id": model.courseId,
      "description": model.description,
      "difficulty": model.difficulty,
      "id": model.id,
      "title": model.title
    });
    debugPrint("==========> add db for \"test\"");
  }

  Future<void> updateTestInfo(TestModel model) async {
    await db
        .collection("test")
        .doc("test_${model.id}_course_${model.courseId}")
        .update({
      "course_id": model.courseId,
      "description": model.description,
      "difficulty": model.difficulty,
      "id": model.id,
      "title": model.title
    });
    debugPrint("==========> update db from \"lessons\"");
  }

  Future<void> updateCourseInfo(CourseModel model) async {
    await db.collection("courses").doc("course_${model.courseId}").update({
      'code': model.code,
      'course_id': model.courseId,
      'description': model.description,
      'lesson_count': model.lessonCount,
      'level': model.level,
      'term_id': model.termId,
      'term_name': model.termName,
      'title': model.title,
      'token': model.token,
      'type': model.type,
      'dataversion': model.version,
      'prefix': model.prefix,
      "suffix":model.suffix
    });
    debugPrint("==========> update db from \"courses\"");
  }

  Future<void> updateLessonInfo(LessonModel model) async {
    await db
        .collection("lessons")
        .doc("lesson_${model.lessonId}_course_${model.courseId}")
        .update({
      "alphabet": model.alphabet,
      "btvn": model.btvn,
      "content": model.content,
      "course_id": model.courseId,
      "description": model.description,
      "flashcard": model.flashcard,
      "grammar": model.grammar,
      "kanji": model.kanji,
      "lesson_id": model.lessonId,
      "listening": model.listening,
      "order": model.order,
      "title": model.title,
      "vocabulary": model.vocabulary
    });
    debugPrint("==========> update db from \"lessons\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkLessonResult(
      int lessonId, int classId) async {
    final temp = await db
        .collection("lesson_result")
        .doc("lesson_${lessonId}_class_$classId")
        .get();
    // debugPrint("==========>get db from \"lesson_result\" : 1");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> checkLessonResult $lessonId $classId ${temp.exists}");

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


  Future<void> updateProfileStudent(String id, StudentModel model) async {
    await db.collection('students').doc("student_user_$id").update({
      'name': model.name,
      'note': model.note,
      'url': model.url,
      'status': model.status,
      'student_code': model.studentCode,
      'phone': model.phone,
      'user_id': model.userId,
      'in_jp': model.inJapan,

    });
    debugPrint("==========>update db from \"teacher\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestByCourseId(
      int courseId) async {
    final snapshot = await db
        .collection("test")
        .where("course_id", isEqualTo: courseId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTestByCourseId $courseId ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentTest(
      int classId) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentTest $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"student_test\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentTestByStdId(
      int studentId) async {
    final snapshot = await db
        .collection('student_test')
        .where('student_id', isEqualTo: studentId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentTestByStdId $studentId ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestResult(
      int classId) async {
    final snapshot = await db
        .collection("test_result")
        .where("class_id", isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTestResult $classId ${snapshot.size}");

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
    // debugPrint("==========>get db from \"users\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserById $id ${snapshot.size}");

    return snapshot;
  }

  Future<void> saveUser(String email, String role, int uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email.toLowerCase(), 'roles': role, 'user_id': uid});

    debugPrint("==========>add db from \"users\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUser() async {
    final snapshot = await db.collection("users").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllUser ${snapshot.size}");

    return snapshot;
  }

  Future<void> createNewStudent(StudentModel model, UserModel user) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
    await db.collection('students').doc("student_user_${user.id}").set({
      'in_jp': model.inJapan,
      'name': model.name,
      'note': model.note,
      'phone': model.phone,
      'student_code': model.studentCode,
      'url': model.url,
      'user_id': model.userId,
      'status': model.studentCode
    });
    debugPrint("==========>add db for \"students\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    final snapshot =
        await db.collection("users").where('email', isEqualTo: email).get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserByEmail $email ${snapshot.size}");

    return snapshot;
  }

  Future<void> createNewTeacher(TeacherModel model, UserModel user) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    await FirebaseAuth.instance.currentUser!.updateEmail(user.email);

    await db.collection('teacher').doc("teacher_user_${user.id}").set({
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

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassNotRemove ${snapshot.size}");

    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getListClassForAdmin() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", whereNotIn: ["Remove", "Completed", "Cancel"])
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassNotRemove ${snapshot.size}");

    return snapshot;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getListClassAvailableForTeacher(
      List<int> listIds) async {
    final snapshot = await db
        .collection("class")
        .where("class_id", whereIn: listIds)
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    // debugPrint("==========>get db from \"class\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassAvailableForTeacher ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClass() async {
    final snapshot = await db.collection("teacher_class").get();
    // debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacherInClass ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClassByClassId(
      int classId) async {
    final snapshot = await db
        .collection("teacher_class")
        .where('class_id', isEqualTo: classId)
        .where('class_status',  isEqualTo: "InProgress")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacherInClassByClassId $classId ${snapshot.size}");

    // debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllLessonNotBTVN() async {
    final snapshot =
        await db.collection("lessons").where('btvn', isEqualTo: 0).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllLessonNotBTVN ${snapshot.size}");

    // debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListFeedBack(String status) async {
    final snapshot =
    await db.collection("feedbacks").where('status', isEqualTo: status).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListFeedBack ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudent() async {
    final snapshot = await db.collection("students").get();
    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudent ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get10StudentFirst() async {
    final snapshot = await db
        .collection("students")
        .orderBy('user_id', descending: true)
        .limit(10)
        .get();
    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> get10StudentFirst ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentById(int studentId) async {
    final snapshot = await db
        .collection("students")
        .where('user_id', isEqualTo: studentId)
        .get();
    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentById ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get10Student(int lastId) async {
    final snapshot = await db
        .collection("students")
        .orderBy('user_id', descending: true)
        .startAfter([lastId])
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> get10Student $lastId ${snapshot.size}");

    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<AggregateQuerySnapshot> getCount(String tableName) async {
    final count = await db.collection(tableName).count().get();
    debugPrint("==========>get count db from \"$tableName\"");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCount $tableName");

    return count;
  }

  Future<AggregateQuerySnapshot> getCountWithCondition(
      String tableName, String field, dynamic condition) async {
    final count = await db
        .collection(tableName)
        .where(field, isEqualTo: condition)
        .count()
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========>get count db from \"$tableName\" with $field equal ${condition.toString()}");

    return count;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacher() async {
    final snapshot = await db.collection("teacher").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacher ${snapshot.size}");

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

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAdminById $id ${snapshot.size}");

    return snapshot;
  }

  Future<CourseModel> getCourseByName(String title, String term) async {
    final snapshot = await db
        .collection("courses")
        .where('title', isEqualTo: title)
        .where('term_name', isEqualTo: term)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByName $title $term ${snapshot.size}");

    // debugPrint("==========>get db from \"courses\": ${snapshot.docs.length}");
    final course = snapshot.docs.map((e) => CourseModel.fromSnapshot(e)).single;
    return course;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassByClassCode(
      String classCode) async {
    final temp = await db
        .collection("class")
        .where('class_code', isEqualTo: classCode)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassByClassCode $classCode ${temp.size}");

    // debugPrint("==========>get db from \"class\"");
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
      'class_type': model.classType
    });
    debugPrint("==========>add db for \"class\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentClassByDoc(
      String doc) async {
    final temp = await db.collection("student_class").doc(doc).get();

    // debugPrint("==========>get db from \"student_class\"");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassByDoc $doc ${temp.exists}");

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
        .doc("student_${model.userId}_class_${model.classId}")
        .update({'class_status': "InProgress"});
    debugPrint("==========>update db for \"student_class\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTeacherClassByDocs(
      String docs) async {
    final temp = await db.collection("teacher_class").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherClassByDocs $docs ${temp.exists}");

    return temp;
  }

  Future<void> addTeacherToClass(TeacherClassModel model) async {
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
  }

  Future<void> updateTeacherInClass(TeacherClassModel model) async {
    await db
        .collection("teacher_class")
        .doc("teacher_${model.userId}_class_${model.classId}")
        .update({
      'class_status': "InProgress",
    });
    debugPrint("==========>update db for \"teacher_class\"");
  }

  Future<void> changeClassStatus(ClassModel classModel, String newStatus,
      ManageGeneralCubit cubit, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('class')
        .doc('class_${classModel.classId}_course_${classModel.courseId}')
        .update({'class_status': newStatus}).whenComplete(() {
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
      'class_type': model.classType
    });
    debugPrint("==========>update db for \"class\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentInFoInClass(
      List<int> listStdId) async {
    final snapshot = await db
        .collection("students")
        .where("user_id", whereIn: listStdId)
        .get();
    // debugPrint("==========>get db from \"students\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentInFoInClass $listStdId ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByLessonId(
      List<int> ids) async {
    final snapshot =
        await db.collection("lessons").where("lesson_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByLessonId $ids ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByListCourseId(
      List<int> ids) async {
    final snapshot =
        await db.collection("lessons").where("course_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByListCourseId $ids ${snapshot.size}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentTestByIds(
      List<int> ids) async {
    final snapshot = await db
        .collection("student_test")
        .where("test_id", whereIn: ids)
        .get();
    // debugPrint("==========>get db from \"student_test\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentTestByIds $ids ${snapshot.size}");

    return snapshot;
  }
}
