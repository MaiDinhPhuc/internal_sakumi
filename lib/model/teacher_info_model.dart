import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';

import 'class_model.dart';
import 'course_model.dart';
import 'lesson_model.dart';
import 'lesson_result_model.dart';

class TeacherInfoModel {
  TeacherClassModel? teacherClass;
  ClassModel? classModel;
  CourseModel? courseModel;
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;
  List<StudentClassModel>? stdClasses;

  static Future<List<TeacherInfoModel>> loadInfo(
      List<TeacherClassModel> teacherClasses,
      List<ClassModel> classes,
      List<CourseModel>? courses,
      List<StudentLessonModel>? stdLessons,
      List<StudentTestModel>? stdTests,
      List<LessonResultModel>? lessonResults,
      List<LessonModel>? lessons,
      List<StudentClassModel>? stdClasses) async {
    List<TeacherInfoModel> results = [];
    for (var classModel in classes) {
      var listStdClass = stdClasses
          ?.where((element) =>
              element.classId == classModel.classId &&
              element.classStatus != "Remove" &&
              element.classStatus != "Moved" &&
              element.classStatus != "Retained" &&
              element.classStatus != "Dropped" &&
              element.classStatus != "Deposit" &&
              element.classStatus != "Viewer")
          .toList();
      var teacherClass =
          teacherClasses.firstWhere((e) => e.classId == classModel.classId);
      var course =
          courses?.firstWhere((e) => e.courseId == classModel.courseId);
      List<StudentLessonModel>? stdLesson =
          stdLessons?.where((e) => e.classId == classModel.classId).toList();
      List<StudentTestModel>? stdTest =
          stdTests?.where((e) => e.classId == classModel.classId).toList();
      List<LessonResultModel>? lessonResult =
          lessonResults?.where((e) => e.classId == classModel.classId).toList();
      List<LessonModel>? listLesson =
          lessons?.where((e) => e.courseId == classModel.courseId).toList();
      results.add(TeacherInfoModel(
          courseModel: course,
          teacherClass: teacherClass,
          lessonResults: lessonResult,
          stdLessons: stdLesson,
          classModel: classModel,
          stdTests: stdTest,
          lessons: listLesson, stdClasses: listStdClass));
    }

    return results;
  }

  Color getColor() {
    switch (classModel!.classStatus) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon() {
    switch (classModel!.classStatus) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }

  double getLessonPercent() {
    double lessonPercent = lessonResults == null || courseModel == null
        ? 0
        : (lessonResults!.length / courseModel!.lessonCount);

    return lessonPercent;
  }

  String getTitle(int lessonId) {
    if (lessons == null) {
      return "";
    }

    var lesson = lessons!.firstWhere((e) => e.lessonId == lessonId);

    return lesson.title;
  }

  double getAttendancePercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }

    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if(listStdId.contains(i.studentId)){
        if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }

    if (temp2 == 0) {
      return 0;
    }

    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getHwPercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if(listStdId.contains(i.studentId)){
        if (i.hw != -2 && i.timekeeping != 0) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }
    if (temp2 == 0) {
      return 0;
    }

    double hwPercent = temp1 / temp2;

    return hwPercent;
  }

  double getAttendanceForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();

    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }

    if (temp2 == 0) {
      return 0;
    }

    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getHwForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (i.hw != -2 && i.timekeeping != 0) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }
    if (temp2 == 0) {
      return 0;
    }

    double hwPercent = temp1 / temp2;

    return hwPercent;
  }

  TeacherInfoModel(
      {this.stdTests,
      this.stdLessons,
      this.teacherClass,
      this.lessonResults,
      this.courseModel,
      this.classModel,
      this.lessons,
      this.stdClasses});
}
