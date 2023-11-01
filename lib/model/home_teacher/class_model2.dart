import 'dart:ui';

import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';

class ClassModel2 {
  final ClassModel classModel;
  final int? lessonCount;
  final CourseModel? course;
  final List<LessonModel>? listLesson;
  final List<StudentClassModel>? stdClasses;
  final List<LessonResultModel>? lessonResults;
  final List<StudentLessonModel>? stdLessons;

  ClassModel2 copyWith(
      ClassModel? classModel,
      CourseModel? course,
      int? lessonCount,
      List<LessonModel>? listLesson,
      List<StudentClassModel>? stdClasses,
      List<LessonResultModel>? lessonResults,
      List<StudentLessonModel>? stdLessons) {
    return ClassModel2(
        course: course ?? this.course,
        listLesson: listLesson ?? this.listLesson,
        stdClasses: stdClasses ?? this.stdClasses,
        lessonResults: lessonResults ?? this.lessonResults,
        stdLessons: stdLessons ?? this.stdLessons,
        classModel: classModel ?? this.classModel,
        lessonCount: lessonCount ?? this.lessonCount);
  }

  static Future<List<ClassModel2>> load1(
      List<ClassModel> classes,
      // List<CourseModel> courses,
      // List<LessonModel>? lessons,
      // List<StudentClassModel>? stdClasses,
      // List<LessonResultModel>? lessonResults,
      // List<StudentLessonModel>? stdLessons
      ) async {
    List<ClassModel2> results = [];

    for (var classModel in classes) {
      //var course = courses.firstWhere((e) => e.courseId == classModel.courseId);
      // var listLesson =
      //     lessons.where((e) => e.courseId == classModel.courseId).toList();
      // var listStdClass =
      //     stdClasses.where((e) => e.classId == classModel.classId).toList();
      // var lesResults =
      //     lessonResults.where((e) => e.classId == classModel.classId).toList();
      // lesResults.sort((a, b) {
      //   DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      //   var tempA = a.date;
      //   var tempB = b.date;
      //   if (tempA!.length == 10) {
      //     tempA += ' 00:00:00';
      //   }
      //   if (tempB!.length == 10) {
      //     tempB += ' 00:00:00';
      //   }
      //   final dateA = dateFormat.parse(tempA);
      //   final dateB = dateFormat.parse(tempB);
      //   return dateA.compareTo(dateB);
      // });
      // var listStdLesson =
      //     stdLessons.where((e) => e.classId == classModel.classId).toList();

      results.add(ClassModel2(
        course: null,
        listLesson: null,
        stdClasses: null,
        lessonResults: null,
        stdLessons: null,
        lessonCount: null,
        classModel: classModel,
      ));
    }

    return results;
  }

  Color getColor() {
    switch (classModel.classStatus) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon() {
    switch (classModel.classStatus) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }

  ClassModel2(
      {required this.course,
      required this.listLesson,
      required this.stdClasses,
      required this.lessonResults,
      required this.stdLessons,
      required this.classModel,
      required this.lessonCount});
}
