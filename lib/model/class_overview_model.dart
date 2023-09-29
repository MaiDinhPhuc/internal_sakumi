import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';

import 'class_model.dart';
import 'lesson_model.dart';

class ClassOverViewModel {
  ClassModel classModel;
  List<StudentClassModel> listStdClass;
  List<StudentModel> students;
  List<double> listAttendance, listHomework;
  List<Map<String, dynamic>> listStdDetail;
  double percentHw;

  ClassOverViewModel(
      {required this.classModel,
      required this.listStdClass,
      required this.students,
      required this.listAttendance,
      required this.listHomework,
      required this.listStdDetail,
      required this.percentHw});

  factory ClassOverViewModel.fromData(
      ClassModel classModel,
      List<StudentClassModel> listStdClass,
      List<StudentModel> students,
      List<double> listAttendance,
      List<double> listHomework,
      List<Map<String, dynamic>> listStdDetail,
      double percentHw,
      double averagePts,) {
    return ClassOverViewModel(
        classModel: classModel,
        listStdClass: listStdClass,
        students: students,
        listAttendance: listAttendance,
        listHomework: listHomework,
        percentHw: percentHw,
        listStdDetail: listStdDetail);
  }
}
