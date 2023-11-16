import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';

class GradingCubit extends Cubit<int> {
  GradingCubit() : super(0);

  ClassModel? classModel;

  List<StudentModel>? students;

  List<LessonModel>? lessons;
  List<StudentLessonModel>? listStudentLessons;
  List<LessonResultModel>? listLessonResult;

  List<TestResultModel>? listTestResult;
  List<StudentTestModel>? listStudentTests;
  List<TestModel>? tests;

  bool isBTVN = true;
  bool isNotGrading = true;

  load(ClassModel2 model, DataCubit dataCubit) async {
    if (model.stdTests == null) {
      classModel = model.classModel;
      emit(state + 1);
      dataCubit.loadDataForGradingTab(model.classModel);
    } else {
      classModel = model.classModel;
      emit(state + 1);
      listStudentLessons = model.stdLessons;
      listLessonResult = model.lessonResults;
      List<int> listLessonId =
          listLessonResult!.map((e) => e.lessonId).toList();
      lessons = model.listLesson!
          .where((e) => listLessonId.contains(e.lessonId))
          .toList();
      listTestResult = model.testResults;
      listStudentTests = model.stdTests;
      List<int> listTestId = listTestResult!.map((e) => e.testId).toList();
      tests = model.listTest!.where((e) => listTestId.contains(e.id)).toList();
      List<String> listStatus = [
        "Remove",
        "Dropped",
        "Deposit",
        "Retained",
        "Moved"
      ];
      var listStdClass = model.stdClasses!
          .where((e) => !listStatus.contains(e.classStatus))
          .toList();
      var listStdIds = listStdClass.map((e) => e.userId).toList();
      students =
          model.students!.where((e) => listStdIds.contains(e.userId)).toList();
      emit(state + 1);
    }
  }


  String getTestTime(int stdId, int testId) {
    var stdLesson = listStudentTests!
        .where((e) => e.studentId == stdId && e.testID == testId).toList();
    if(stdLesson.isEmpty){
      return "";
    }
    if (stdLesson.first.doingTime == "") {
      return "";
    }
    int seconds = int.parse(stdLesson.first.doingTime);

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }


  int getTestPoint(int stdId, int testId) {
    var stdTest = listStudentTests!
        .where((e) => e.studentId == stdId && e.testID == testId).toList();
    if(stdTest.isEmpty){
      return -2;
    }
    if (stdTest.first.score == -2) {
      return -2;
    }
    if (stdTest.first.score == -1) {
      return -1;
    }

    return stdTest.first.score;
  }

  String getBTVNTime(int stdId, int lessonId) {
    var stdLesson = listStudentLessons!
        .where((e) => e.studentId == stdId && e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return "";
    }
    if (stdLesson.first.doingTime == "") {
      return "";
    }
    int seconds = int.parse(stdLesson.first.doingTime);

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  int getBTVNPoint(int stdId, int lessonId) {
    var stdLesson = listStudentLessons!
        .where((e) => e.studentId == stdId && e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return -2;
    }
    if (stdLesson.first.hw == -2) {
      return -2;
    }
    if (stdLesson.first.hw == -1) {
      return -1;
    }

    return stdLesson.first.hw;
  }

  update() {
    emit(state + 2);
  }

  int getBTVNResultCount(int lessonId, int type) {
    int temp = 0;
    if (type == 1) {
      for (var i in listStudentLessons!) {
        if (i.hw != -2 && i.lessonId == lessonId) {
          temp++;
        }
      }
    } else {
      for (var i in listStudentLessons!) {
        if (i.hw > -1 && i.lessonId == lessonId) {
          temp++;
        }
      }
    }
    return temp;
  }

  int getTestResultCount(int testId, int type) {
    int temp = 0;
    if (type == 1) {
      for (var i in listStudentTests!) {
        if (i.score != -2 && i.testID == testId) {
          temp++;
        }
      }
    } else {
      for (var i in listStudentTests!) {
        if (i.score > -1 && i.testID == testId) {
          temp++;
        }
      }
    }

    return temp;
  }

  List<LessonResultModel> filterListLesson() {
    List<LessonResultModel> list = [];
    if (isNotGrading) {
      for (var i in listLessonResult!) {
        if (getBTVNResultCount(i.lessonId, 1) !=
            getBTVNResultCount(i.lessonId, 0)) {
          list.add(i);
        }
      }
    } else {
      for (var i in listLessonResult!) {
        if (getBTVNResultCount(i.lessonId, 1) ==
            getBTVNResultCount(i.lessonId, 0)) {
          list.add(i);
        }
      }
    }
    return list;
  }

  List<TestResultModel> filterListTest() {
    List<TestResultModel> list = [];
    if (isNotGrading) {
      for (var i in listTestResult!) {
        if (getTestResultCount(i.testId, 0) != getTestResultCount(i.testId, 1) ) {
          list.add(i);
        }
      }
    } else {
      for (var i in listTestResult!) {
        if (getTestResultCount(i.testId, 0) == getTestResultCount(i.testId, 1)) {
          list.add(i);
        }
      }
    }
    return list;
  }
}
