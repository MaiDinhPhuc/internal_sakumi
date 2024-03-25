import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';

class Calculator{

  static double classAttendancePercent(List<StudentClassModel> stdClasses, List<StudentLessonModel> listStdLesson, List<LessonModel> listLesson){

    List<int> listStdIdsEnable = [];

    for (var element in stdClasses) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }
    var stdLessons = listStdLesson
        .where(
            (e) => listStdIdsEnable.contains(e.studentId) && e.timekeeping != 0)
        .toList();

    double attendancePercent = 0;
    List<LessonModel> lessonTemp = listLesson.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    int count = stdLessons
        .where((element) => element.timekeeping != 0)
        .toList()
        .length;
    double attendanceTemp = 0;
    for (var i in stdLessons) {
      if (i.timekeeping < 5) {
        attendanceTemp++;
      }
    }
    attendancePercent = attendanceTemp / (count == 0 ? 1 : count);

    return attendancePercent;
  }

  static double classHwPercent(List<StudentClassModel> stdClasses, List<StudentLessonModel> listStdLesson, List<LessonModel> listLesson){
    List<int> listStdIdsEnable = [];

    for (var element in stdClasses) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }

    var stdLessons = listStdLesson
        .where(
            (e) => listStdIdsEnable.contains(e.studentId) && e.timekeeping != 0)
        .toList();

    double hwPercent = 0;
    List<LessonModel> lessonTemp =
    listLesson.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }

    int countHw = 0;
    double hwPercentTemp = 0;
    for (var i in stdLessons) {
      if (lessonExceptionIds.contains(i.lessonId) == false) {
        countHw++;
        if (getPoint(i.lessonId, i.studentId, listLesson, listStdLesson) != -2) {
          hwPercentTemp++;
        }
      }
    }
    hwPercent = hwPercentTemp / (countHw == 0 ? 1 : countHw);

    return hwPercent;
  }

  static double getPoint(int lessonId, int stdId,List<LessonModel> lessons,List<StudentLessonModel> stdLessons ) {

    bool isCustom = lessons.where((e) => e.lessonId == lessonId).toList().isNotEmpty ? lessons.firstWhere((e) => e.lessonId == lessonId).isCustom : false;

    List<StudentLessonModel> stdLesson = stdLessons
        .where((e) => e.lessonId == lessonId && e.studentId == stdId)
        .toList();
    if (isCustom) {
      return getHwCustomPoint(lessonId, stdId, stdLessons);
    }
    if (stdLesson.isEmpty) return -2;
    return stdLesson.first.hw;
  }

  static double getHwCustomPoint(int lessonId, int stdId,List<StudentLessonModel> stdLessons ) {
    List<StudentLessonModel> stdLesson = stdLessons
        .where((e) => e.lessonId == lessonId && e.studentId == stdId)
        .toList();

    if (stdLesson.isEmpty) {
      return -2;
    }
    List<dynamic> listHws = stdLesson.first.hws.map((e) => e['hw']).toList();

    if (listHws.every((e) => e == -2)) {
      return -2;
    } else if (listHws.every((e) => e > 0)) {
      return listHws.reduce((value, element) => value + element) /
          listHws.length;
    }
    return -1;
  }

  static double getPercentUpSale(List<StudentClassModel>? stdClasses) {
    if (stdClasses == null || stdClasses.isEmpty) {
      return 0;
    }

    double upNumber = 0;
    int temp = 0;
    for (var i in stdClasses) {
      if (i.classStatus == "UpSale" || i.classStatus == "Force") {
        upNumber++;
      }
      if ((i.classStatus != "Remove" &&
          i.classStatus != "Moved" &&
          i.classStatus != "Viewer")) {
        temp++;
      }
    }
    return ((upNumber / temp) * 100).roundToDouble();
  }

  static double convertToPoint(int value){
    switch (value){
      case 1:
      case 0:
        return 10;
      case 2:
        return 8;
      case 3:
        return 6;
      case 4:
        return 4;
      case 5:
        return 2;
    }
    return 10;
  }


  static double getStudentAttendancePercent(List<StudentLessonModel> stdLessons) {
    int tempAttendance = 0;
    int count = stdLessons.length;

    for (var i in stdLessons) {
      if (i.timekeeping != 6 && i.timekeeping != 5 && i.timekeeping != 0) {
        tempAttendance++;
      }
    }

    return tempAttendance / (count == 0 ? 1 : count);
  }

  static double getStudentHwPercent(List<StudentLessonModel> stdLessons,List<LessonModel> lessons ) {
    int tempHw = 0;
    int countHw = 0;

    for (var i in stdLessons) {
      if (i.timekeeping != 0) {
        if (getStdPoint(i.lessonId,lessons,stdLessons) != -2) {
          tempHw++;
        }
        countHw++;
      }
    }

    return tempHw / (countHw == 0 ? 1 : countHw);
  }

  static double getStdPoint(int lessonId, List<LessonModel> lessons,List<StudentLessonModel> stdLessons) {
    bool isCustom =
        lessons.firstWhere((e) => e.lessonId == lessonId).isCustom;
    StudentLessonModel stdLesson =
    stdLessons.firstWhere((e) => e.lessonId == lessonId);
    if (isCustom) {
      return getStdHwCustomPoint(lessonId,stdLessons);
    }
    return stdLesson.hw;
  }

  static double getStdHwCustomPoint(int lessonId,List<StudentLessonModel> stdLessons) {
    List<StudentLessonModel> stdLesson =
    stdLessons.where((e) => e.lessonId == lessonId).toList();

    if (stdLesson.isEmpty) {
      return -2;
    }
    List<dynamic> listHws = stdLesson.first.hws.map((e) => e['hw']).toList();

    if (listHws.every((e) => e == -2)) {
      return -2;
    } else if (listHws.every((e) => e > 0)) {
      return listHws.reduce((value, element) => value + element) /
          listHws.length;
    }
    return -1;
  }

  static double getStdTestPoint(List<StudentTestModel> stdTests) {
    double temp = 0;
    double count = 0;
    for (int i = 0; i < stdTests.length; i++) {
      if (stdTests[i].score > -1) {
        temp += stdTests[i].score;
        count++;
      }
    }
    return count == 0 ? 10 : temp / count;
  }


  static double? getGPAPoint(List<StudentLessonModel> stdLessons,List<LessonModel> lessons ) {
    double temp = 0;
    double count = 0;
    for (int i = 0; i < stdLessons.length; i++) {
      if (getStdPoint(stdLessons[i].lessonId, lessons,stdLessons) > -1) {
        temp += getStdPoint(stdLessons[i].lessonId, lessons,stdLessons);
        count++;
      }
    }
    return count == 0 ? null : temp / count;
  }
}