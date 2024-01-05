import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';

class DetailTestV2 extends Cubit<int> {
  DetailTestV2(this.cubit, this.testModel) : super(0) {
    loadData();
  }

  final TestCubitV2 cubit;
  final TestModel testModel;
  List<StudentModel>? students;
  List<TestResultModel>? listTestResult;
  List<StudentTestModel>? stdTests;
  List<StudentClassModel>? listStdClass;

  loadData() async {
    if (cubit.listTestResult != null) {
      listTestResult =
          cubit.listTestResult!.where((e) => e.testId == testModel.id).toList();
    }

    if (cubit.stdTests != null) {
      stdTests =
          cubit.stdTests!.where((e) => e.testID == testModel.id).toList();
    }

    if (cubit.listStdClass != null) {
      listStdClass = cubit.listStdClass!;
    }

    if (cubit.students.isNotEmpty) {
      students = cubit.students;
    }
    emit(state + 1);
  }

  double checkSubmitted(int studentId) {
    bool checkExist =
        stdTests!.any((element) => element.studentId == studentId);
    if (checkExist) {
      StudentTestModel temp =
          stdTests!.firstWhere((element) => element.studentId == studentId);
      return temp.score;
    }
    return -2;
  }

  List<StudentModel> getStudent() {
    var listStudent =
        students!.where((e) => getStudentId().contains(e.userId)).toList();

    return listStudent;
  }

  List<int> getStudentId() {
    List<int> listStudentIds = [];
    for (var element in listStdClass!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStudentIds.add(element.userId);
      }
    }
    return listStudentIds;
  }

  bool? checkGrading() {
    bool? status;
    if (stdTests!.isEmpty) {
      status = null;
    } else {
      int submitCount = 0;
      int checkCount = 0;
      int notSubmitCount = 0;
      for (var k in stdTests!) {
        if (k.score != -2) {
          submitCount++;
        }
        if (k.score > -1) {
          checkCount++;
        }
        if (k.score == -2) {
          notSubmitCount++;
        }
      }
      if (checkCount == submitCount) {
        status = true;
      } else {
        status = false;
      }
      if (notSubmitCount == stdTests!.length) {
        status = null;
      }
    }

    return status;
  }

  double getGPA() {
    double sum = 0;
    int count = 0;
    if (stdTests!.isNotEmpty) {
      for (var j in stdTests!) {
        if (j.score > -1) {
          sum = sum + j.score;
          count++;
        }
      }
    }
    return sum / (count == 0 ? 1 : count);
  }

  double getSubmitPercent() {
    List<StudentModel> listStudents =
        students!.where((e) => getStudentId().contains(e.userId)).toList();
    int temp = 0;
    double sum = 0;
    if (stdTests!.isNotEmpty) {
      for (var j in stdTests!) {
        if (j.score > -2) {
          temp++;
          if (j.score > -1) {
            sum = sum + j.score;
          }
        }
      }
    }
    return temp / listStudents.length;
  }

  bool checkAlready(int testId) {
    return cubit.listTestResult!.any((element) => element.testId == testId);
  }
}
