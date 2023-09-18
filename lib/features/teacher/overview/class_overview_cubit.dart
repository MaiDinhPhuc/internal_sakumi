import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ClassOverviewCubit extends Cubit<int> {
  ClassOverviewCubit() : super(0);

  ClassModel? classModel;
  List<StudentClassModel> listStdClass = [];
  List<LessonModel>? lessons;
  List<StudentModel>? students;
  List<double>? listAttendance, listHomework, listPoints, stdAttends , stdHomeworks, stdPoints;
  double percentHw = 0, averagePts = 0;
  List<List<StudentLessonModel?>>? listStdLesson;
  List<StudentLessonModel>? stdLessonsInClass;
  List<String> listStudentStatusMenu = ["Completed","InProgress","Viewer","ReNew","UpSale","Moved","Retained","Dropped","Remove"];
  

  init(context) async {
    debugPrint('=============> init');
    await loadClass(context);
    await loadGeneralStatistic(context);
    await loadStudentInClass(context);
    await loadDetailStatistic(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    classModel = await teacherRepo.getClassById(int.parse(TextUtils.getName()));
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
      for (var j in listStdClass) {
        if (i.userId == j.userId) {
          students!.add(i);
        }
      }
    }
    emit(state + 1);
  }

  loadGeneralStatistic(context) async {
    debugPrint('==============> loadGeneralStatistic');
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    stdLessonsInClass = await teacherRepo
        .getAllStudentLessonsInClass(int.parse(TextUtils.getName()));

    var lessonResults = await teacherRepo
        .getLessonResultByClassId(int.parse(TextUtils.getName()));

    listAttendance = []; listHomework = []; listPoints = [];
    for(var i in lessonResults){
      var attend = 0, hw = 0, point = 0, numOfStdLessons = 0;
      for(var j in stdLessonsInClass!){
        if(i.lessonId == j.lessonId){
          numOfStdLessons++;
          if(j.timekeeping > 0 && j.timekeeping < 5){
            attend++;
          }
          if(j.hw > -2) {hw++;}
          if(j.hw > -1){
            point = point + j.hw;
          }
        }
      }
      listAttendance!.add(attend.toDouble());
      listHomework!.add(numOfStdLessons == 0? 0: hw*100/numOfStdLessons);
      listPoints!.add(numOfStdLessons == 0? 0: point/numOfStdLessons);
    }

    percentHw = lessonResults.isEmpty ? 0 : listHomework!.fold(0.0, (pre, e) => pre + e)/lessonResults.length;
    averagePts = listPoints!.isEmpty ? 0 : listPoints!.fold(0.0, (pre, e) => pre + e)/listPoints!.length;

    emit(state + 1);
  }

  loadDetailStatistic(context) async {
    stdAttends = []; stdHomeworks = []; stdPoints = []; listStdLesson = [];
    for (var std in students!) {
      List<StudentLessonModel> sl = stdLessonsInClass!.fold(<StudentLessonModel>[],
              (pre, e) => [...pre, if (e.studentId == std.userId) e]);

      stdAttends!.add(sl.isEmpty ? 0 : sl.fold(0, (pre, e) => pre + ((e.timekeeping > 0 && e.timekeeping < 5) ? 1 : 0))/(sl.length));
      stdHomeworks!.add(sl.isEmpty ? 0 : sl.fold(0.0, (pre, e) => pre + ((e.hw > -2) ? 1 : 0))/(sl.length));
      stdPoints!.add(sl.isEmpty ? 0 : sl.fold(0.0, (pre, e) => pre + ((e.hw > -1) ? e.hw : 0))/(sl.length));
      List<StudentLessonModel?> temp = List.generate(lessons!.length, (index) => null);
      for(var lesson in lessons!){
        for(var s in sl){
          if(lesson.lessonId == s.lessonId){
            temp[lessons!.indexOf(lesson)] = s;
          }
        }
      }

      listStdLesson!.add(temp);
    }
    emit(state + 1);
  }
}
