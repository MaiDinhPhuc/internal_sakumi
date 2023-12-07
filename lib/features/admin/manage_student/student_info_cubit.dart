import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_info_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class StudentInfoCubit extends Cubit<int> {
  StudentInfoCubit() : super(0);

  StudentModel? student;
  UserModel? user;

  List<StudentClassModel>? stdClasses;
  List<ClassModel>? classes;
  List<CourseModel>? courses;
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;

  List<StudentInfoModel>? listStdInfo;


  bool inJapan = false;
  String name = "";
  String stdCode = "";
  String phone = "";
  String note = "";
  loadStudent(int studentId,SearchCubit searchController) async {
    if(searchController.students!=null){
      student = searchController.students!.firstWhere((e) => e.userId == studentId);
      user = searchController.users!.firstWhere((e) => e.id == studentId);
    }else{
      student = await FireBaseProvider.instance.getStudentById(studentId);
      user = await FireBaseProvider.instance.getUserById(studentId);
    }
    inJapan = student!.inJapan;
    name = student!.name;
    stdCode = student!.studentCode;
    phone = student!.phone;
    note = student!.note;
    emit(state + 1);
    loadInFoStudentInSystem(studentId);
  }

  loadInFoStudentInSystem(int studentId) async {
    stdClasses =
        await FireBaseProvider.instance.getStudentClassByStdId(studentId);
    var listClassId = stdClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassForTeacher(listClassId);
    listStdInfo = await StudentInfoModel.loadInfo(stdClasses!,classes!,courses,stdLessons,stdTests,lessonResults,lessons);
    emit(state+1);
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.courseId) == false) {
        listCourseIds.add(i.courseId);
      }
    }
    courses = await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    listStdInfo = await StudentInfoModel.loadInfo(stdClasses!,classes!,courses,stdLessons,stdTests,lessonResults,lessons);
    emit(state+1);
    stdLessons = await FireBaseProvider.instance.getStudentLessonByStdId(studentId);
    stdTests = await FireBaseProvider.instance.getStudentTestByStdId(studentId);
    lessonResults = await FireBaseProvider.instance.getLessonsResultsByListClassIds(listClassId);
    listStdInfo = await StudentInfoModel.loadInfo(stdClasses!,classes!,courses,stdLessons,stdTests,lessonResults,lessons);
    emit(state+1);
    lessons = await FireBaseProvider.instance.getLessonsByListCourseId(listCourseIds);
    listStdInfo = await StudentInfoModel.loadInfo(stdClasses!,classes!,courses,stdLessons,stdTests,lessonResults,lessons);
    emit(state+1);
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email);
      debugPrint('Password reset email sent successfully.');
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
    }
  }

  updateCheck() {
    inJapan = !inJapan;
    emit(state + 1);
  }

  changeNote(String newValue) {
    note = newValue;
    emit(state + 1);
  }

  changePhone(String newValue) {
    phone = newValue;
    emit(state + 1);
  }

  changeStdCode(String newValue) {
    stdCode = newValue;
    emit(state + 1);
  }

  changeName(String newValue) {
    name = newValue;
    emit(state + 1);
  }
}
