import 'dart:html';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherCubit extends Cubit<int> {
  TeacherCubit() : super(0);

  TeacherModel? teacherProfile;
  List<ClassModel>? listClass;
  List<CourseModel>? courses;
  List<int>? listStatus, listStudentInClass;
  List<List<int>>? listSubmit, listAttendance;
  List<List<double>>? listPoint;
  List<double>? rateAttendance, rateSubmit;

  void init(context) async {
    await loadProfileTeacher(context);
    await loadListClassOfTeacher(context);
    await loadStatisticClass(context);
  }

  loadProfileTeacher(context) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    teacherProfile = await teacherRepository.getTeacher(TextUtils.getName());
        //.getTeacher(localData.getString(PrefKeyConfigs.code)!);
    emit(state + 1);
  }

  loadListClassOfTeacher(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    List<TeacherClassModel> listTeacherClass = [];
    List<ClassModel> listAllClass = [];
    List<CourseModel> listAllCourse = [];
    SharedPreferences localData = await SharedPreferences.getInstance();

    listTeacherClass = await teacherRepository.getTeacherClassById(
        'user_id', teacherProfile!.userId);

    listAllCourse = await adminRepository.getAllCourse();

    listAllClass = await adminRepository.getListClass();

    listClass = [];
    for (var i in listTeacherClass) {
      for (var j in listAllClass) {
        if (i.classId == j.classId) {
          listClass!.add(j);
          break;
        }
      }
    }

    courses = [];
    listStatus = [];
    for (var i in listClass!) {
      var temp = await teacherRepository.getLessonResultByClassId(i.classId);
      listStatus!
          .add(temp.where((e) => e.status == 'Complete').toList().length);
      for (var j in listAllCourse) {
        if (i.courseId == j.courseId) {
          courses!.add(j);
          break;
        }
      }
    }
    emit(state + 1);
  }

  loadStatisticClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    AdminRepository adminRepository = AdminRepository.fromContext(context);

    listSubmit = [];
    listAttendance = [];
    listStudentInClass = [];
    listPoint = [];
    rateSubmit = [];
    rateAttendance = [];
    var listAllStudent = await adminRepository.getAllStudentInClass();
    var listAllStudentLessons = await teacherRepository.getAllStudentLessons();
    for (var i in listClass!) {
      int studentsInClass = listAllStudent.fold(
          0, (pre, e) => pre + ((i.classId == e.classId) ? 1 : 0));
      List<StudentLessonModel> lessonsInClass = listAllStudentLessons
          .fold([], (pre, e) => [...pre, if (e.classId == i.classId) e]);
      listStudentInClass!.add(studentsInClass);
      debugPrint(
          '============> student in class ${listStudentInClass![listClass!.indexOf(i)]}');
      List<int> attends = [];
      List<int> homeworks = [];
      List<double> points = [];
      double pts = 0.0;
      int att = 0, sub = 0;
      for (var j = 1; j <= courses![listClass!.indexOf(i)].lessonCount; j++) {
        debugPrint('============> lesson $j');
        var attendance = lessonsInClass.fold(
            0,
            (pre, e) =>
                pre + ((e.timekeeping > 0 && e.timekeeping < 5 && e.lessonId == j) ? 1 : 0));

        var hw = lessonsInClass
            .fold(0, (pre, e) => pre + ((e.hw > -2 && e.lessonId == j) ? 1 : 0));

        var point = lessonsInClass
            .fold(0, (pre, e) => pre + ((e.hw > -1 && e.lessonId == j) ? e.hw : 0));

        att = att + attendance;
        sub = sub + hw;
        pts = pts + point;
        attends.add(attendance);
        homeworks.add(hw);
        points.add(point/listStudentInClass![listClass!.indexOf(i)]);
        //pts.add(point / ((listStudentInClass!.length * ) / 10));
      }
      debugPrint('=----= $attends ==== $homeworks');

      rateAttendance!.add(att /
          (listStudentInClass![listClass!.indexOf(i)] *
              courses![listClass!.indexOf(i)].lessonCount));
      rateSubmit!.add(sub /
          (listStudentInClass![listClass!.indexOf(i)] *
              courses![listClass!.indexOf(i)].lessonCount));
      listAttendance!.add(attends);
      listSubmit!.add(homeworks);
      listPoint!.add(points);
    }

    debugPrint(
        '==============> loadStatisticClass $rateSubmit == ${listStudentInClass!.length}');

    print(
        '==========><========== $listAttendance === $listSubmit == $rateAttendance === $rateSubmit === $listPoint');
    emit(state + 1);
  }
}
