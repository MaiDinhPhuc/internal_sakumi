import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';

import 'class_overview_cubit_v2.dart';

class StudentItemOverViewCubit extends Cubit<int> {
  StudentItemOverViewCubit(this.cubit, this.stdClassModel) : super(0) {
    loadData();
  }

  final ClassOverViewCubitV2 cubit;
  StudentModel? studentModel;
  final StudentClassModel stdClassModel;

  List<StudentLessonModel>? stdLessons;

  List<String> listStudentStatusMenu = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];

  loadData() {
    var std =
        cubit.students.where((e) => e.userId == stdClassModel.userId).toList();
    if (std.isNotEmpty) {
      studentModel = std.first;
    }
    stdLessons = cubit.stdLessons!
        .where((e) => e.studentId == stdClassModel.userId)
        .toList();
    emit(state + 1);
  }

  double getAttendancePercent() {
    int tempAttendance = 0;
    int count = stdLessons!.length;

    for (var i in stdLessons!) {
      if (i.timekeeping != 6 && i.timekeeping != 5 && i.timekeeping != 0) {
        tempAttendance++;
      }
    }

    return tempAttendance / (count == 0 ? 1 : count);
  }

  double getHwPercent() {
    int tempHw = 0;
    int countHw = 0;

    for (var i in stdLessons!) {
      if (i.timekeeping != 0) {
        if (getPoint(i.lessonId) != -2) {
          tempHw++;
        }
        countHw++;
      }
    }

    return tempHw / (countHw == 0 ? 1 : countHw);
  }

  double? getGPAPoint() {
    double temp = 0;
    double count = 0;
    for (int i = 0; i < stdLessons!.length; i++) {
      if (getPoint(stdLessons![i].lessonId) > -1) {
        temp += getPoint(stdLessons![i].lessonId);
        count++;
      }
    }
    return count == 0 ? null : temp / count;
  }

  double getPoint(int lessonId) {
    bool isCustom =
        cubit.lessons!.firstWhere((e) => e.lessonId == lessonId).isCustom;
    StudentLessonModel stdLesson =
        stdLessons!.firstWhere((e) => e.lessonId == lessonId);
    if (isCustom) {
      return getHwCustomPoint(lessonId);
    }
    return stdLesson.hw;
  }

  double getHwCustomPoint(int lessonId) {
    List<StudentLessonModel> stdLesson =
        stdLessons!.where((e) => e.lessonId == lessonId).toList();

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

  String getTitle(int lessonId) {
    return cubit.lessons!.firstWhere((element) => element.lessonId == lessonId).title;
  }

  int getAttendance(int lessonId){
    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return 0;
    }
    return stdLesson.first.timekeeping;
  }

  double? getHw(int lessonId){
    var lesson = cubit.lessons!.firstWhere((e) => e.lessonId == lessonId);
    if(lesson.btvn == 0){
      return null;
    }
    return getPoint(lessonId);
  }

  bool checkCustom(int lessonId){
    var lesson = cubit.lessons!.firstWhere((e) => e.lessonId == lessonId);
    return lesson.isCustom;
  }

  String getTime(int lessonId, String field){
    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return "";
    }
    if (stdLesson.first.time.isEmpty) {
      return "";
    } else if (stdLesson.first.time[field] == null) {
      return "";
    } else {
      int seconds = stdLesson.first.time[field];

      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      String formattedTime =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
      return formattedTime;
    }
  }

  String getNumber(int lessonId, String filed){
    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if (stdLesson.isEmpty) {
      return "";
    }
    if (stdLesson.first.time.isEmpty) {
      return "";
    } else if (stdLesson.first.time[filed] == null) {
      return "";
    } else {
      int skip = stdLesson.first.time[filed];
      return skip.toString();
    }
  }

  String getSpNote(int lessonId){
    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return "";
    }
    return stdLesson.first.supportNote;
  }

  String getTeacherNote(int lessonId){
    var stdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if(stdLesson.isEmpty){
      return "";
    }
    return stdLesson.first.teacherNote;
  }
}
