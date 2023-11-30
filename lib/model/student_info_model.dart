import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';

import 'class_model.dart';
import 'course_model.dart';
import 'lesson_result_model.dart';

class StudentInfoModel {
  StudentClassModel? stdClass;
  ClassModel? classModel;
  CourseModel? courseModel;
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;

  static Future<List<StudentInfoModel>> loadInfo(
    List<StudentClassModel> stdClasses,
    List<ClassModel> classes,
    List<CourseModel>? courses,
    List<StudentLessonModel>? stdLessons,
    List<StudentTestModel>? stdTests,
    List<LessonResultModel>? lessonResults,
    List<LessonModel>? lessons,
  ) async {
    List<StudentInfoModel> results = [];
    for (var classModel in classes) {
      var stdClass =
          stdClasses.firstWhere((e) => e.classId == classModel.classId);
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
      results.add(StudentInfoModel(
          courseModel: course,
          stdClass: stdClass,
          lessonResults: lessonResult,
          stdLessons: stdLesson,
          classModel: classModel,
          stdTests: stdTest,
          lessons: listLesson));
    }

    return results;
  }

  Color getColor() {
    switch (stdClass!.classStatus) {
      case 'Completed':
      case 'Moved':
        return const Color(0xffF57F17);
      case 'Retained':
      case 'UpSale':
        return const Color(0xffE65100);
      case 'ReNew':
      case 'Dropped':
      case 'Remove':
        return const Color(0xffB71C1C);
      case 'Viewer':
        return const Color(0xff757575);
      case 'Deposit':
        return Colors.black;
      case 'Force':
        return Colors.blue;
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon() {
    if (stdClass == null) {
      return "in_progress";
    }
    switch (stdClass!.classStatus) {
      case 'Completed':
        return 'check';
      case 'Moved':
        return 'moved';
      case 'Retained':
        return 'retained';
      case 'Dropped':
      case 'Deposit':
      case 'Remove':
        return 'dropped';
      case 'Viewer':
        return 'viewer';
      case 'UpSale':
      case "Force":
        return 'up_sale';
      case 'ReNew':
        return 're_new';
      default:
        return 'in_progress';
    }
  }

  double getLessonPercent() {
    double lessonPercent = lessonResults == null || courseModel == null
        ? 0
        : (lessonResults!.length / courseModel!.lessonCount);

    return lessonPercent;
  }

  double getAttendancePercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
        temp1++;
      }
      if (i.timekeeping != 0) {
        temp2++;
      }
    }
    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getHwPercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if (i.hw != -2 && i.timekeeping != 0) {
        temp1++;
      }
      if (i.timekeeping != 0) {
        temp2++;
      }
    }
    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  StudentLessonModel? getStudentLesson(int lessonId) {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return null;
    }

    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    return stdLesson.isEmpty ? null : stdLesson.first;
  }

  String getTitle(int lessonId) {
    if (lessons == null) {
      return "";
    }

    var lesson = lessons!.firstWhere((e) => e.lessonId == lessonId);

    return lesson.title;
  }

  StudentInfoModel(
      {this.stdTests,
      this.stdLessons,
      this.stdClass,
      this.lessonResults,
      this.courseModel,
      this.classModel,
      this.lessons});
}
