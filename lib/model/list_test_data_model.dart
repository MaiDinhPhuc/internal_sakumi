import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';

import 'class_model.dart';

class ListTestDataModel {
  List<TestModel> listTest;
  ClassModel classModel;
  List<List<StudentTestModel>> listTestState;
  List<TestResultModel> listTestResult;
  List<double> listSubmit;
  List<double> listGPA;
  List<StudentModel> listStudents;

  ListTestDataModel(
      {required this.listTest,
      required this.listTestState,
      required this.classModel,
      required this.listTestResult,
      required this.listSubmit,
      required this.listGPA,
      required this.listStudents});

  factory ListTestDataModel.fromData(
      List<TestModel> listTest,
      ClassModel classModel,
      List<List<StudentTestModel>> listTestState,
      List<TestResultModel> listTestResult,
      List<double> listSubmit,
      List<double> listGPA,
      List<StudentModel> listStudents) {
    return ListTestDataModel(
        listTest: listTest,
        classModel: classModel,
        listTestState: listTestState,
        listTestResult: listTestResult,
        listSubmit: listSubmit,
        listGPA: listGPA,
        listStudents: listStudents);
  }
}
