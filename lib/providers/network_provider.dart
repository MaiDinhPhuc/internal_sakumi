import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
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
import 'package:internal_sakumi/screens/login_screen.dart';

abstract class NetworkProvider {

  //user
  Future<bool> logInUser(TextEditingController email,
      TextEditingController password, BuildContext context, ErrorCubit cubit);

  Future<bool> logOutUser(BuildContext context);

  Future<bool> autoLogInUser(String email, BuildContext context);

  Future<bool> changePassword(String email, String oldPass, String newPass);

  Future<String> uploadImageAndGetUrl(Uint8List data, String folder);

  Future<StudentModel> getStudentInfo(int userId);

  Future<UserModel> getUser(String email);

  Future<UserModel> getUserById(int id);

  Future<void> saveUser(String email, String role, int uid);

  Future<List<UserModel>> getAllUser();

  Future<bool> createNewStudent(StudentModel model, UserModel user);

  Future<bool> createNewTeacher(TeacherModel model, UserModel user);

  //Teacher
  Future<TeacherModel> getTeacherByTeacherCode(String teacherCode);

  Future<TeacherModel> getTeacherById(int id);

  Future<List<TeacherClassModel>> getTeacherClassById(String string, int id);

  Future<List<TeacherClassModel>> getTeacherClassByStatus(int id, String status);

  Future<List<LessonModel>> getLessonsByCourseId(int id);

  Future<List<LessonModel>> getAllLesson();

  Future<ClassModel> getClassById(int id);

  Future<CourseModel> getCourseById(int id);

  Future<List<LessonResultModel>> getLessonResultByClassId(int id);

  Future<List<LessonResultModel>> getAllLessonResult();

  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(int classId, int lessonId);

  Future<LessonResultModel> getLessonResultByLessonId(int id, int classId);

  Future<List<CourseModel>> getAllCourse();

  Future<List<QuestionModel>> getQuestionByUrl(String url);

  Future<List<StudentClassModel>> getStudentClassInClass(int classId);

  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(int classId);

  Future<List<AnswerModel>> getListAnswer(int id, int classId);

  Future<List<StudentLessonModel>> getAllStudentLessons();

  Future<LessonModel> getLesson(int courseId, int lessonId);

  Future<void> updateTimekeeping(int userId, int lessonId, int classId, int attendId);

  Future<void> updateTeacherNote(int userId, int lessonId, int classId, String note);

  Future<void> updateStudentStatus(int userId, int classId, int point, String type);

  Future<void> changeStatusLesson(int lessonId, int classId, String status);

  Future<void> noteForAllStudentInClass(int lessonId, int classId, String note);

  Future<void> updateTeacherInLessonResult(int lessonId, int classId, int studentId);

  Future<void> noteForSupport(int lessonId, int classId, String note);

  Future<void> noteForAnotherSensei(int lessonId, int classId, String note);

  Future<bool> addStudentLesson(StudentLessonModel model);

  Future<bool> checkLessonResult(int lessonId, int classId);

  Future<bool> addLessonResult(LessonResultModel model);

  Future<void> updateProfileTeacher(String id, TeacherModel model);

  Future<List<TestModel>> getListTestByCourseId(int courseId);

  Future<List<StudentTestModel>> getListStudentTest(int classId, int testId);

  Future<List<StudentTestModel>> getAllStudentTest(int classId);

  Future<List<TestResultModel>> getListTestResult(int classId);

  //admin
  Future<List<ClassModel>> getListClassNotRemove();

  Future<List<ClassModel>> getAllClass();

  Future<List<StudentClassModel>> getAllStudentInClass();

  Future<List<TeacherClassModel>> getAllTeacherInClass();

  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(int classId);

  Future<List<StudentModel>> getAllStudent();

  Future<List<TeacherModel>> getAllTeacher();

  Future<List<TagModel>> getTags();

  Future<AdminModel> getAdminById(int id);

  Future<CourseModel> getCourseByName(String title, String term);

  Future<bool> createNewClass(ClassModel model);

  Future<bool> addStudentToClass(StudentClassModel model);

  Future<bool> addTeacherToClass(TeacherClassModel model);

  Future<void> changeClassStatus(ClassModel classModel,String newStatus,ManageGeneralCubit cubit, BuildContext context);

  Future<void> updateClassInfo(ClassModel classModel);
}
