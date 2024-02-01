import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class StudentInfoCubit extends Cubit<int> {
  StudentInfoCubit() : super(0);

  StudentModel? student;
  UserModel? user;

  List<StudentClassModel>? stdClasses;
  List<ClassModel>? classes;
  List<CourseModel> courses = [];
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonResultModel>? lessonResults;
  List<int> listCourseIds = [];

  bool inJapan = false;
  String name = "";
  String stdCode = "";
  String phone = "";
  String note = "";
  bool isLoading = true;
  loadStudent(int studentId) async {
    await DataProvider.studentById(studentId, loadStudentInfo);
    await DataProvider.userById(studentId, loadUserInfo);
    inJapan = student!.inJapan;
    name = student!.name;
    stdCode = student!.studentCode;
    phone = student!.phone;
    note = student!.note;
    emit(state + 1);
    loadInFoStudentInSystem(studentId);
  }

  loadStudentInfo(Object student) {
    this.student = student as StudentModel;
  }

  loadUserInfo(Object user) {
    this.user = user as UserModel;
  }

  onCourseLoaded(Object course) {
    courses.add(course as CourseModel);
    if(courses.length == listCourseIds.length){
      emit(state + 1);
    }
  }


  loadInFoStudentInSystem(int studentId) async {
    stdClasses = await FireBaseProvider.instance.getStudentClassByStdId(studentId);
    var listClassId = stdClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassForTeacher(listClassId);
    for (var i in classes!) {
      if (listCourseIds.contains(i.courseId) == false) {
        DataProvider.courseById(i.courseId, onCourseLoaded);
        listCourseIds.add(i.courseId);
      }
    }

    stdLessons =
        await FireBaseProvider.instance.getStudentLessonByStdId(studentId);
    stdTests = await FireBaseProvider.instance.getStudentTestByStdId(studentId);
    lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(listClassId);

    isLoading = false;
    emit(state + 1);
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
