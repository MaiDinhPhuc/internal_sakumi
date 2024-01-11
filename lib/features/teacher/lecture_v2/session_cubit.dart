import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionCubit extends Cubit<int> {
  SessionCubit() : super(0);
  List<StudentModel>? listStudent;
  List<StudentLessonModel>? listStudentLesson;
  List<StudentClassModel>? listStudentClass;
  int totalAttendance = 0, teacherId = -1;
  ClassModel? classModel;
  bool? isNoteStudent = false;
  bool? isNoteSupport = false;
  bool? isNoteSensei = false;
  String noteStudent = '';
  String noteSupport = '';
  String noteSensei = '';
  int loadCount = 0;

  List<String> listNoteForEachStudent = [];


  loadEdit(List<StudentModel>? students, List<StudentLessonModel>? stdLessons, int lessonId){
    listStudent = students;
    listStudent!.sort((a, b) => a.userId.compareTo(b.userId));
    List<int> studentId = listStudent!.map((e) => e.userId).toList();
    listStudentLesson = stdLessons!.where((e) => studentId.contains(e.studentId) && e.lessonId == lessonId).toList();
    listStudentLesson!.sort((a, b) => a.studentId.compareTo(b.studentId));
    emit(state+1);
  }

  inputNoteForEachStudent(String text, int stdId) {
    var std = listStudent!.firstWhere((e) => e.userId == stdId);
    var index = listStudent!.indexOf(std);
    listNoteForEachStudent[index] = text;
    emit(state + 1);
  }

  updateUI() {
    emit(state + 1);
  }

  getTeacherId() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    teacherId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
  }

  inputStudent(String text) {
    noteStudent = text;
    emit(state + 1);
  }

  inputSupport(String text) {
    noteSupport = text;
    emit(state + 1);
  }

  inputSensei(String text) {
    noteSensei = text;
    emit(state + 1);
  }

  checkNoteStudent() {
    if (isNoteStudent != null) {
      if (isNoteStudent == false) {
        isNoteStudent = true;
      } else {
        isNoteStudent = false;
      }
    }
    debugPrint('================> checkNoteStudent $isNoteStudent');
    emit(state + 1);
  }

  checkNoteSupport() {
    if (isNoteSupport != null) {
      if (isNoteSupport == false) {
        isNoteSupport = true;
      } else {
        isNoteSupport = false;
      }
    }
    emit(state + 1);
  }

  checkNoteSensei() {
    if (isNoteSensei != null) {
      if (isNoteSensei == false) {
        isNoteSensei = true;
      } else {
        isNoteSensei = false;
      }
    }
    emit(state + 1);
  }

  updateTimekeeping(int attendId) {
    debugPrint(
        '============> totalAttendance000 $totalAttendance -- $attendId');
    if (attendId > 0 && totalAttendance < listStudent!.length) {
      totalAttendance++;
    }
    if (attendId <= 0 && totalAttendance > 0) {
      totalAttendance--;
    }

    debugPrint(
        '============> totalAttendance1111 $totalAttendance -- $attendId');
    emit(state + 1);
  }
}
