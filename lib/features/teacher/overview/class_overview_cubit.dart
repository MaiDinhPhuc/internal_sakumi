import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
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
    classModel = await FireBaseProvider.instance.getClassById(int.parse(TextUtils.getName()));
    lessons = await FireBaseProvider.instance.getLessonsByCourseId(classModel!.courseId);
    emit(state + 1);
  }

  loadAfterRemove(int userId){
    for(int i= 0; i<listStdClass.length; i++){
      if(listStdClass[i].userId == userId){
        listStdClass.remove(listStdClass[i]);
        break;
      }
    }
    for(int i= 0; i<students!.length; i++){
      if(students![i].userId == userId){
        students!.remove(students![i]);
        break;
      }
    }
    emit(state + 1);
  }

  loadStudentInClass(context) async {
    listStdClass =
        await FireBaseProvider.instance.getStudentClassInClass(classModel!.classId);
    List<StudentClassModel> temp = [];
    for(var i in listStdClass){
      if(i.classStatus != "Remove"){
        temp.add(i);
      }
    }
    listStdClass = [];
    listStdClass = temp;
    listStdClass.sort((a, b) => a.userId.compareTo(b.userId));
    var list = await FireBaseProvider.instance.getAllStudent();
    students = [];
    for (var i in list) {
      for (var j in listStdClass) {
        if (i.userId == j.userId) {
          students!.add(i);
          break;
        }
      }
    }
    students!.sort((a, b) => a.userId.compareTo(b.userId));
    emit(state + 1);
  }

  loadGeneralStatistic(context) async {
    stdLessonsInClass = await FireBaseProvider.instance
        .getAllStudentLessonsInClass(int.parse(TextUtils.getName()));

    var lessonResults = await FireBaseProvider.instance
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
