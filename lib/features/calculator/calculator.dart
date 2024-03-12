import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';

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
    if (stdClasses == null) {
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

}