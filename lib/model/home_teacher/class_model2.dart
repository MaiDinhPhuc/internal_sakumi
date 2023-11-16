import 'dart:ui';

import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';

class ClassModel2 {
  final ClassModel classModel;
  final int? lessonCount;
  final CourseModel? course;
  final List<LessonModel>? listLesson;
  final List<StudentClassModel>? stdClasses;
  final List<LessonResultModel>? lessonResults;
  final List<StudentLessonModel>? stdLessons;
  final List<StudentTestModel>? stdTests;
  final List<TestModel>? listTest;
  final List<TestResultModel>? testResults;
  final List<StudentModel>? students;

  ClassModel2 copyWith(
      {ClassModel? classModel,
      CourseModel? course,
      int? lessonCount,
      List<LessonModel>? listLesson,
      List<StudentClassModel>? stdClasses,
      List<LessonResultModel>? lessonResults,
      List<StudentLessonModel>? stdLessons,
      List<StudentTestModel>? stdTests,
      List<TestModel>? listTest,
      List<TestResultModel>? testResults, List<StudentModel>? students}) {
    return ClassModel2(
        course: course ?? this.course,
        listLesson: listLesson ?? this.listLesson,
        stdClasses: stdClasses ?? this.stdClasses,
        lessonResults: lessonResults ?? this.lessonResults,
        stdLessons: stdLessons ?? this.stdLessons,
        classModel: classModel ?? this.classModel,
        lessonCount: lessonCount ?? this.lessonCount,
        listTest: listTest ?? this.listTest,
        stdTests: stdTests ?? this.stdTests,
        testResults: testResults ?? this.testResults,
        students: students ?? this.students
    );
  }

  static Future<List<ClassModel2>> loadClass(
    List<ClassModel> classes,
  ) async {
    List<ClassModel2> results = [];
    for (var classModel in classes) {
      results.add(ClassModel2(
        course: null,
        listLesson: null,
        stdClasses: null,
        lessonResults: null,
        stdLessons: null,
        lessonCount: null,
        classModel: classModel,
        listTest: null,
        stdTests: null,
        testResults: null,
        students: null
      ));
    }

    return results;
  }

  Color getColor() {
    switch (classModel.classStatus) {
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
    switch (classModel.classStatus) {
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

  ClassModel2(
      {required this.course,
      required this.listLesson,
      required this.stdClasses,
      required this.lessonResults,
      required this.stdLessons,
      required this.classModel,
      required this.lessonCount,
      required this.listTest,
      required this.stdTests,
      required this.testResults,
      required this.students});
}
