import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/feedback_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_home_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/screens/login_screen.dart';

abstract class NetworkProvider {
  //user
  Future<void> logInUser(TextEditingController email,
      TextEditingController password, BuildContext context, ErrorCubit cubit);

  Future<void> logOutUser(BuildContext context);

  Future<bool> autoLogInUser(String email, BuildContext context);

  Future<bool> changePassword(String email, String oldPass, String newPass);

  Future<String> uploadImageAndGetUrl(Uint8List data, String folder);

  Future<int> getCountWithCondition(
      String tableName, String field, dynamic condition);

  Future<List<ClassModel2>> getClassByAdmin();

  Future<UserModel> getUser(String email);

  Future<List<ClassModel2>> getClassByTeacherId(int teacherId);

  Future<List<LessonResultModel>> getLessonsResultsByListClassIds(
      List<int> ids);

  Future<UserModel> getUserById(int id);

  Future<void> saveUser(String email, String role, int uid);

  Future<List<UserModel>> getAllUser();

  Future<bool> createNewStudent(StudentModel model, UserModel user);

  Future<bool> createNewTeacher(TeacherModel model, UserModel user);

  //Teacher
  Future<TeacherModel> getTeacherByTeacherCode(String teacherCode);

  Future<TeacherModel> getTeacherById(int id);

  Future<List<TeacherClassModel>> getTeacherClassById(int id);

  Future<List<LessonModel>> getLessonsByCourseId(int id);

  Future<ClassModel> getClassById(int id);

  Future<CourseModel> getCourseById(int id);

  Future<List<LessonResultModel>> getLessonResultByClassId(int id);

  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(
      int classId, int lessonId);

  Future<LessonResultModel> getLessonResultByLessonId(int id, int classId);

  Future<List<CourseModel>> getAllCourse();

  Future<List<QuestionModel>> getQuestionByUrl(String url);

  Future<List<StudentClassModel>> getStudentClassInClass(int classId);

  Future<List<StudentClassModel>> getStudentClassByListId(List<int> ids);

  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(int classId);

  Future<List<AnswerModel>> getListAnswer(int id, int classId);

  Future<LessonModel> getLesson(int courseId, int lessonId);

  Future<void> updateTimekeeping(
      int userId, int lessonId, int classId, int attendId);

  Future<void> updateTeacherNote(
      int userId, int lessonId, int classId, String note);

  Future<void> updateStudentStatus(
      int userId, int classId, int point, String type);

  Future<void> changeStatusLesson(int lessonId, int classId, String status);

  Future<void> noteForAllStudentInClass(int lessonId, int classId, String note);

  Future<void> updateTeacherInLessonResult(
      int lessonId, int classId, int studentId);

  Future<void> noteForSupport(int lessonId, int classId, String note);

  Future<void> noteForAnotherSensei(int lessonId, int classId, String note);

  Future<bool> addStudentLesson(StudentLessonModel model);

  Future<bool> checkLessonResult(int lessonId, int classId);

  Future<bool> addLessonResult(LessonResultModel model);

  Future<void> updateProfileTeacher(String id, TeacherModel model);

  Future<List<TestModel>> getListTestByCourseId(int courseId);

  Future<List<StudentTestModel>> getAllStudentTest(int classId);

  Future<List<TestResultModel>> getListTestResult(int classId);

  Future<List<StudentModel>> getAllStudentInFoInClass(List<int> listStdId);

  Future<List<LessonModel>> getLessonsByLessonId(List<int> ids);

  Future<List<LessonModel>> getLessonsByListCourseId(List<int> ids);

  Future<List<TeacherModel>> getListTeacherByListId(List<int> teacherIds);

  Future<List<StudentLessonModel>> getStudentLessons(
      int classId, List<int> studentIds);

  Future<DetailGradingDataModel> getDataForDetailGrading(
      int classId, int parentId, String type);

  Future<List<StudentTestModel>> getAllStudentTestInLesson(
      int classId, int testId);

  Future<List<StudentTestModel>> getListStudentTestByIDs(List<int> listTestIds);

  Future<List<CourseModel>> getCourseByListId(List<int> listCourseIds);

  Future<List<StudentLessonModel>> getAllStudentLessonsInListClassId(
      List<int> listClassId);

  Future<List<ClassModel>> getListClassForTeacher(List<int> ids);

  //admin
  Future<List<ClassModel>> getListClassNotRemove();

  Future<List<LessonModel>> getListLessonNotBTVN();

  Future<List<TeacherClassModel>> getAllTeacherInClass();

  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(int classId);

  Future<List<StudentModel>> getAllStudent();

  Future<List<StudentModel>> get10StudentFirst();

  Future<List<StudentModel>> get10Student(int lastId);

  Future<int> getTotalPage(String tableName);

  Future<List<TeacherModel>> getAllTeacher();

  // Future<List<TagModel>> getTags();



  Future<void> updateLessonInfo(LessonModel lessonModel);

  Future<AdminModel> getAdminById(int id);

  Future<bool> createNewClass(ClassModel model);

  Future<bool> addStudentToClass(StudentClassModel model);

  Future<bool> addTeacherToClass(TeacherClassModel model);

  Future<void> changeClassStatus(ClassModel classModel, String newStatus,
      ManageGeneralCubit cubit, BuildContext context);

  Future<void> updateClassInfo(ClassModel classModel);

  Future<void> updateLessonResult(int lessonId, int classId, String note);

  Future<void> updateCourseState(CourseModel courseModel, bool state);

  Future<void> updateCourseInfo(CourseModel courseModel);

  Future<TeacherHomeClass> getDataForManageClassTab();

  Future<List<FeedBackModel>> getListFeedBack(String status);

  Future<StudentModel> getStudentById(int studentId);

  Future<void> updateProfileStudent(String id, StudentModel model);

  Future<List<StudentClassModel>> getStudentClassByStdId(int studentId);

  Future<List<StudentLessonModel>> getStudentLessonByStdId(int studentId);

  Future<List<StudentTestModel>> getStudentTestByStdId(int studentId);

  //master

  Future<List<CourseModel>> getAllCourseEnable();

  Future<List<ClassModel>> getListClassForAdmin();

  Future<bool> addNewCourse(CourseModel model);

  Future<bool> addNewLesson(LessonModel model);

  Future<bool> addNewTest(TestModel model);

  Future<void> updateTestInfo(TestModel testModel);

  Future<void> addCourseFromJson(String json);

  Future<void> addLessonFromJson(String json);

  Future<void> addTestFromJson(String json);

  Future<void> deleteLesson(int lessonId, int courseId);

  Future<void> deleteTest(int testId, int courseId);
}
