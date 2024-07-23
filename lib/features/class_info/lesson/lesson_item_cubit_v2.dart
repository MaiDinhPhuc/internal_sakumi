import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/model/class_model.dart';
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
  List<Map> listLessonInfo = [];

  updateClass(
      ListLessonCubitV2 listLessonCubit, LessonModel lessonModel) async {
    List<dynamic> listCustomLesson = [];

    for (var i in cubit.classModel!.customLessons) {
      if(i['custom_lesson_id'] != lessonModel.lessonId){
        listCustomLesson.add(i);
      }
    }

    ClassModel newClass = ClassModel(
        classId: cubit.classModel!.classId,
        courseId: cubit.classModel!.courseId,
        description: cubit.classModel!.description,
        endTime: cubit.classModel!.endTime,
        startTime: cubit.classModel!.startTime,
        note: cubit.classModel!.note,
        classCode: cubit.classModel!.classCode,
        classStatus: cubit.classModel!.classStatus,
        classType: cubit.classModel!.classType,
        link: cubit.classModel!.link,
        customLessons: listCustomLesson,
        informal: cubit.classModel!.informal,
        isSubClass: cubit.classModel!.isSubClass,
        subClassId: cubit.classModel!.subClassId, customTests: cubit.classModel!.customTests);

    cubit.updateClass(newClass);

    Update
        .updateClassInfo(newClass);
    listLessonCubit.removeLesson(lessonModel);
  }

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
      var teacherTempt = cubit.teachers
          .where((e) => e.userId == lessonResult!.teacherId)
          .toList();
      if(teacherTempt.isNotEmpty){
        teacher = teacherTempt.first;
      }
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
        supportNoteForTeacher: value, dateTime: lessonResult!.dateTime);
  }

  double getAttendancePercent() {
    List<int> stdIds = getStudentId();
    if(stdIds.isEmpty) return 0;
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
    List<int> stdIds = getStudentId();
    if(stdIds.isEmpty) return null;
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

  bool? checkGradingCustom() {
    List<int> stdIds = getStudentId();
    if(stdIds.isEmpty) return null;
    bool? status;
    List<StudentLessonModel> tempList = stdLessons!
        .where((e) => e.timekeeping != 0 && stdIds.contains(e.studentId))
        .toList();
    if (tempList.isEmpty) {
      status = null;
    } else {
      List<double> listHws = tempList.map((e) => getHwCustomPoint(e.studentId)).toList();
      int submitCount = 0;
      int checkCount = 0;
      int notSubmitCount = 0;
      for (var k in listHws) {
        if (k != -2) {
          submitCount++;
        }
        if (k > -1) {
          checkCount++;
        }
        if (k == -2) {
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
    List<int> stdIds = getStudentId();
    if(stdIds.isEmpty) return 0;
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

  double getHwPercentCustom() {
    List<int> stdIds = getStudentId();
    if(stdIds.isEmpty) return 0;
    List<StudentLessonModel> tempList = stdLessons!
        .where((e) => e.timekeeping != 0 && stdIds.contains(e.studentId))
        .toList();
    List<double> listHws = tempList.map((e) => getHwCustomPoint(e.studentId)).toList();
    double tempHw = 0;
    for (var j in listHws) {
      if (j != -2) {
        tempHw++;
      }
    }
    return tempHw / (tempList.isEmpty ? 1 : tempList.length);
  }

  List<int> getStudentId() {
    List<int> studentIds = [];
    if(stdClasses == null) return [];
    for (var i in stdClasses!) {
      if (i.classStatus != "Remove" && i.classStatus != "Viewer") {
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
      List<int> stdIds = stdLessons!.map((e) => e.studentId).toList();
      if(stdIds.isEmpty) return [];
      List<StudentModel> students = this
          .students!
          .where((e) => stdIds.contains(e.userId))
          .toList();
      students.sort((a, b) => a.userId.compareTo(b.userId));
      return students;
    }
    return [];
  }

  double getHwCustomPoint(int stdId){
    List<StudentLessonModel> stdLesson = stdLessons!.where((e) => e.studentId == stdId).toList();

    if(stdLesson.isEmpty){
      return -2;
    }
    List<dynamic> listHws = stdLesson.first.hws.map((e) => e['hw']).toList();

    if(listHws.every((e) => e == -2)){
      return -2;
    }else if(listHws.every((e) => e > 0)){
      return listHws.reduce((value, element) => value + element) / listHws.length;
    }
    return -1;
  }
}
