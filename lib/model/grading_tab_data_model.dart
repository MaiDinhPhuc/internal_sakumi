import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';

import 'class_model.dart';
import 'lesson_model.dart';
import 'lesson_result_model.dart';

class GradingTabDataModel {
  ClassModel classModel;

  List<LessonModel> lessons;
  List<StudentLessonModel> listStudentLessons;
  List<LessonResultModel> listLessonResult;

  List<TestResultModel> listTestResult;
  List<StudentTestModel> listStudentTests;
  List<TestModel> tests;

  GradingTabDataModel(
      {required this.classModel,
      required this.lessons,
      required this.listStudentLessons,
      required this.listLessonResult,
      required this.listTestResult,
      required this.listStudentTests,
      required this.tests});

  factory GradingTabDataModel.fromData(
      ClassModel classModel,
      List<LessonModel> lessons,
      List<StudentLessonModel> listStudentLessons,
      List<LessonResultModel> listLessonResult,
      List<TestResultModel> listTestResult,
      List<StudentTestModel> listStudentTests,
      List<TestModel> tests) {
    return GradingTabDataModel(
      classModel: classModel,
      lessons: lessons,
      listStudentLessons: listStudentLessons,
      listLessonResult: listLessonResult,
      listTestResult: listTestResult,
      listStudentTests: listStudentTests,
      tests: tests,
    );
  }
}
