import 'dart:typed_data';

import 'package:flutter/Material.dart';
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
import 'package:internal_sakumi/providers/network_provider.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'firebase_authentication.dart';
import 'firestore_db.dart';

class FireBaseProvider extends NetworkProvider {
  FireBaseProvider._privateConstructor();

  static final FireBaseProvider instance =
      FireBaseProvider._privateConstructor();
  @override
  Future<bool> logInUser(
      TextEditingController email,
      TextEditingController password,
      BuildContext context,
      ErrorCubit cubit) async {
    return await FirebaseAuthentication.instance
        .logInUser(email, password, context, cubit);
  }

  @override
  Future<bool> logOutUser(BuildContext context) async {
    return await FirebaseAuthentication.instance.logOutUser(context);
  }

  @override
  Future<bool> autoLogInUser(String email, BuildContext context) async {
    return await FirebaseAuthentication.instance.autoLogInUser(email,context);
  }

  @override
  Future<bool> changePassword(String email, String oldPass, String newPass) async {
    return await FirebaseAuthentication.instance.changePassword(email, oldPass, newPass);
  }

  @override
  Future<String> uploadImageAndGetUrl(Uint8List data ,String folder) async {
    return await FirebaseAuthentication.instance.uploadImageAndGetUrl(data,folder);
  }

  @override
  Future<TeacherModel> getTeacherByTeacherCode(String teacherCode) async {
    return await FireStoreDb.instance.getTeacherByTeacherCode(teacherCode);
  }

  @override
  Future<TeacherModel> getTeacherById(int id) async {
    return await FireStoreDb.instance.getTeacherById(id);
  }

  @override
  Future<List<TeacherClassModel>> getTeacherClassById(String string, int id) async {
    return await FireStoreDb.instance.getTeacherClassById(string,id);
  }

  @override
  Future<List<TeacherClassModel>> getTeacherClassByStatus(int id, String status) async {
    return await FireStoreDb.instance.getTeacherClassByStatus(id,status);
  }

  @override
  Future<List<LessonModel>> getLessonsByCourseId(int id) async {
    return await FireStoreDb.instance.getLessonsByCourseId(id);
  }

  @override
  Future<List<LessonModel>> getAllLesson() async {
    return await FireStoreDb.instance.getAllLesson();
  }

  @override
  Future<ClassModel> getClassById(int id) async{
    return await FireStoreDb.instance.getClassById(id);
  }

  @override
  Future<CourseModel> getCourseById(int id) async {
    return await FireStoreDb.instance.getCourseById(id);
  }

  @override
  Future<List<LessonResultModel>> getLessonResultByClassId(int id) async {
    return await FireStoreDb.instance.getLessonResultByClassId(id);
  }

  @override
  Future<List<LessonResultModel>> getAllLessonResult() async {
    return await FireStoreDb.instance.getAllLessonResult();
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessonInLesson(int classId, int lessonId) async {
    return await FireStoreDb.instance.getAllStudentLessonInLesson(classId,lessonId);
  }

  @override
  Future<LessonResultModel> getLessonResultByLessonId(int id, int classId) async {
    return await FireStoreDb.instance.getLessonResultByLessonId(id,classId);
  }

  @override
  Future<List<CourseModel>> getAllCourse() async {
    return await FireStoreDb.instance.getAllCourse();
  }

  @override
  Future<List<QuestionModel>> getQuestionByUrl(String url) async {
    return await FireStoreDb.instance.getQuestionByUrl(url);
  }

  @override
  Future<List<StudentClassModel>> getStudentClassInClass(int classId) async {
    return await FireStoreDb.instance.getStudentClassInClass(classId);
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessonsInClass(int classId) async {
    return await FireStoreDb.instance.getAllStudentLessonsInClass(classId);
  }

  @override
  Future<List<AnswerModel>> getListAnswer(int id, int classId) async {
    return await FireStoreDb.instance.getListAnswer(id, classId);
  }

  @override
  Future<List<StudentLessonModel>> getAllStudentLessons() async {
    return await FireStoreDb.instance.getAllStudentLessons();
  }

  @override
  Future<LessonModel> getLesson(int courseId, int lessonId) async {
    return await FireStoreDb.instance.getLesson(courseId, lessonId);
  }

  @override
  Future<void> updateTimekeeping(int userId, int lessonId, int classId, int attendId) async{
    await FireStoreDb.instance.updateTimekeeping(userId, lessonId, classId, attendId);
  }

  @override
  Future<void> updateTeacherNote(int userId, int lessonId, int classId, String note) async {
    await FireStoreDb.instance.updateTeacherNote(userId, lessonId, classId, note);
  }

  @override
  Future<void> updateStudentStatus(int userId, int classId, int point, String type) async {
    await FireStoreDb.instance.updateStudentStatus(userId, classId, point, type);
  }

  @override
  Future<void> changeStatusLesson(int lessonId, int classId, String status) async {
    await FireStoreDb.instance.changeStatusLesson(lessonId, classId, status);
  }

  @override
  Future<void> noteForAllStudentInClass(int lessonId, int classId, String note) async {
    await FireStoreDb.instance.noteForAllStudentInClass(lessonId, classId, note);
  }

  @override
  Future<void> updateTeacherInLessonResult(int lessonId, int classId, int studentId) async {
    await FireStoreDb.instance.updateTeacherInLessonResult(lessonId, classId, studentId);
  }

  @override
  Future<void> noteForSupport(int lessonId, int classId, String note) async {
    await FireStoreDb.instance.noteForSupport(lessonId, classId, note);
  }

  @override
  Future<void> noteForAnotherSensei(int lessonId, int classId, String note) async {
    await FireStoreDb.instance.noteForAnotherSensei(lessonId, classId, note);
  }

  @override
  Future<bool> addStudentLesson(StudentLessonModel model) async {
    return await FireStoreDb.instance.addStudentLesson(model);
  }

  @override
  Future<bool> checkLessonResult(int lessonId, int classId) async {
    return await FireStoreDb.instance.checkLessonResult(lessonId, classId);
  }

  @override
  Future<bool> addLessonResult(LessonResultModel model) async {
    return await FireStoreDb.instance.addLessonResult(model);
  }

  @override
  Future<void> updateProfileTeacher(String id, TeacherModel model) async {
    await FireStoreDb.instance.updateProfileTeacher(id, model);
  }

  @override
  Future<List<TestModel>> getListTestByCourseId(int courseId) async {
    return await FireStoreDb.instance.getListTestByCourseId(courseId);
  }

  @override
  Future<List<StudentTestModel>> getListStudentTest(int classId, int testId) async {
    return await FireStoreDb.instance.getListStudentTest(classId, testId);
  }

  @override
  Future<List<StudentTestModel>> getAllStudentTest(int classId) async {
    return await FireStoreDb.instance.getAllStudentTest(classId);
  }

  @override
  Future<List<TestResultModel>> getListTestResult(int classId) async {
    return await FireStoreDb.instance.getListTestResult(classId);
  }

  @override
  Future<StudentModel> getStudentInfo(int userId) async {
    return await FireStoreDb.instance.getStudentInfo(userId);
  }

  @override
  Future<UserModel> getUser(String email) async {
    return await FireStoreDb.instance.getUser(email);
  }

  @override
  Future<UserModel> getUserById(int id) async {
    return await FireStoreDb.instance.getUserById(id);
  }

  @override
  Future<void> saveUser(String email, String role, int uid) async {
    return await FireStoreDb.instance.saveUser(email, role, uid);
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    return await FireStoreDb.instance.getAllUser();
  }

  @override
  Future<bool> createNewStudent(StudentModel model, UserModel user) async {
    return await FireStoreDb.instance.createNewStudent(model, user);
  }

  @override
  Future<bool> createNewTeacher(TeacherModel model, UserModel user) async {
    return await FireStoreDb.instance.createNewTeacher(model, user);
  }

  @override
  Future<List<ClassModel>> getListClassNotRemove() async {
    return await FireStoreDb.instance.getListClassNotRemove();
  }

  @override
  Future<List<ClassModel>> getAllClass() async {
    return await FireStoreDb.instance.getAllClass();
  }

  @override
  Future<List<StudentClassModel>> getAllStudentInClass() async {
    return await FireStoreDb.instance.getAllStudentInClass();
  }

  @override
  Future<List<TeacherClassModel>> getAllTeacherInClass() async {
    return await FireStoreDb.instance.getAllTeacherInClass();
  }

  @override
  Future<List<TeacherClassModel>> getAllTeacherInClassByClassId(int classId) async {
    return await FireStoreDb.instance.getAllTeacherInClassByClassId(classId);
  }

  @override
  Future<List<StudentModel>> getAllStudent() async {
    return await FireStoreDb.instance.getAllStudent();
  }

  @override
  Future<List<TeacherModel>> getAllTeacher() async {
    return await FireStoreDb.instance.getAllTeacher();
  }

  @override
  Future<List<TagModel>> getTags() async {
    return await FireStoreDb.instance.getTags();
  }

  @override
  Future<AdminModel> getAdminById(int id) async {
    return await FireStoreDb.instance.getAdminById(id);
  }

  @override
  Future<CourseModel> getCourseByName(String title, String term) async {
    return await FireStoreDb.instance.getCourseByName(title, term);
  }

  @override
  Future<bool> createNewClass(ClassModel model) async {
    return await FireStoreDb.instance.createNewClass(model);
  }

  @override
  Future<bool> addStudentToClass(StudentClassModel model) async {
    return await FireStoreDb.instance.addStudentToClass(model);
  }

  @override
  Future<bool> addTeacherToClass(TeacherClassModel model) async {
    return await FireStoreDb.instance.addTeacherToClass(model);
  }

  @override
  Future<void> changeClassStatus(ClassModel classModel, String newStatus, ManageGeneralCubit cubit, BuildContext context) async {
    await FireStoreDb.instance.changeClassStatus(classModel,newStatus,cubit, context);
  }

  @override
  Future<void> updateClassInfo(ClassModel classModel) async {
    await FireStoreDb.instance.updateClassInfo(classModel);
  }


}
