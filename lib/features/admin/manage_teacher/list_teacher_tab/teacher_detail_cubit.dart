import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/calculator/calculator.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TeacherDetailCubit extends Cubit<int> {
  TeacherDetailCubit(this.teacherModel) : super(0) {
    loadData();
  }

  bool isLoading = true;

  List<TeacherClassModel>? teacherClasses;
  List<ClassModel>? classes;

  List<LessonModel> lessons = [];
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;
  List<StudentTestModel>? stdTests;

  double? hwPercent, attendancePercent, levelUpPercent;

  final TeacherModel teacherModel;

  loadData() async {
    teacherClasses =
        (await FireBaseProvider.instance.getTeacherClassById(teacherModel.userId))
            .where((e) => e.responsibility == true)
            .toList();
    var listClassId = teacherClasses!.map((e) => e.classId).toList();
    classes =
        await FireBaseProvider.instance.getListClassByListIdV2(listClassId);
    stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInListClassId(listClassId);
    stdTests = await FireBaseProvider.instance
        .getAllStudentTestInListClassId(listClassId);
    stdClasses =
        await FireBaseProvider.instance.getStudentClassByListId(listClassId);
    for (var i in classes!) {
      if (i.customLessons.isEmpty) {
        await DataProvider.lessonByCourseId(i.courseId, loadLessonInClass);
      } else {
        await DataProvider.lessonByCourseAndClassId(
            i.courseId, i.classId, loadLessonInClass);

        var lessonId = lessons.map((e) => e.lessonId).toList();

        if (i.customLessons.isNotEmpty) {
          for (var j in i.customLessons) {
            if (!lessonId.contains(j['custom_lesson_id'])) {
              lessons.add(LessonModel(
                  lessonId: j['custom_lesson_id'],
                  courseId: -1,
                  description: j['description'],
                  content: "",
                  title: j['title'],
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
                  customLessonInfo: j['lessons_info'],
                  isCustom: true));
            }
          }
        }
      }
    }

    attendancePercent =
        Calculator.classAttendancePercent(stdClasses!, stdLessons!, lessons);

    hwPercent = Calculator.classHwPercent(stdClasses!, stdLessons!, lessons);

    levelUpPercent = Calculator.getPercentUpSale(stdClasses!);

    isLoading = false;

    emit(state + 1);
  }

  String getEvaluate(){


    List<double> listEva = [];

    for(var i in teacherClasses!){
      var stdClasses = this.stdClasses!.where((e) => e.classId == i.classId).toList();
      var studentLessons = stdLessons!.where((e) => e.classId == i.classId).toList();

      int countDrop = 0;
      for (var i in stdClasses) {
        if (i.classStatus == "Dropped" ||
            i.classStatus == "Deposit" ||
            i.classStatus == "Retained" ||
            i.classStatus == "Moved") {
          countDrop++;
        }
      }
      double Z = (countDrop / stdClasses.length) * 10;

      List<int> listStdId = [];
      for(var i in stdClasses){
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
        var stdLessons = studentLessons
            .where((e) => e.studentId == i)
            .toList();
        var stdTests = this.stdTests!
            .where((e) => e.studentId == i)
            .toList();
        var stdClassModel = stdClasses.firstWhere((e) => e.userId == i);

        double X = Calculator.getStudentAttendancePercent(stdLessons) * 10;
        double Y = Calculator.getStudentHwPercent(stdLessons, lessons) * 10;
        double Z1 = Calculator.getGPAPoint(stdLessons, lessons) == null ? 10 : Calculator.getGPAPoint(stdLessons, lessons)!;
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

      listEva.add(Q);
    }

    double sum = 0.0;
    for (double value in listEva) {
      sum += value;
    }

    double average = sum / listEva.length;

    if(average >= 7.5) return "A";

    if(average >= 6.5) return "B";

    if(average >= 5) return "C";

    if(average >= 3.5) return "D";

    if(average >= 2) return "E";

    return "F";

  }

  loadLessonInClass(Object lessons) {
    var newLessons = lessons as List<LessonModel>;
    for (var i in newLessons) {
      if (this.lessons.contains(i) == false) {
        this.lessons.add(i);
      }
    }
  }
}
