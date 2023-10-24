import 'dart:ui';

import 'package:internal_sakumi/model/class_model.dart';

class ClassModel2 {
  final int classId;
  final String status;
  final String classCode;
  final int courseId;

  static List<ClassModel2> make(
      List<ClassModel> classes) {
    List<ClassModel2> results = [];

    for (var classModel in classes) {
      results.add(ClassModel2(
        classId: classModel.classId,
        status: classModel.classStatus,
        classCode: classModel.classCode,
        courseId: classModel.courseId,
      ));
    }

    return results;
  }

  Color getColor() {
    switch (status) {
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
    switch (status) {
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

  ClassModel2({
    required this.classId,
    required this.status,
    required this.courseId,
    required this.classCode,
  });
}