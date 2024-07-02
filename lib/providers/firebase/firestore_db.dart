import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/banner_model.dart';
import 'package:internal_sakumi/model/banner_option.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/course_suggest_model.dart';
import 'package:internal_sakumi/model/cs_option.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/model/group_tag_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/manage_tag_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/response_model.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/teacher_survey_answer_model.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/model/voucher_model.dart';
import 'package:internal_sakumi/providers/api/api_provider.dart';
import 'package:intl/intl.dart';
import 'package:timezone/browser.dart';

import '../../services/custom_firebase_firestore.dart';

class FireStoreDb {
  FireStoreDb._privateConstructor();

  static final FireStoreDb instance = FireStoreDb._privateConstructor();
  final db = CustomFirebaseFireStore.database;

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

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherById(int id) async {
    final snapshot =
        await db.collection("teacher").where("user_id", isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"teacher\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherClassById(
      int id) async {
    final snapshot = await db
        .collection("teacher_class")
        .where("user_id", isEqualTo: id)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherClassById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"teacher_class\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkTeacherClass(
      int userId, int classId) async {
    final snapshot = await db
        .collection("teacher_class")
        .where("user_id", isEqualTo: userId)
        .where("class_id", isEqualTo: classId)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByCourseId(
      int id) async {
    final snapshot =
        await db.collection("lessons").where('course_id', isEqualTo: id).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByCourseId $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTeacherByListId $teacherIds ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassById(int id) async {
    final snapshot =
        await db.collection("class").where('class_id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReportByTeacherId(
      int id) async {
    final snapshot = await db
        .collection("reports")
        .where('teacher_id', isEqualTo: id)
        .where('type', isEqualTo: 'teacher')
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReportByClassId(int id) async {
    final snapshot = await db
        .collection("reports")
        .where('class_id', isEqualTo: id)
        .where('type', isEqualTo: 'class')
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherCyclicSchedule(
      int teacherId) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "cyclic")
        .where('teacher_id', isEqualTo: teacherId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getScheduleByClassId(
      int classId) async {
    final snapshot = await db
        .collection("schedule")
        .where('class_id', isEqualTo: classId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherCyclicScheduleInClass(
      int teacherId, int classId) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "cyclic")
        .where('teacher_id', isEqualTo: teacherId)
        .where('class_id', isEqualTo: classId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassCyclicSchedule(
      int classId) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "cyclic")
        .where('class_id', isEqualTo: classId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSingleScheduleInClass(
      int classId, int teacherId, int startDate, int endDate) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "single")
        .where('class_id', isEqualTo: classId)
        .where('teacher_id', isEqualTo: teacherId)
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThanOrEqualTo: endDate)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClassSingleSchedule(
      int classId, int startDate, int endDate) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "single")
        .where('class_id', isEqualTo: classId)
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThanOrEqualTo: endDate)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSingleSchedule(
      int teacherId, int startDate, int endDate) async {
    final snapshot = await db
        .collection("schedule")
        .where("type", isEqualTo: "single")
        .where('teacher_id', isEqualTo: teacherId)
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThanOrEqualTo: endDate)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonById(int id) async {
    final snapshot =
        await db.collection("lessons").where('lesson_id', isEqualTo: id).get();
    // debugPrint("==========>get db from \"class\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllCourseEnable() async {
    final snapshot =
        await db.collection("courses").where('enable', isEqualTo: true).get();
    // debugPrint("==========>get db from \"class\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllCourseEnable ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseById(int id) async {
    final snapshot =
        await db.collection("courses").where("course_id", isEqualTo: id).get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCourseByListId(
      List<int> ids) async {
    final snapshot =
        await db.collection("courses").where("course_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"courses\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByListId $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsResultsByListClassIds $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultByClassId(
      int id) async {
    final snapshot = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: id)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonResultByClassId $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"lesson_result\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      getLessonResultWithDateAndTeacherId(
          int start, int end, int teacherId) async {
    final snapshot = await db
        .collection('lesson_result')
        .orderBy('date_time', descending: true)
        .where(Filter.and(
            Filter("date_time", isGreaterThanOrEqualTo: start),
            Filter("date_time", isLessThanOrEqualTo: end),
            Filter("teacher_id", isEqualTo: teacherId)))
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultWithDateAndId(
      int start, int end, int teacherId, int classId) async {
    final snapshot = await db
        .collection('lesson_result')
        .orderBy('date_time', descending: true)
        .where(Filter.and(
            Filter("date_time", isGreaterThanOrEqualTo: start),
            Filter("date_time", isLessThanOrEqualTo: end),
            Filter("teacher_id", isEqualTo: teacherId),
            Filter("class_id", isEqualTo: classId)))
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonResultWithDateAndClassId(
      int start, int end, int classId) async {
    final snapshot = await db
        .collection('lesson_result')
        .orderBy('date_time', descending: true)
        .where(Filter.and(
            Filter("date_time", isGreaterThanOrEqualTo: start),
            Filter("date_time", isLessThanOrEqualTo: end),
            Filter("class_id", isEqualTo: classId)))
        .get();

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonInLesson $classId $lessonId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentSurvey() async {
    final snapshot = await db
        .collection('survey')
        .where('enable', isEqualTo: true)
        .where('type', isEqualTo: 'student')
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentSurvey ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSurvey() async {
    final snapshot = await db
        .collection('teacher_survey')
        .where('status', isNotEqualTo: 'delete')
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherSurvey ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSurveyByTeacherId(int teacherId) async {
    final snapshot = await db
        .collection('teacher_survey')
        .where('status', isEqualTo: 'waiting')
        .where('teacher_id', isEqualTo: teacherId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherSurvey ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSurveyByTeacherAndSurveyId(int teacherId, int surveyId) async {
    final snapshot = await db
        .collection('teacher_survey')
        .where('status', isEqualTo: 'waiting')
        .where('teacher_id', isEqualTo: teacherId)
        .where('survey_id', isEqualTo: surveyId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherSurvey ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherSurveyAnswerByTeacherAndSurveyId(int teacherId, int surveyId, int date) async {
    final snapshot = await db
        .collection('teacher_survey_answer')
        .where('date_assign', isEqualTo: date)
        .where('teacher_id', isEqualTo: teacherId)
        .where('survey_id', isEqualTo: surveyId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherSurveyAnswer ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherSurvey() async {
    final snapshot = await db
        .collection('survey')
        .where('enable', isEqualTo: true)
        .where('type', isEqualTo: 'teacher')
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacherSurvey ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentLessonByStdId $studentId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentTestInLesson $classId $testId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonResultByLessonId $id $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllCourse() async {
    final snapshot = await db.collection("courses").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllCourse ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassInClass $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"student_class\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentClass() async {
    final snapshot = await db.collection("student_class").where("class_status",
        whereNotIn: [
          'Remove',
          'Retained',
          'Dropped',
          'Cancel',
          'Deposit'
        ]).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentClass ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassByStdId $studentId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassValid $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonsInListClassId $classIds ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    //list.sort((a, b) => a.studentId.compareTo(b.studentId));

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentTestsInListClassId(
      List<int> classIds) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', whereIn: classIds)
        .get();
    // debugPrint("==========>get db from \"student_lesson\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentTestsInListClassId $classIds ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentClassByListIds $classIds ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentLessonsInClass $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassAvailable $classId $studentIds ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListAnswer $id $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"answer\" : ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListAnswerCustom(
      int id, int classId, int customLessonId) async {
    final snapshot = await db
        .collection('answer_v2')
        .where('parent_id', isEqualTo: id)
        .where('class_id', isEqualTo: classId)
        .where('custom_lesson_id', isEqualTo: customLessonId)
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListAnswerCustom answer_v2 $id $classId $customLessonId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLesson $courseId $lessonId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
    debugPrint("==========>update db from \"course\"");
  }

  Future<void> changeStatusLesson(
      int lessonId, int classId, String status) async {
    TZDateTime nowVN = TZDateTime.now(getLocation('Asia/Ho_Chi_Minh'));
    await db
        .collection('lesson_result')
        .doc("lesson_${lessonId}_class_$classId")
        .update({
      'status': status,
      'date': DateFormat('dd/MM/yyyy HH:mm:ss').format(nowVN)
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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByDocs $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getLessonByDocs(
      String docs) async {
    final temp = await db.collection("lessons").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonByDocs $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTestByDocs(
      String docs) async {
    final temp = await db.collection("test").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestByDocs $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<void> deleteLessonByDocs(String docs) async {
    await db.collection("lessons").doc(docs).update({"enable": false});

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> deleteLessonByDocs $docs");
  }

  Future<void> deleteTestByDocs(String docs) async {
    await db.collection("test").doc(docs).update({"enable": false});

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> deleteTestByDocs $docs");
  }

  Future<void> deleteSurveyByDocs(String docs) async {
    await db.collection("survey").doc(docs).update({"enable": false});

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> deleteTestByDocs $docs");
  }

  Future<void> activeSurveyByDocs(String docs) async {
    await db.collection("survey").doc(docs).update({"active": true});

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> activeTestByDocs $docs");
  }

  Future<void> saveSurveyByDocs(String docs, SurveyModel survey) async {
    await db.collection("survey").doc(docs).update({"detail": survey.detail});

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> saveTestByDocs $docs");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentLessonByDocs(
      String docs) async {
    final temp = await db.collection("student_lesson").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentLessonByDocs $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
      'token': model.btvnToken,
      'type': model.type,
      'dataversion': model.version,
      'prefix': model.prefix,
      "suffix": model.suffix,
      'data_token': model.dataToken,
    });
    debugPrint("==========> add db for \"courses\"");
  }

  Future<void> addBill(BillModel model) async {
    await db.collection("bill").doc("bill_${model.createDate}").set({
      'check': model.check,
      'class_id': model.classId,
      'create_date': model.createDate,
      'delete': model.delete,
      'note': model.note,
      'payment': model.payment,
      'payment_date': model.paymentDate,
      'refund': model.refund,
      'renew_date': model.renewDate,
      'status': model.status,
      'type': model.type,
      'user_id': model.userId,
      'creator': model.creator,
      'currency': model.currency,
      'course_id': model.courseId,
      'class_type': model.classType
    });
    debugPrint("==========> add db for \"bill\"");
  }

  Future<void> addNewSchedule(ScheduleModel model) async {
    await db.collection("schedule").doc("schedule_${model.id}").set({
      'class_id': model.classId,
      'date': model.date,
      'calendar': model.calendar,
      'id': model.id,
      'time': model.time,
      'status': model.status,
      'teacher_id': model.teacherId,
      'start_date': model.startDate,
      'end_date': model.endDate,
      'type': model.type
    });
  }

  Future<void> updateSchedule(ScheduleModel model) async {
    await db.collection("schedule").doc("schedule_${model.id}").set({
      'class_id': model.classId,
      'date': model.date,
      'calendar': model.calendar,
      'id': model.id,
      'time': model.time,
      'status': model.status,
      'teacher_id': model.teacherId,
      'start_date': model.startDate,
      'end_date': model.endDate,
      'type': model.type
    });
  }

  Future<void> addFeedBack(FeedBackModel model) async {
    await db
        .collection("feedbacks")
        .doc("feedback_classId_${model.classId}_${model.date}")
        .set({
      'category': model.category,
      'class_id': model.classId,
      'content': model.content,
      'date': model.date,
      'note': model.note,
      'role': model.role,
      'status': model.status,
      'user_id': model.userId,
    });
    debugPrint("==========> add db for \"bill\"");
  }

  Future<void> updateBill(BillModel model) async {
    await db.collection("bill").doc("bill_${model.createDate}").update({
      'check': model.check,
      'class_id': model.classId,
      'create_date': model.createDate,
      'delete': model.delete,
      'note': model.note,
      'payment': model.payment,
      'payment_date': model.paymentDate,
      'refund': model.refund,
      'renew_date': model.renewDate,
      'status': model.status,
      'type': model.type,
      'user_id': model.userId,
      'creator': model.creator,
      'currency': model.currency,
      'course_id': model.courseId,
      'class_type': model.classType
    });
    debugPrint("==========> update db for \"bill\"");
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
      "vocabulary": model.vocabulary,
      "reading": model.reading,
      "enable": model.enable
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
      "title": model.title,
      "enable": model.enable,
      "duration": model.duration
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
      "title": model.title,
      "enable": model.enable,
      "duration": model.duration
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
      'token': model.btvnToken,
      'type': model.type,
      'dataversion': model.version,
      'prefix': model.prefix,
      "suffix": model.suffix,
      'data_token': model.dataToken,
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
      "vocabulary": model.vocabulary,
      "reading": model.reading,
      "enable": model.enable
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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> checkLessonResult $lessonId $classId ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<void> addLessonResult(LessonResultModel model) async {
    await db
        .collection("lesson_result")
        .doc("lesson_${model.lessonId}_class_${model.classId}")
        .set({
      'class_id': model.classId,
      'date_time': model.date,
      'id': model.id,
      'lesson_id': model.lessonId,
      'status': model.status,
      'student_note': model.noteForStudent,
      'support_note': model.noteForSupport,
      'teacher_id': model.teacherId,
      'teacher_note': model.noteForTeacher,
      'date': model.dateTime
    });

    debugPrint("==========>get and add db from \"lesson_result\"");
  }

  Future<void> updateProfileTeacher(TeacherModel model) async {
    await db.collection('teacher').doc("teacher_user_${model.userId}").update({
      'name': model.name,
      'note': model.note,
      'url': model.url,
      'status': model.status,
      'teacher_code': model.teacherCode,
      'phone': model.phone,
      'user_id': model.userId,
      'schedule': model.schedule,
      'email': model.email
    });
    debugPrint("==========>update db for \"teacher\"");
  }

  Future<void> updateProfileStudent(StudentModel model) async {
    await db.collection('students').doc("student_user_${model.userId}").update({
      'name': model.name,
      'note': model.note,
      'url': model.url,
      'status': model.status,
      'student_code': model.studentCode,
      'phone': model.phone,
      'user_id': model.userId,
      'in_jp': model.inJapan,
      'email': model.email
    });
    debugPrint("==========>update db for \"students\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestByCourseId(
      int courseId) async {
    final snapshot = await db
        .collection("test")
        .where("course_id", isEqualTo: courseId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTestByCourseId $courseId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTestByTestId(
      int testId) async {
    final snapshot = await db
        .collection("test")
        .where("id", isEqualTo: testId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTestByTestId $testId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentTest(
      int classId) async {
    final snapshot = await db
        .collection('student_test')
        .where('class_id', isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentTest $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentTestByStdId $studentId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTestResult(
      int classId) async {
    final snapshot = await db
        .collection("test_result")
        .where("class_id", isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListTestResult $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSurveyById(int id) async {
    final snapshot =
        await db.collection("survey").where("id", isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSurveyResultByClassId(
      int classId) async {
    final snapshot = await db
        .collection("survey_result")
        .where("class_id", isEqualTo: classId)
        .where("status", isNotEqualTo: "delete")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyResultByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSurveyAnswerByClassId(
      int classId, int surveyId) async {
    final snapshot = await db
        .collection("survey_answer")
        .where("class_id", isEqualTo: classId)
        .where("survey_id", isEqualTo: surveyId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyAnswerByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSurveyAnswer(
      int classId) async {
    final snapshot = await db
        .collection("survey_answer")
        .where("class_id", isEqualTo: classId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyAnswer $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentSurveyEnable() async {
    final snapshot = await db
        .collection("survey")
        .where("enable", isEqualTo: true)
        .where("active", isEqualTo: true)
        .where('type', isEqualTo: 'student')
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyEnable ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<void> saveUser(String email, String role, int uid) async {
    await CustomFirebaseFireStore.database
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email.toLowerCase(), 'roles': role, 'user_id': uid});

    debugPrint("==========>add db from \"users\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUser() async {
    final snapshot = await db.collection("users").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllUser ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<void> createNewStudent(StudentModel model, UserModel user) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    // await FirebaseAuth.instance.currentUser!.updateEmail(user.email);
    await db.collection('students').doc("student_user_${user.id}").set({
      'in_jp': model.inJapan,
      'name': model.name,
      'note': model.note,
      'phone': model.phone,
      'student_code': model.studentCode,
      'url': model.url,
      'user_id': model.userId,
      'status': model.status,
      'email': model.email
    });
    debugPrint("==========>add db for \"students\"");
  }

  Future<void> createNewSurvey(SurveyModel model) async {
    await db.collection('survey').doc("survey_${model.id}").set({
      'id': model.id,
      'title': model.title,
      'description': model.description,
      'survey_code': model.surveyCode,
      'enable': model.enable,
      'active': model.active,
      'detail': model.detail,
      'type': model.type
    });
    debugPrint("==========>add db for \"survey\"");
  }

  Future<void> createNewBrowseDownload(BrowseDownloadModel model) async {
    await db
        .collection('browse_download')
        .doc("browse_download${model.id}")
        .set({
      'id': model.id,
      'class_id': model.classId,
      'lesson_id': model.lessonId,
      'teacher_id': model.teacherId,
      'submit_time': model.submitTime,
      'download_time': model.downloadTime,
      'accept_time': model.acceptTime,
      'support_id': model.supportId,
      'status': model.status,
      'parent_id': model.parentId
    });
    debugPrint("==========>add db for \"browse_download\"");
  }

  Future<void> updateBrowseDownload(BrowseDownloadModel model) async {
    await db
        .collection('browse_download')
        .doc("browse_download${model.id}")
        .update({
      'id': model.id,
      'class_id': model.classId,
      'lesson_id': model.lessonId,
      'teacher_id': model.teacherId,
      'submit_time': model.submitTime,
      'download_time': model.downloadTime,
      'accept_time': model.acceptTime,
      'support_id': model.supportId,
      'status': model.status,
      'parent_id': model.parentId
    });
    debugPrint("==========>add db for \"browse_download\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    final snapshot =
        await db.collection("users").where('email', isEqualTo: email).get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getUserByEmail $email ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSurveyByCode(
      String code) async {
    final snapshot = await db
        .collection("survey")
        .where('survey_code', isEqualTo: code)
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyByCode $code ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<void> createNewTeacher(TeacherModel model, UserModel user) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email, password: "abc12345");
    await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
    // await FirebaseAuth.instance.currentUser!.updateEmail(user.email);

    await db.collection('teacher').doc("teacher_user_${user.id}").set({
      'name': model.name,
      'note': model.note,
      'phone': model.phone,
      'status': model.status,
      'teacher_code': model.teacherCode,
      'url': model.url,
      'user_id': model.userId,
      'schedule': model.schedule,
      'email': model.email
    });
    debugPrint("==========>add db for \"teacher\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassNotRemove() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", isNotEqualTo: "Remove")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassNotRemove ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMoreClassWithFilter(
      List<String> listStatusFilter,
      List<int> listTypeFilter,
      int lastId,
      List<int> listCourseId) async {
    final snapshot = await db
        .collection("class")
        .orderBy('class_id', descending: true)
        .where(Filter.and(
            Filter("class_status", whereIn: listStatusFilter),
            Filter("course_id", whereIn: listCourseId),
            Filter("class_type", whereIn: listTypeFilter)))
        .startAfter([lastId])
        .limit(10)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassWithFilter(
      List<String> listStatusFilter,
      List<int> listTypeFilter,
      List<int> listCourseId) async {
    final snapshot = await db
        .collection("class")
        .orderBy('class_id', descending: true)
        .where(Filter.and(
            Filter("class_status", whereIn: listStatusFilter),
            Filter("course_id", whereIn: listCourseId),
            Filter("class_type", whereIn: listTypeFilter)))
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassWithFilter ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListBillWithFilter(
      List<String> listStatusFilter,
      List<String> listTypeFilter,
      List<String> listCreatorFilter) async {
    final snapshot = await db
        .collection("bill")
        .orderBy('create_date', descending: true)
        .where(Filter.and(
            Filter("check", whereIn: listStatusFilter),
            Filter("type", whereIn: listTypeFilter),
            Filter("creator", whereIn: listCreatorFilter)))
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListBillWithFilter ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMoreListBillWithFilter(
      List<String> listStatusFilter,
      List<String> listTypeFilter,
      List<String> listCreatorFilter,
      int lastItem) async {
    final snapshot = await db
        .collection("bill")
        .orderBy('create_date', descending: true)
        .where(Filter.and(
            Filter("check", whereIn: listStatusFilter),
            Filter("type", whereIn: listTypeFilter),
            Filter("creator", whereIn: listCreatorFilter)))
        .startAfter([lastItem])
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListBillWithFilter ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMoreListBillWithFilterAndDate(
      List<String> listStatusFilter,
      List<String> listTypeFilter,
      List<String> listCreatorFilter,
      int lastItem,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("bill")
        .orderBy('create_date', descending: true)
        .where(Filter.and(
            Filter("check", whereIn: listStatusFilter),
            Filter("create_date", isGreaterThanOrEqualTo: startDate),
            Filter("create_date", isLessThanOrEqualTo: endDate),
            Filter("type", whereIn: listTypeFilter),
            Filter("creator", whereIn: listCreatorFilter)))
        .startAfter([lastItem])
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListBillWithFilterAndDate ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListBillWithFilterAndDate(
      List<String> listStatusFilter,
      List<String> listTypeFilter,
      List<String> listCreatorFilter,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("bill")
        .orderBy('create_date', descending: true)
        .where(Filter.and(
            Filter("check", whereIn: listStatusFilter),
            Filter("create_date", isGreaterThanOrEqualTo: startDate),
            Filter("create_date", isLessThanOrEqualTo: endDate),
            Filter("type", whereIn: listTypeFilter),
            Filter("creator", whereIn: listCreatorFilter)))
        .limit(10)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListBillWithFilterAndDate ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListBillStatistic(
      List<int> listTypeFilter,
      List<int> listCourseId,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("bill")
        .orderBy('payment_date')
        .where(Filter.and(
          Filter("payment_date", isGreaterThanOrEqualTo: startDate),
          Filter("payment_date", isLessThanOrEqualTo: endDate),
          Filter("class_type", whereIn: listTypeFilter),
          Filter("course_id", whereIn: listCourseId),
        ))
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListStudentClassLogStatistic(
      List<int> listTypeFilter,
      List<int> listCourseId,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("student_class_log")
        .orderBy('id')
        .where(Filter.and(
          Filter("id", isGreaterThanOrEqualTo: startDate),
          Filter("id", isLessThanOrEqualTo: endDate),
          Filter("class_type", whereIn: listTypeFilter),
          Filter("course_id", whereIn: listCourseId),
        ))
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> get log ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassStatistic0(
      List<int> listTypeFilter,
      List<int> listCourseId,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("class")
        .orderBy('start_time')
        .where(Filter.and(
            Filter("start_time", isGreaterThanOrEqualTo: startDate),
            Filter("start_time", isLessThanOrEqualTo: endDate),
            Filter("class_status", whereIn: ['Preparing', 'InProgress']),
            Filter("informal", isEqualTo: false)))
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassStatistic1(
      List<int> listTypeFilter,
      List<int> listCourseId,
      int startDate,
      int endDate) async {
    final snapshot = await db
        .collection("class")
        .orderBy('end_time')
        .where(Filter.and(
            Filter("end_time", isGreaterThanOrEqualTo: startDate),
            Filter("end_time", isLessThanOrEqualTo: endDate),
            Filter("class_status", whereIn: ['Completed', 'Cancel']),
            Filter("informal", isEqualTo: false)))
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListBillByStdId(
      int stdId) async {
    final snapshot =
        await db.collection("bill").where("user_id", isEqualTo: stdId).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListBillByStdId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListGroupTags() async {
    final snapshot = await db.collection("group_tags").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getGroupTags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassForAdmin() async {
    final snapshot = await db.collection("class").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> allClass ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassForTeacher(
      List<int> listIds) async {
    final snapshot = await db
        .collection("class")
        .where("class_id", whereIn: listIds)
        .where("class_status", isNotEqualTo: "Remove")
        .get();
    // debugPrint("==========>get db from \"class\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassAvailableForTeacher ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassListIds(
      List<int> listIds) async {
    final snapshot =
        await db.collection("class").where("class_id", whereIn: listIds).get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListClassForTeacherV2(
      List<int> listIds, List<String> listStatus) async {
    final snapshot = await db
        .collection("class")
        .where(Filter.and(Filter("class_id", whereIn: listIds),
            Filter("class_status", whereIn: listStatus)))
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListClassAvailableForTeacher ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClass() async {
    final snapshot = await db.collection("teacher_class").get();
    // debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacherInClass ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacherInClassByClassId(
      int classId) async {
    final snapshot = await db
        .collection("teacher_class")
        .where('class_id', isEqualTo: classId)
        .where('class_status', isEqualTo: "InProgress")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacherInClassByClassId $classId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"teacher_class\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllLessonNotBTVN() async {
    final snapshot =
        await db.collection("lessons").where('btvn', isEqualTo: 0).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllLessonNotBTVN ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListFeedBack(
      String status, String role) async {
    final snapshot = await db
        .collection("feedbacks")
        .where('status', isEqualTo: status)
        .where('role', isEqualTo: role)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListFeedBack ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudent() async {
    final snapshot = await db.collection("students").get();
    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudent ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> get10StudentFirst ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentById(
      int studentId) async {
    final snapshot = await db
        .collection("students")
        .where('user_id', isEqualTo: studentId)
        .get();
    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentById ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> get10Student $lastId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    // debugPrint("==========>get db from \"students\": ${snapshot.docs.length}");
    return snapshot;
  }

  Future<AggregateQuerySnapshot> getCount(String tableName) async {
    final count = await db.collection(tableName).count().get();
    debugPrint("==========>get count db from \"$tableName\"");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCount $tableName - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return count;
  }

  Future<AggregateQuerySnapshot> getCountBill(
      int startDate, int endDate, List<String> listCountSale) async {
    final count = await db
        .collection('bill')
        .where(Filter.and(
          Filter("payment_date", isGreaterThanOrEqualTo: startDate),
          Filter("payment_date", isLessThanOrEqualTo: endDate),
          Filter("type", whereIn: listCountSale),
        ))
        .count()
        .get();

    return count;
  }

  Future<AggregateQuerySnapshot> getCountClass(
      int startDate, int endDate) async {
    final count = await db
        .collection('class')
        .where(Filter.and(
          Filter("start_time", isGreaterThanOrEqualTo: startDate),
          Filter("start_time", isLessThanOrEqualTo: endDate),
          Filter("class_status", whereIn: ['Preparing', 'InProgress']),
          Filter("informal", isEqualTo: false),
        ))
        .count()
        .get();
    return count;
  }

  Future<AggregateQuerySnapshot> getCountLessonResult(int classId) async {
    final count = await db
        .collection('lesson_result')
        .where('class_id', isEqualTo: classId)
        .count()
        .get();
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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========>check db exist from \"$tableName\" with $field equal ${condition.toString()} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return count;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTeacher() async {
    final snapshot = await db.collection("teacher").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllTeacher ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeacherWithStatusFilter(
      List<String> status) async {
    final snapshot = await db
        .collection("teacher")
        .orderBy('user_id', descending: true)
        .where('status', whereIn: status)
        .limit(10)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMoreTeacherWithStatusFilter(
      List<String> status, int lastId) async {
    final snapshot = await db
        .collection("teacher")
        .orderBy('user_id', descending: true)
        .where('status', whereIn: status)
        .startAfter([lastId])
        .limit(10)
        .get();

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAdminById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<CourseModel> getCourseByName(String title, String term) async {
    final snapshot = await db
        .collection("courses")
        .where('title', isEqualTo: title)
        .where('term_name', isEqualTo: term)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseByName $title $term ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getClassByClassCode $classCode ${temp.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
      'class_type': model.classType,
      'link': model.link,
      'informal': model.informal,
      'is_sub_class': model.isSubClass,
      'sub_class_id': model.subClassId
    });
    debugPrint("==========>add db for \"class\"");
  }

  Future<void> submitTeacherSurvey(TeacherSurveyAnswerModel model) async {
    await db
        .collection("teacher_survey_answer")
        .doc("teacher_${model.teacherId}_survey_${model.surveyId}_dateAssign_${model.dateAssign}")
        .set({
      'date_assign': model.dateAssign,
      'id': model.id,
      'detail': model.detail,
      'teacher_id': model.teacherId,
      'survey_id': model.surveyId,
    });
    debugPrint("==========>add db for \"teacher_survey_answer\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentClassByDoc(
      String doc) async {
    final temp = await db.collection("student_class").doc(doc).get();

    // debugPrint("==========>get db from \"student_class\"");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentClassByDoc $doc ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSurveyResultByDoc(
      String doc) async {
    final temp = await db.collection("survey_result").doc(doc).get();

    // debugPrint("==========>get db from \"student_class\"");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getSurveyResultByDoc $doc ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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

  Future<void> addNewLog(StudentClassLogModel model) async {
    await db.collection("student_class_log").doc("log_${model.id}").set({
      'id': model.id,
      'class_id': model.classId,
      'course_id': model.courseId,
      'class_type': model.classType,
      'user_id': model.userId,
      'from': model.from,
      'to': model.to
    });
    debugPrint("==========>add db for \"student_class_log\"");
  }

  Future<void> addSurveyToClass(SurveyModel model, int classId, int id) async {
    await db
        .collection("survey_result")
        .doc("class_${classId}_survey_${model.id}")
        .set({
      'status': "waiting",
      'class_id': classId,
      'survey_id': model.id,
      'id': id,
      'survey_code': model.surveyCode,
      'title': model.title,
      'date_assign': 0
    });
    debugPrint("==========>add db for \"survey_result\"");
  }

  Future<void> updateStudentToClass(StudentClassModel model) async {
    await db
        .collection("student_class")
        .doc("student_${model.userId}_class_${model.classId}")
        .update({'class_status': "InProgress"});
    debugPrint("==========>update db for \"student_class\"");
  }

  Future<void> updateSurveyToClass(SurveyModel model, int classId) async {
    await db
        .collection("survey_result")
        .doc("class_${classId}_survey_${model.id}")
        .update({'status': "waiting"});
    debugPrint("==========>update db for \"survey_result\"");
  }

  Future<void> assignSurveyResult(SurveyResultModel model) async {
    await db
        .collection("survey_result")
        .doc("class_${model.classId}_survey_${model.surveyId}")
        .update({'status': model.status, 'date_assign': model.dateAssign});
    debugPrint("==========>update db for \"survey_result\"");
  }

  Future<void> addTeacherSurvey(TeacherSurveyModel model) async {
    await db
        .collection("teacher_survey")
        .doc(
            "teacher_${model.teacherId}_survey_${model.surveyId}_time_${model.id}")
        .set({
      'status': model.status,
      'date_assign': model.dateAssign,
      'teacher_id': model.teacherId,
      'survey_id': model.surveyId,
      'id': model.id,
      'survey_code': model.surveyCode,
      'title': model.title
    });
    debugPrint("==========>add db for \"teacher_survey\"");
  }

  Future<void> updateTeacherSurvey(TeacherSurveyModel model) async {
    await db
        .collection("teacher_survey")
        .doc(
            "teacher_${model.teacherId}_survey_${model.surveyId}_time_${model.id}")
        .update({'status': model.status});
    debugPrint("==========>update db for \"survey_result\"");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTeacherClassByDocs(
      String docs) async {
    final temp = await db.collection("teacher_class").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTeacherClassByDocs $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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

  Future<QuerySnapshot<Map<String, dynamic>>> getBrowseDownloadWaiting() async {
    final snapshot = await db
        .collection("browse_download")
        .where("status", isEqualTo: 'waiting')
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      getBrowseDownloadWaitingAndAcceptByClassAndTeacherId(
          int classId, int teacherId) async {
    final snapshot = await db
        .collection("browse_download")
        .where("status", whereIn: ['waiting', 'accept'])
        .where("class_id", isEqualTo: classId)
        .where('teacher_id', isEqualTo: teacherId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllBrowseDownloadByClassId(
      int classId) async {
    final snapshot = await db
        .collection("browse_download")
        .where("class_id", isEqualTo: classId)
        .get();

    return snapshot;
  }

  Future<void> changeClassStatus(
      ClassModel classModel, String newStatus) async {
    CustomFirebaseFireStore.database
        .collection('class')
        .doc('class_${classModel.classId}_course_${classModel.courseId}')
        .update({'class_status': newStatus}).whenComplete(() {
      debugPrint("==========>update db for \"class\"");
    });
  }

  Future<void> updateClassInfo(ClassModel model) async {
    CustomFirebaseFireStore.database
        .collection('class')
        .doc('class_${model.classId}_course_${model.courseId}')
        .update({
      'description': model.description,
      'end_time': model.endTime,
      'start_time': model.startTime,
      'note': model.note,
      'class_code': model.classCode,
      'class_status': model.classStatus,
      'class_type': model.classType,
      'link': model.link,
      'custom_lesson': model.customLessons,
      'informal': model.informal,
      'is_sub_class': model.isSubClass,
      'sub_class_id': model.subClassId,
      'custom_test': model.customTests
    });
    debugPrint("==========>update db for \"class_${model.classId}_course_${model.courseId}\"");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllStudentInFoInClass(
      List<int> listStdId) async {
    final snapshot = await db
        .collection("students")
        .where("user_id", whereIn: listStdId)
        .get();
    // debugPrint("==========>get db from \"students\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllStudentInFoInClass $listStdId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByLessonId(
      List<int> ids) async {
    final snapshot =
        await db.collection("lessons").where("lesson_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByListLessonId $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLessonsByListCourseId(
      List<int> ids) async {
    final snapshot =
        await db.collection("lessons").where("course_id", whereIn: ids).get();
    // debugPrint("==========>get db from \"lessons\" : ${snapshot.docs.length}");

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getLessonsByListCourseId $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

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
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getStudentTestByIds $ids ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getVoucher(String docs) async {
    final temp = await db.collection("voucher").doc(docs).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getVoucher $docs ${temp.exists} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return temp;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListSearchVoucher(
      String text, String type) async {
    final snapshot = await db
        .collection("voucher")
        .where(type,
            isGreaterThanOrEqualTo: text, isLessThanOrEqualTo: "$text\uf7ff")
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getListSearchVoucher ${snapshot.size}");
    return snapshot;
  }

  Future<void> addVoucher(VoucherModel model) async {
    await db
        .collection("voucher")
        .doc("sakumi_voucher_${model.voucherCode}")
        .set({
      'id': model.id,
      'recipient_code': model.recipientCode,
      'used_user_code': model.usedUserCode,
      'voucher_code': model.voucherCode,
      'create_date': model.createDate,
      'used_date': model.usedDate,
      'expired_date': model.expiredDate,
      'noted': model.noted,
      'price': model.price,
      'type': model.type,
      'full_course': model.isFullCourse
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVoucherByVoucherCode(
      String code) async {
    final snapshot = await db
        .collection("voucher")
        .where("voucher_code", isEqualTo: code)
        .get();

    return snapshot;
  }

  Future<void> updateVoucher(String usedUserCode, String noted,
      String voucherCode, String dateTime) async {
    await db.collection("voucher").doc("sakumi_voucher_$voucherCode").update({
      'used_date': dateTime,
      'used_user_code': usedUserCode,
      'noted': noted,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllClassInProgress() async {
    final snapshot = await db
        .collection("class")
        .where("class_status", isEqualTo: 'InProgress')
        .get();
    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getAllClassInProgress ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> addTag(TagModel tag) async {
    bool value = true;
    await db
        .collection("tags")
        .doc("tag_${tag.id}")
        .set(tag.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }

  Future<bool> addGroupTag(GroupTagModel groupTag) async {
    bool value = true;
    await db
        .collection("group_tags")
        .doc("group_tag_${groupTag.id}")
        .set(groupTag.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }

  Future<bool> deleteGroupTag(String doc) async {
    bool value = true;
    await db
        .collection("group_tags")
        .doc(doc)
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListTags() async {
    final snapshot = await db.collection("tags").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getGroupTags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> deleteTag(int id) async {
    bool value = true;
    await db
        .collection("tags")
        .doc("tag_$id")
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getManageTags() async {
    final snapshot = await db.collection("manage_tags").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> manage_tags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getManageTagsWithSpecificTags(
      List<int> listId) async {
    final snapshot = await db
        .collection("manage_tags")
        .where('tags', arrayContainsAny: listId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getManageTagsWithSpecificTags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTagById(int tagId) async {
    final snapshot =
        await db.collection('tags').where('id', isEqualTo: tagId).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTagById $tagId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getManageTagByIdAndType(
      int ownId, int type) async {
    final snapshot = await db
        .collection('manage_tags')
        .where('own_id', isEqualTo: ownId)
        .where('type', isEqualTo: type)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getManageTagByIdAndType $ownId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> addManageTag(ManageTagModel manageTagModel) async {
    bool value = true;
    await db
        .collection("manage_tags")
        .doc("manage_tag_${manageTagModel.date}")
        .set(manageTagModel.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      print(error);
      value = false;
    });
    return value;
  }

  Future<bool> deleteManageTag(String doc) async {
    bool value = true;
    await db
        .collection("manage_tags")
        .doc(doc)
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }

  Future<void> deleteTagIdInManageTag(String documentId, int tagId) async {
    DocumentReference docRef = db.collection('manage_tags').doc(documentId);
    docRef.update({
      'tags': FieldValue.arrayRemove([tagId])
    }).then((_) {
      docRef.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          List<dynamic> tags = (docSnapshot.data() as Map)['tags'];
          if (tags.isEmpty) {
            docRef.delete();
          } else {
            debugPrint("Xoá tag thành công");
          }
        } else {
          debugPrint("Tài liệu không tồn tại");
        }
      });
    }).catchError((error) {
      debugPrint("Lỗi khi xoá tag: $error");
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getManageTagsContainsTagId(
      int tagId) async {
    final snapshot = await db
        .collection("manage_tags")
        .where('tags', arrayContains: tagId)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> manage_tags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> addBanner(BannerModel banner) async {
    bool value = true;
    await db
        .collection("manage_banners")
        .doc("banner_${banner.id}")
        .set(banner.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      print(error);
      value = false;
    });
    return value;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBanners() async {
    final snapshot = await db.collection("manage_banners").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getGroupTags ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getBannerOptionsById(int id) async {
    final snapshot =
    await db.collection('banner_options').where('banner_id', isEqualTo: id).get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getTagById $id ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getBannerOptionByIdAndType(
      int ownId, int type) async {
    final snapshot = await db
        .collection('banner_options')
        .where('banner_id', isEqualTo: ownId)
        .where('type', isEqualTo: type)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getBannerOptionById $ownId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> addBannerOption(BannerOption bannerOption)  async {
    bool value = true;
    await db
        .collection("banner_options")
        .doc("banner_option_${bannerOption.id}")
        .set(bannerOption.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      print(error);
      value = false;
    });
    return value;
  }

  Future<bool> deleteBannerOption(String doc) async {
    bool value = true;
    await db
        .collection("banner_options")
        .doc(doc)
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }
  Future<bool> deleteBanner(String doc)  async {
    bool value = true;
    await db
        .collection("manage_banners")
        .doc(doc)
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getCourseSuggests() async {
    final snapshot = await db.collection("manage_course_suggests").get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCourseSuggests ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }

  Future<bool> addCourseSuggest(CourseSuggestModel cs)  async {
    bool value = true;
    await db
        .collection("manage_course_suggests")
        .doc("course_suggests_${cs.id}")
        .set(cs.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      print(error);
      value = false;
    });
    return value;
  }
  Future<bool>  deleteCourseSuggest(CourseSuggestModel cs)  async {
    bool value = true;
    await db
        .collection("manage_course_suggests")
        .doc('course_suggests_${cs.id}')
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getCSOptionByIdAndType(
      int ownId, int type) async {
    final snapshot = await db
        .collection('course_suggest_options')
        .where('cs_id', isEqualTo: ownId)
        .where('type', isEqualTo: type)
        .get();

    debugPrint(
        "FireStore CALL >>>>>>>>>>>>>>>>>>> ===========> getCSOptionByIdAndType $ownId ${snapshot.size} - ${DateFormat('hh:mm:ss.mmm').format(DateTime.now())}");

    return snapshot;
  }
  Future<bool> addCSOption(CSOption csOption)  async {
    bool value = true;
    await db
        .collection("course_suggest_options")
        .doc("cs_option_${csOption.id}")
        .set(csOption.toJson(), SetOptions(merge: true))
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      print(error);
      value = false;
    });
    return value;
  }


  Future<bool> deleteCSOption(String s)  async {
    bool value = true;
    await db
        .collection("course_suggest_options")
        .doc(s)
        .delete()
        .whenComplete(() => value = true)
        .onError((error, stackTrace) {
      value = false;
    });
    return value;
  }
}
