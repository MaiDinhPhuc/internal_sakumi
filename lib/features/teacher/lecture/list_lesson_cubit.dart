import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ListLessonCubit extends Cubit<int> {
  ListLessonCubit() : super(0);

  List<LessonResultModel>? listLessonResult;

  ClassModel? classModel;

  List<LessonModel>? lessons;

  List<List<StudentLessonModel>>? listStudentLessons;

  List<StudentClassModel>? listStudentClass;

  List<int>? listAttendance, listSubmitHomework, listNotMarked;

  List<StudentModel>? listStudent;

  init(context) async {
    await loadClass(context);
    await loadLessonResult(context);
    await loadStudentLesson(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    classModel =
        await teacherRepository.getClassById(int.parse(TextUtils.getClassId()));
    emit(state + 1);
  }

  loadLessonResult(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    listLessonResult = await teacherRepository
        .getLessonResultByClassId(int.parse(TextUtils.getClassId()));

    lessons =
        await teacherRepository.getLessonsByCourseId(classModel!.courseId);

    emit(state + 1);
  }

  loadStudentLesson(context) async {
    listAttendance = [];
    listSubmitHomework = [];
    listNotMarked = [];
    listStudentClass = [];
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    List<StudentLessonModel>? listAllStudentLesson = await teacherRepository
        .getAllStudentLessonsInClass(int.parse(TextUtils.getName()));

    AdminRepository adminRepository = AdminRepository.fromContext(context);

    listStudentClass = await adminRepository
        .getStudentClassByClassId(int.parse(TextUtils.getName()));

    listStudentLessons = [];
    for (var i in listLessonResult!) {
      List<StudentLessonModel> list = listAllStudentLesson!.fold(
          <StudentLessonModel>[],
          (pre, e) => [...pre, if (i.lessonId == e.lessonId) e]).toList();

      listStudentLessons!.add(list);

      var attendance = listAllStudentLesson!.fold(
          <int>[],
          (pre, e) => [
                ...pre,
                if (e.timekeeping > 0 &&
                    e.timekeeping < 5 &&
                    i.lessonId == e.lessonId)
                  e.timekeeping
              ]).toList();

      var submit = listAllStudentLesson!.fold(
          <int>[],
          (pre, e) => [
                ...pre,
                if (e.hw > -2 && e.lessonId == i.lessonId) e.hw
              ]).toList();

      var notMarked = listAllStudentLesson!.fold(
          <int>[],
          (pre, e) => [
                ...pre,
                if (e.hw > -1 && e.lessonId == i.lessonId) e.hw
              ]).toList();

      listSubmitHomework!.add(submit.length);
      listNotMarked!.add(notMarked.length);
      listAttendance!.add(attendance.length);
    }

    emit(state + 1);
  }

  loadStudent(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);

    var list = await adminRepository.getAllStudent();

    listStudent = [];
    for (var i in list) {
      for (var j in listStudentClass!) {
        if (i.userId == j.userId) {
          listStudent!.add(i);
          break;
        }
      }
    }
    print("==============> test test ${listStudent!.first.userId}");
    emit(state + 1);
  }
}
