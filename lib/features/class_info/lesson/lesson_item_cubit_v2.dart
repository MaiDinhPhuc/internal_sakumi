import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';

import 'list_lesson_cubit_v2.dart';

class LessonItemCubitV2 extends Cubit<int> {
  LessonItemCubitV2(this.cubit, this.lesson) : super(0) {
    loadData();
  }

  final LessonModel lesson;
  final ListLessonCubitV2 cubit;
  LessonResultModel? lessonResult;
  List<StudentModel>? students;
  List<StudentLessonModel>? stdLessons;
  TeacherModel? teacher;
  List<StudentClassModel>? stdClasses;

  loadData() async {
    if (cubit.lessonResults != null) {
      var result = cubit.lessonResults!
          .where((e) => e.lessonId == lesson.lessonId)
          .toList();
      if (result.isNotEmpty) {
        lessonResult = result.first;
      }
    }

    if (cubit.stdLessons != null) {
      stdLessons = cubit.stdLessons!
          .where((e) => e.lessonId == lesson.lessonId)
          .toList();
    }

    if (cubit.listStdClass != null) {
      var stdClass = cubit.listStdClass ?? [];
      if(stdClass.isNotEmpty){
        stdClasses = cubit.listStdClass!;
      }
    }

    if (cubit.students.isNotEmpty) {
      var std = cubit.students;
      if(std.isNotEmpty){
        students = cubit.students;
      }
    }

    if (cubit.teachers.isNotEmpty && lessonResult != null) {
      teacher =
          cubit.teachers.firstWhere((e) => e.userId == lessonResult!.teacherId);
    }
    emit(state + 1);
  }

  updateNote(String value) {
    lessonResult = LessonResultModel(
        id: lessonResult!.id,
        classId: lessonResult!.classId,
        lessonId: lessonResult!.lessonId,
        teacherId: lessonResult!.teacherId,
        status: lessonResult!.status,
        date: lessonResult!.date,
        noteForStudent: lessonResult!.noteForStudent,
        noteForSupport: lessonResult!.noteForSupport,
        noteForTeacher: lessonResult!.noteForTeacher,
        supportNoteForTeacher: value);
  }

  double getAttendancePercent() {
    var stdIds = getStudentId();
    List<StudentLessonModel> tempList = stdLessons!
        .where((e) => e.timekeeping != 0 && stdIds.contains(e.studentId))
        .toList();
    double tempAttendance = 0;
    for (var j in tempList) {
      if (j.timekeeping < 5 && j.timekeeping > 0) {
        tempAttendance++;
      }
    }
    return tempAttendance / (tempList.isEmpty ? 1 : tempList.length);
  }

  bool? checkGrading() {
    var stdIds = getStudentId();
    bool? status;
    List<StudentLessonModel> tempList = stdLessons!
        .where((e) => e.timekeeping != 0 && stdIds.contains(e.studentId))
        .toList();
    if (tempList.isEmpty) {
      status = null;
    } else {
      int submitCount = 0;
      int checkCount = 0;
      int notSubmitCount = 0;
      for (var k in tempList) {
        if (k.hw != -2) {
          submitCount++;
        }
        if (k.hw > -1) {
          checkCount++;
        }
        if (k.hw == -2) {
          notSubmitCount++;
        }
      }
      if (checkCount == submitCount) {
        status = true;
      } else {
        status = false;
      }
      if (notSubmitCount == tempList.length) {
        status = null;
      }
    }
    return status;
  }

  double getHwPercent() {
    var stdIds = getStudentId();
    List<StudentLessonModel> tempList = stdLessons!
        .where((e) => e.timekeeping != 0 && stdIds.contains(e.studentId))
        .toList();
    double tempHw = 0;
    for (var j in tempList) {
      if (j.hw != -2) {
        tempHw++;
      }
    }
    return tempHw / (tempList.isEmpty ? 1 : tempList.length);
  }

  List<int> getStudentId() {
    List<int> studentIds = [];
    for (var i in stdClasses!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        studentIds.add(i.userId);
      }
    }

    return studentIds;
  }

  List<StudentLessonModel> getStudentLesson(int stdId) {
    var stdLesson = stdLessons!.where((e) => e.studentId == stdId).toList();

    return stdLesson;
  }

  List<StudentModel> getStudents() {
    if (students != null) {
      List<StudentModel> students = this
          .students!
          .where((e) => getStudentId().contains(e.userId))
          .toList();
      students.sort((a, b) => a.userId.compareTo(b.userId));
      return students;
    }
    return [];
  }
}
