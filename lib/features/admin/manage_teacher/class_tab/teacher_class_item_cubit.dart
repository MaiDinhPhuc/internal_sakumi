import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/calculator/calculator.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';

class TeacherClassItemCubit extends Cubit<int>{
  TeacherClassItemCubit( this.cubit, this.classModel):super(0){
    loadData();
  }

  final TeacherInfoCubit cubit;
  final ClassModel classModel;

  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;
  List<StudentTestModel>? stdTests;

  String? title;
  int? lessonCount;
  String? lessonCountTitle;
  double? hwPercent, attendancePercent;

  onCourseLoaded(Object course) {
    title =
    "${(course as CourseModel).name} ${(course).level} ${(course).termName}";
    lessonCount = course.lessonCount + classModel.customLessons.length;
    emit(state + 1);
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
    lessonCountTitle = "${this.lessonResults!.length}/$lessonCount";
    emit(state + 1);
  }

  loadStudentClass(Object studentClass) {
    stdClasses = studentClass as List<StudentClassModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
    emit(state + 1);
  }

  loadStdTest(Object stdTests) {
    this.stdTests = stdTests as List<StudentTestModel>;
  }


  loadData()async{
    DataProvider.courseById(classModel.courseId, onCourseLoaded);

    await DataProvider.stdClassByClassId(classModel.classId, loadStudentClass);

    await DataProvider.stdTestByClassId(classModel.classId, loadStdTest);

    if(classModel.customLessons.isEmpty){
      await DataProvider.lessonByCourseId(classModel.courseId, loadLessonInClass);
    }else{
      await DataProvider.lessonByCourseAndClassId(classModel.courseId,classModel.classId, loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if(classModel.customLessons.isNotEmpty){
        for(var i in classModel.customLessons){
          if(!lessonId.contains(i['custom_lesson_id'])){
            lessons!.add(LessonModel(
                lessonId: i['custom_lesson_id'],
                courseId: -1,
                description: i['description'],
                content: "",
                title: i['title'],
                btvn: -1,
                vocabulary: 0,
                listening: 0,
                kanji: 0,
                grammar: 0,
                flashcard: 0,
                alphabet: 0,
                order: 0,
                reading: 0,
                enable: true,
                customLessonInfo: i['lessons_info'],
                isCustom: true));
          }
        }
      }
    }
    emit(state+1);
    await DataProvider.stdLessonByClassId(classModel.classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(
        classModel.classId, loadLessonResult);
    await loadPercent();
  }

  loadPercent() async {
    await Future.delayed(const Duration(milliseconds: 500));

    attendancePercent = Calculator.classAttendancePercent(stdClasses!, stdLessons!, lessons!);

    hwPercent = Calculator.classHwPercent(stdClasses!, stdLessons!, lessons!);

    emit(state + 1);
  }

  String getTitle(int lessonId){

    if(lessons == null) return "";

    var lesson = lessons!.where((e) => e.lessonId == lessonId).toList();
    if(lesson.isEmpty) return "";

    return lesson.first.title;
  }

  double getAttendanceForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();

    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }

    if (temp2 == 0) {
      return 0;
    }

    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  String getEvaluate(){

    if(stdTests == null) return "A";

    int countDrop = 0;
    for (var i in stdClasses!) {
      if (i.classStatus == "Dropped" ||
          i.classStatus == "Deposit" ||
          i.classStatus == "Retained" ||
          i.classStatus == "Moved") {
        countDrop++;
      }
    }
    double Z = (countDrop / stdClasses!.length) * 10;

    List<int> listStdId = [];
    for(var i in stdClasses!){
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" && i.classStatus != "Viewer") {
        listStdId.add(i.userId);
      }
    }

    double sum = 0;

    for(var i in listStdId){
      var stdLessons = this.stdLessons!
          .where((e) => e.studentId == i)
          .toList();
      var stdTests = this.stdTests!
          .where((e) => e.studentId == i)
          .toList();
      var stdClassModel = stdClasses!.firstWhere((e) => e.userId == i);

      double X = Calculator.getStudentAttendancePercent(stdLessons) * 10;
      double Y = Calculator.getStudentHwPercent(stdLessons, lessons!) * 10;
      double Z1 = Calculator.getGPAPoint(stdLessons, lessons!) == null ? 10 : Calculator.getGPAPoint(stdLessons, lessons!)!;
      double Z2 = Calculator.getStdTestPoint(stdTests);
      double Z3 = Calculator.convertToPoint(stdClassModel.learningStatus);
      double Z4 = Calculator.convertToPoint(stdClassModel.activeStatus);

      double Z = (Z1+Z2+Z3+Z4)/4;

      double R = (X+Y+Z)/3;

      while(R - min(X, min(Y,Z)) > 2){
        R = R - 1;
      }

      sum = sum+R;
    }

    double result = sum/listStdId.length;

    double Q = result - Z;

    if(Q >= 8.5) return "A";

    if(Q >= 7) return "B";

    if(Q >= 5.5) return "C";

    if(Q >= 4) return "D";

    if(Q >= 2) return "E";

    return "F";

  }

  double getHwForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (Calculator.getPoint(i.lessonId, i.studentId,lessons!,stdLessons!) != -2 && i.timekeeping != 0) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }
    if (temp2 == 0) {
      return 0;
    }

    double hwPercent = temp1 / temp2;

    return hwPercent;
  }
}