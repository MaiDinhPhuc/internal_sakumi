import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
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

    await DataProvider.lessonByCourseId(classModel.courseId, loadLessonInClass);

    await DataProvider.stdLessonByClassId(classModel.classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(
        classModel.classId, loadLessonResult);

    await loadPercent();

    await loadStatistic();
  }

  onCourseLoaded(Object course) {
    title =
    "${(course as CourseModel).name} ${(course).level} ${(course).termName}";
    lessonCount = course.lessonCount;
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
    emit(state + 1);
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
    emit(state + 1);
  }

  loadPercent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<int> listStdIdsEnable = [];

    for (var element in stdClasses!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }


    var stdLessons = this.stdLessons!
        .where(
            (e) => listStdIdsEnable.contains(e.studentId) && e.timekeeping != 0)
        .toList();

    double attendancePercent = 0;
    double hwPercent = 0;
    List<LessonModel> lessonTemp =
    lessons!.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    int count = stdLessons
        .where((element) => element.timekeeping != 0)
        .toList()
        .length;
    int countHw = 0;
    double attendanceTemp = 0;
    double hwPercentTemp = 0;
    for (var i in stdLessons) {
      if (i.timekeeping < 5) {
        attendanceTemp++;
      }
      if (lessonExceptionIds.contains(i.lessonId) == false) {
        countHw++;
        if (i.hw != -2) {
          hwPercentTemp++;
        }
      }
    }
    attendancePercent = attendanceTemp / (count == 0 ? 1 : count);
    hwPercent = hwPercentTemp / (countHw == 0 ? 1 : countHw);
    this.attendancePercent = attendancePercent;
    this.hwPercent = hwPercent;

    var lastLesson = lessons!.firstWhere((e) =>
    e.lessonId == lessonResults!.last.lessonId);
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
      if (i == "Completed" ||
          i == "InProgress" ||
          i == "ReNew") {
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
      if (i == "Retained" ||
          i == "Dropped" ||
          i == "Deposit") {
        col5++;
      }
    }
    List<double> stds = [col1, col2, col3, col4, col5];

    List<int> attChart = [];
    List<int> hwChart = [];
    for (var i in listLessonId) {
      List<StudentLessonModel> listTemp = stdLessons!.where((e) =>
      e.lessonId == i && e.timekeeping != 0).toList();
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