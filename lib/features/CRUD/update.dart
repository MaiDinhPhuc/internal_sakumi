import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/browse_download_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import '../../services/custom_firebase_firestore.dart';

class Update  {

  static updateResponsibility(TeacherClassModel newValue) {
    CustomFirebaseFireStore.database
        .collection('teacher_class')
        .doc('teacher_${newValue.userId}_class_${newValue.classId}')
        .update({'responsibility': newValue.responsibility});
  }

  static updateStudentClassStatus(int userId, int classId, String newStatus) {
    CustomFirebaseFireStore.database
        .collection('student_class')
        .doc('student_${userId}_class_$classId')
        .update({
      'class_status': newStatus,
      "last_time_change": DateTime.now().millisecondsSinceEpoch
    });
  }

  static updateClassInfo(ClassModel model) {
    FireBaseProvider.instance.updateClassInfo(model);
  }

  static updateAttendance(
      int attendId, int id, int classId, int lessonId, context) async {
    await FireBaseProvider.instance
        .updateTimekeeping(id, lessonId, classId, attendId);
  }

  static updateStudentStatus(String type, int point, int id, int classId) async {
    await FireBaseProvider.instance
        .updateStudentStatus(id, classId, point, type);
  }

  static updateTeacherNote(int userId, String note, int lessonId, int classId) async {
    await FireBaseProvider.instance
        .updateTeacherNote(userId, lessonId, classId, note);
  }

  static updateLessonStatus(int lessonId, int classId, String status) async {
    await FireBaseProvider.instance
        .changeStatusLesson(lessonId, classId, status);
  }

  static updateNoteForAllStudentInClass(int lessonId, int classId, String note) async {
    await FireBaseProvider.instance
        .noteForAllStudentInClass(lessonId, classId, note);
  }

  static updateTeacherInLessonResult(int lessonId, int classId, int teacherId) async {
    await FireBaseProvider.instance
        .updateTeacherInLessonResult(lessonId, classId, teacherId);
  }

  static updateNoteForSupport(int lessonId, int classId, String note) async {
    await FireBaseProvider.instance.noteForSupport(lessonId, classId, note);
  }

  static updateNoteForSensei(int lessonId, int classId, String note) async {
    await FireBaseProvider.instance
        .noteForAnotherSensei(lessonId, classId, note);
  }

  static updateTeacherProfile(TeacherModel model) async {
    await FireBaseProvider.instance.updateProfileTeacher(model);
  }

  static updateProfileStudent(StudentModel model) async {
    await FireBaseProvider.instance.updateProfileStudent(model);
  }

  static updateSurveyResult(SurveyResultModel result) async {
    await FireBaseProvider.instance.assignSurveyResult(result);
  }

  static updateLessonResult(int lessonId, int classId, String note) async {
    await FireBaseProvider.instance.updateLessonResult(lessonId, classId, note);
  }

  static updateCourseInfo(CourseModel course)async {
    await FireBaseProvider.instance.updateCourseInfo(course);
  }

  static updateLessonInfo(LessonModel lesson) async {
    await FireBaseProvider.instance.updateLessonInfo(lesson);
  }

  static updateTestInfo(TestModel test) async{
    await FireBaseProvider.instance.updateTestInfo(test);
  }

  static updateCourseState(CourseModel courseModel, bool state) async{
    await FireBaseProvider.instance.updateCourseState(courseModel,state);
  }

  static activeSurvey(int id)async{
    await FireBaseProvider.instance.activeSurvey(id);
  }

  static saveSurvey(SurveyModel model)async{
    await FireBaseProvider.instance.saveSurvey(model);
  }

  static updateBrowseDownload(BrowseDownloadModel model)async{
    await FireBaseProvider.instance.updateBrowseDownload(model);
  }
}
