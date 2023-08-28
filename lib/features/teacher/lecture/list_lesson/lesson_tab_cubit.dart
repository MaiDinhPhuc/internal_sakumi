import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class LessonTabCubit extends Cubit<int> {
  LessonTabCubit() : super(0);

  ClassModel? classModel;
  List<LessonModel>? lessons;
  List<LessonResultModel?>?  lessonResults;
  List<StudentClassModel> listStdClass = [];
  List<StudentModel>? students;
  List<List<StudentLessonModel?>> listStdLesson = [];
  List<List<int>>? listSubmit, listAttendance;
  List<List<String>>? listNote;
  List<TeacherModel?>? infoTeachers;
  List<double>? listRateAttend, listRateSubmit;
  List<bool?>? listMarked;

  init(context) async {
    debugPrint('==============> init 1');
    await loadClass(context);
    debugPrint('==============> init 2');
    await loadLesson(context);
    debugPrint('==============> init 3');
    await loadStudentInClass(context);
    debugPrint('==============> init 4');
    await loadLessonResult(context);
    debugPrint('==============> init 5');
    await loadStatistic(context);
    debugPrint('==============> init 6');
  }

  loadClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    classModel =
    await teacherRepo.getClassById(int.parse(TextUtils.getName()));
    emit(state + 1);
  }

  loadLesson(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    lessons = await teacherRepo.getLessonsByCourseId(classModel!.courseId);
    emit(state + 1);
  }

  loadStudentInClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    AdminRepository adminRepo = AdminRepository.fromContext(context);
    listStdClass =
        await teacherRepo.getStudentClassInClass(classModel!.classId);
    var list = await adminRepo.getAllStudent();
    students = [];
    for (var i in list) {
      for (var j in listStdClass!) {
        if (i.userId == j.userId) {
          students!.add(i);
        }
      }
    }
    emit(state + 1);
  }

  loadLessonResult(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    AdminRepository adminRepo = AdminRepository.fromContext(context);

    lessonResults = List.generate(lessons!.length, (index) => null);
    infoTeachers = List.generate(lessons!.length, (index) => null);

    var listLessonResult = await teacherRepository
        .getLessonResultByClassId(classModel!.classId);

    var teachers = await adminRepo.getAllTeacher();

    for(var lesson in lessons!){
      for(var item in listLessonResult!){
        if(lesson.lessonId == item!.lessonId){
          lessonResults![lessons!.indexOf(lesson)] = item;
        }
      }
    }
    for(var i in lessonResults!){
      if(i != null){
        for(var j in teachers){
          if(i!.teacherId == j.userId){
            infoTeachers![lessonResults!.indexOf(i)] = j;
          }
        }
      }
    }
    emit(state + 1);
  }

  loadStatistic(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    var list =
        await teacherRepo.getAllStudentLessonsInClass(classModel!.classId);
    listSubmit = [];
    listAttendance = [];
    listNote = [];
    listRateAttend = [];
    listRateSubmit = [];
    listMarked = [];

    for (var lesson in lessons!) {
      List<int> attends = [];
      List<int> submits = [];
      List<String> notes = [];

      List<StudentLessonModel> listStdLessonInLesson = list.fold(
          <StudentLessonModel>[],
          (pre, e) => [...pre, if (e.lessonId == lesson.lessonId) e]).toList();

      if(listStdLessonInLesson.isNotEmpty){
        for (var std in listStdClass!) {
          if (listStdClass!.indexOf(std) <= listStdLessonInLesson.length-1) {
            if(std.userId == listStdLessonInLesson[listStdClass!.indexOf(std)].studentId){
              attends.add(
                  listStdLessonInLesson[listStdClass!.indexOf(std)].timekeeping);
              submits.add(listStdLessonInLesson[listStdClass!.indexOf(std)].hw);
              notes.add(listStdLessonInLesson[listStdClass!.indexOf(std)].teacherNote);
            }
            else {
              attends.add(-1);
              submits.add(-3);
              notes.add('');
            }
          } else {
            attends.add(-1);
            submits.add(-3);
            notes.add('');
          }
        }
        int tempAtt =
        attends.fold(0, (pre, e) => pre + ((e > 0 && e < 5) ? 1 : 0));
        int tempSbm = submits.fold(0, (pre, e) => pre + (e > -2 ? 1 : 0));
        int tempMark = submits.fold(0, (pre, e) => pre + (e > -1 ? 1 : 0));
        listAttendance!.add(attends);
        listMarked!.add(listStdClass.isEmpty ? null : (tempSbm == tempMark && tempSbm != 0) ? true : false);
        listSubmit!.add(submits);
        listNote!.add(notes);
        listRateAttend!.add((listStdClass.isEmpty) ? 0 : tempAtt / (listStdClass!.length));
        listRateSubmit!.add((listStdClass.isEmpty) ? 0 : tempSbm / (listStdClass!.length));
      }
      else{
        for (var std in listStdClass!) {
          attends.add(-1);
          submits.add(-3);
          notes.add('');
        }
        listAttendance!.add(attends);
        listMarked!.add(null);
        listSubmit!.add(submits);
        listRateAttend!.add(0);
        listRateSubmit!.add(0);
        listNote!.add(notes);
      }
    }
    emit(state + 1);
  }
}
