import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
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
  List<StudentModel>? students;
  //List<List<double>> listAttendance = [], listHomework = [], listPoints = [];
  List<double> listAttendance = [], listHomework = [], listPoints = [];
  double percentHw = 0, averagePts = 0;


  init(context) async {
    await loadClass(context);
    await loadStudentInClass(context);
    await loadStudentLesson(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    classModel = await teacherRepo.getClassById(int.parse(TextUtils.getName()));
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

  loadStudentLesson(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);

    var stdLessons = await teacherRepo
        .getAllStudentLessonsInClass(int.parse(TextUtils.getName()));

    var lessonResults = await teacherRepo.getLessonResultByClassId(int.parse(TextUtils.getName()));

    // for(var std in students!){
    //   var sl = stdLessons.fold(<StudentLessonModel>[], (pre, e) => [...pre, if(std.userId == e.studentId) e]).toList();
    //   List<double> attends = [], homeworks = [], points = [];
    //   for(var i in lessonResults){
    //     var attend = 0, hw = 0, point = 0, numOfStdLessons = 0;
    //     for(var j in sl){
    //       if(i.lessonId == j.lessonId){
    //         numOfStdLessons++;
    //         if(j.timekeeping > 0 && j.timekeeping < 6){
    //           attend++;
    //         }
    //         if(j.hw > -2) {hw++;}
    //         if(j.hw > -1){
    //           point = point + j.hw;
    //         }
    //       }
    //     }
    //     attends.add(attend.toDouble());
    //     homeworks.add(numOfStdLessons == 0? 0: hw/numOfStdLessons);
    //     points.add(numOfStdLessons == 0? 0: point/numOfStdLessons);
    //   }
    //   percentHw = lessonResults.isEmpty ? 0 : homeworks.fold(0.0, (pre, e) => pre + e)/lessonResults!.length;
    //   averagePts = points.isEmpty ? 0 : points.fold(0.0, (pre, e) => pre + e)/points!.length;
    //
    //   listAttendance.add(attends);
    //   listHomework.add(homeworks);
    //   listPoints.add(points);
    // }



    for(var i in lessonResults){
      var attend = 0, hw = 0, point = 0, numOfStdLessons = 0;
      for(var j in stdLessons){
        if(i.lessonId == j.lessonId){
          numOfStdLessons++;
          if(j.timekeeping > 0 && j.timekeeping < 6){
            attend++;
          }
          if(j.hw > -2) {hw++;}
          if(j.hw > -1){
            point = point + j.hw;
          }
        }
      }
      listAttendance.add(attend.toDouble());
      listHomework.add(numOfStdLessons == 0? 0: hw/numOfStdLessons);
      listPoints.add(numOfStdLessons == 0? 0: point/numOfStdLessons);
    }

    percentHw = lessonResults.isEmpty ? 0 : listHomework.fold(0.0, (pre, e) => pre + e)/lessonResults!.length;
    averagePts = listPoints.isEmpty ? 0 : listPoints.fold(0.0, (pre, e) => pre + e)/listPoints!.length;


    debugPrint('==============> listAttendance $listAttendance');

    emit(state+1);
  }

  loadStatistic(context)async{

    emit(state + 1);
  }
}
