import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class GradingCubitV2 extends Cubit<int>{
  GradingCubitV2(this.classId):super(0){
    loadData();
  }

  final int classId;
  ClassModel? classModel;
  bool loading = false;

  List<StudentModel> students = [];
  List<StudentClassModel>? listStdClass;

  List<LessonModel>? lessons;
  List<StudentLessonModel>? listStudentLessons;
  List<LessonResultModel>? listLessonResult;

  List<TestResultModel>? listTestResult;
  List<StudentTestModel>? listStudentTests;
  List<TestModel>? tests;

  bool isBTVN = true;
  bool isNotGrading = true;

  loadData()async{
    classModel = await FireBaseProvider.instance.getClassById(classId);

    loading = true;
    emit(state+1);

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classId, loadLessonResult);

    await DataProvider.lessonByCourseId(classModel!.courseId, loadLessonInClass);

    await DataProvider.testByCourseId(classModel!.courseId, loadTestInClass);

    await DataProvider.testResultByClassId(classId, loadTestResultInClass);

    await DataProvider.stdTestByClassId(classId, loadStdTestInClass);

    var listStdId = this.listStdClass!.map((e) => e.userId).toList();
    for(var i in listStdId){
      DataProvider.studentById(i, loadStudentInfo);
    }

    List<int> listLessonId =
    listLessonResult!.map((e) => e.lessonId).toList();
    lessons = lessons!
        .where((e) => listLessonId.contains(e.lessonId))
        .toList();
    List<int> listTestId = listTestResult!.map((e) => e.testId).toList();
    tests =
        tests!.where((e) => listTestId.contains(e.id)).toList();
    List<String> listStatus = [
      "Remove",
      "Dropped",
      "Deposit",
      "Retained",
      "Moved"
    ];
    var listStdClass =  this.listStdClass!
        .where((e) => !listStatus.contains(e.classStatus))
        .toList();
    var listStdIds = listStdClass.map((e) => e.userId).toList();
    students = students
        .where((e) => listStdIds.contains(e.userId))
        .toList();

    loading = false;

    emit(state+1);
  }

  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    if(students.length == listStdClass!.length){
      emit(state+1);
    }
  }

  loadStdLesson(Object stdLessons) {
    listStudentLessons = stdLessons as List<StudentLessonModel>;
  }

  loadLessonResult(Object lessonResults) {
    listLessonResult = lessonResults as List<LessonResultModel>;
  }


  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadTestInClass(Object tests) {
    this.tests = tests as List<TestModel>;
  }

  loadTestResultInClass(Object testResults) {
    listTestResult = testResults as List<TestResultModel>;
  }
  loadStdTestInClass(Object stdTests) {
    listStudentTests = stdTests as List<StudentTestModel>;
  }

  String getTestTime(int stdId, int testId) {
    var stdTests = listStudentTests!
        .where((e) => e.studentId == stdId && e.testID == testId)
        .toList();
    if (stdTests.isEmpty) {
      return "";
    }
    if (stdTests.first.time.isEmpty) {
      return "";
    }
    int seconds = stdTests.first.time['time_test'];

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  String getNumberIgnoreTest(int stdId, int testId) {
    var stdTests = listStudentTests!
        .where((e) => e.studentId == stdId && e.testID == testId)
        .toList();
    if (stdTests.isEmpty) {
      return "";
    }
    if (stdTests.first.time.isEmpty) {
      return "";
    }
    int number = stdTests.first.time["skip_test"];

    return number.toString();
  }

  double getTestPoint(int stdId, int testId) {
    var stdTest = listStudentTests!
        .where((e) => e.studentId == stdId && e.testID == testId)
        .toList();
    if (stdTest.isEmpty) {
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
        .where((e) => e.studentId == stdId && e.lessonId == lessonId)
        .toList();
    if (stdLesson.isEmpty) {
      return "";
    }
    if (stdLesson.first.time.isEmpty) {
      return "";
    }
    int seconds = stdLesson.first.time["time_btvn"];

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  String getNumberIgnore(int stdId, int lessonId) {
    var stdLesson = listStudentLessons!
        .where((e) => e.studentId == stdId && e.lessonId == lessonId)
        .toList();
    if (stdLesson.isEmpty) {
      return "";
    }
    if (stdLesson.first.time.isEmpty) {
      return "";
    }
    int number = stdLesson.first.time["skip_btvn"];

    return number.toString();
  }

  dynamic getBTVNPoint(int stdId, int lessonId) {
    var stdLesson = listStudentLessons!
        .where((e) => e.studentId == stdId && e.lessonId == lessonId)
        .toList();
    if (stdLesson.isEmpty) {
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

  dynamic getBTVNResultCount(int lessonId, int type) {
    int temp = 0;
    var stdIds = students!.map((e) => e.userId).toList();

    var listStudentLesson =
    listStudentLessons!.where((e) => stdIds.contains(e.studentId));

    if (type == 1) {
      for (var i in listStudentLesson) {
        if (i.hw != -2 && i.lessonId == lessonId) {
          temp++;
        }
      }
    } else {
      for (var i in listStudentLesson) {
        if (i.hw > -1 && i.lessonId == lessonId) {
          temp++;
        }
      }
    }
    return temp;
  }

  dynamic getTestResultCount(int testId, int type) {
    int temp = 0;
    var stdIds = students!.map((e) => e.userId).toList();

    var listStudentTest =
    listStudentTests!.where((e) => stdIds.contains(e.studentId));
    if (type == 1) {
      for (var i in listStudentTest) {
        if (i.score != -2 && i.testID == testId) {
          temp++;
        }
      }
    } else {
      for (var i in listStudentTest) {
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
        if (getTestResultCount(i.testId, 0) !=
            getTestResultCount(i.testId, 1)) {
          list.add(i);
        }
      }
    } else {
      for (var i in listTestResult!) {
        if (getTestResultCount(i.testId, 0) ==
            getTestResultCount(i.testId, 1)) {
          list.add(i);
        }
      }
    }
    return list;
  }
}