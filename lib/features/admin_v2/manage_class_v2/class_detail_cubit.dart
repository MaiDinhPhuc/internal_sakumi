import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/calculator/calculator.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';

import 'class_cubit_v2.dart';

class ClassDetailCubit extends Cubit<int> {
  ClassDetailCubit(this.classModel, this.classCubit) : super(0) {
    loadData();
  }

  final ClassCubit classCubit;
  final ClassModel classModel;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;
  List<LessonModel>? lessons;
  List<StudentTestModel>? stdTests;

  String? title;
  int? lessonCount;
  String? lessonCountTitle;
  double? hwPercent, attendancePercent;
  String? lastLesson;
  List<int>? attChart, hwChart;
  List<double>? stds;

  loadData() async {
    DataProvider.courseById(classModel.courseId, onCourseLoaded);

    await DataProvider.stdClassByClassId(classModel.classId, loadStudentClass);

    if (classModel.customLessons.isEmpty) {
      await DataProvider.lessonByCourseId(
          classModel.courseId, loadLessonInClass);
    } else {
      await DataProvider.lessonByCourseAndClassId(
          classModel.courseId, classModel.classId, loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if (classModel.customLessons.isNotEmpty) {
        for (var i in classModel.customLessons) {
          if (!lessonId.contains(i['custom_lesson_id'])) {
            lessons!.add(LessonModel(
                lessonId: i['custom_lesson_id'],
                courseId: -1,
                description: i['description'],
                content: "",
                title: i['title'],
                btvn: -1,
                vocabulary: 0,
                listening: 0,
                kanji: 0,
                grammar: 0,
                flashcard: 0,
                alphabet: 0,
                order: 0,
                reading: 0,
                enable: true,
                customLessonInfo: i['lessons_info'],
                isCustom: true));
          }
        }
      }
    }

    await DataProvider.stdLessonByClassId(classModel.classId, loadStdLesson);

    await DataProvider.stdTestByClassId(classModel.classId, loadStdTest);

    emit(state + 1);

    await DataProvider.lessonResultByClassId(
        classModel.classId, loadLessonResult);

    await loadPercent();

    await loadStatistic();
  }

  loadStdTest(Object stdTests) {
    this.stdTests = stdTests as List<StudentTestModel>;
  }

  onCourseLoaded(Object course) {
    title =
        "${(course as CourseModel).name} ${(course).level} ${(course).termName}";
    lessonCount = course.lessonCount + classModel.customLessons.length;
    emit(state + 1);
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
    lessonCountTitle = "${this.lessonResults!.length}/$lessonCount";
    emit(state + 1);
  }

  loadStudentClass(Object studentClass) {
    stdClasses = studentClass as List<StudentClassModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
    emit(state + 1);
  }

  String getEvaluate(){
    int countDrop = 0;
    for (var i in stdClasses!) {
      if (i.classStatus == "Dropped" ||
          i.classStatus == "Deposit" ||
          i.classStatus == "Retained" ||
          i.classStatus == "Moved") {
        countDrop++;
      }
    }
    double Z = (countDrop / stdClasses!.length) * 10;

    List<int> listStdId = [];
    for(var i in stdClasses!){
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" && i.classStatus != "Viewer") {
        listStdId.add(i.userId);
      }
    }

    double sum = 0;

    for(var i in listStdId){
      var stdLessons = this.stdLessons!
          .where((e) => e.studentId == i)
          .toList();
      var stdTests = this.stdTests!
          .where((e) => e.studentId == i)
          .toList();
      var stdClassModel = stdClasses!.firstWhere((e) => e.userId == i);

      double X = Calculator.getStudentAttendancePercent(stdLessons) * 10;
      double Y = Calculator.getStudentHwPercent(stdLessons, lessons!) * 10;
      double Z1 = Calculator.getGPAPoint(stdLessons, lessons!) == null ? 10 : Calculator.getGPAPoint(stdLessons, lessons!)!;
      double Z2 = Calculator.getStdTestPoint(stdTests);
      double Z3 = Calculator.convertToPoint(stdClassModel.learningStatus);
      double Z4 = Calculator.convertToPoint(stdClassModel.activeStatus);

      double Z = (Z1+Z2+Z3+Z4)/4;

      double R = (X+Y+Z)/3;

      while(R - min(X, min(Y,Z)) > 2){
        R = R - 1;
      }

      sum = sum+R;
    }

    double result = sum/listStdId.length;

    double Q = result - Z;

    if(Q >= 8.5) return "A";

    if(Q >= 7) return "B";

    if(Q >= 5.5) return "C";

    if(Q >= 4) return "D";

    if(Q >= 2) return "E";

    return "F";

  }

  loadPercent() async {
    await Future.delayed(const Duration(milliseconds: 500));

    attendancePercent =
        Calculator.classAttendancePercent(stdClasses!, stdLessons!, lessons!);
    hwPercent =
        Calculator.classHwPercent(stdClasses!, stdLessons!, lessons!);

    var lastLesson =
        lessons!.firstWhere((e) => e.lessonId == lessonResults!.last.lessonId);
    this.lastLesson = lastLesson.title;

    emit(state + 1);
  }

  loadStatistic() async {
    var listStatus = stdClasses!.map((e) => e.classStatus).toList();
    List<int> listLessonId = [];
    for (var i in lessonResults!) {
      if (listLessonId.contains(i.lessonId) == false) {
        listLessonId.add(i.lessonId);
      }
    }
    double col1 = 0;
    double col2 = 0;
    double col3 = 0;
    double col4 = 0;
    double col5 = 0;
    for (var i in listStatus) {
      if (i == "Completed" || i == "InProgress" || i == "ReNew") {
        col1++;
      }
      if (i == "Viewer") {
        col2++;
      }
      if (i == "UpSale" || i == "Force") {
        col4++;
      }
      if (i == "Moved") {
        col3++;
      }
      if (i == "Retained" || i == "Dropped" || i == "Deposit") {
        col5++;
      }
    }
    List<double> stds = [col1, col2, col3, col4, col5];

    List<int> attChart = [];
    List<int> hwChart = [];
    for (var i in listLessonId) {
      List<StudentLessonModel> listTemp = stdLessons!
          .where((e) => e.lessonId == i && e.timekeeping != 0)
          .toList();
      int att = 0;
      int hw = 0;
      for (var j in listTemp) {
        if (j.timekeeping < 5) {
          att++;
        }
        if (j.hw != -2) {
          hw++;
        }
      }
      attChart.add(att);
      hwChart.add(hw);
    }
    this.attChart = attChart;
    this.hwChart = hwChart;
    this.stds = stds;
  }
}
