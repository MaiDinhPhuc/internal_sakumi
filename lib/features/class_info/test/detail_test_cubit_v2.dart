import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (cubit.listStdClass != null) {
      listStdClass = cubit.listStdClass!;
    }

    if (cubit.listTestResult != null) {
      listTestResult =
          cubit.listTestResult!.where((e) => e.testId == testModel.id).toList();
    }

    if (cubit.stdTests != null) {
      stdTests =
          cubit.stdTests!.where((e) => e.testID == testModel.id).toList();
    }

    if (cubit.students.isNotEmpty) {
      students = cubit.students;
    }
    emit(state + 1);
  }

  assignTest(int index, BuildContext context) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    int teacherId =
        int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    listTestResult!.add(TestResultModel(
        classId: cubit.classId,
        testId: testModel.id,
        courseId: cubit.classModel!.courseId,
        teacherId: teacherId,
        date: formattedDate));
    await cubit.updateListTestResult(TestResultModel(
        classId: cubit.classId,
        testId: testModel.id,
        courseId: cubit.classModel!.courseId,
        teacherId: teacherId,
        date: formattedDate));
    Navigator.of(context).pop();
    CollectionReference create =
        FirebaseFirestore.instance.collection('test_result');
    create
        .doc('test_${testModel.id}_class_${cubit.classId}')
        .set({
          'class_id': cubit.classId,
          'course_id': cubit.classModel!.courseId,
          'date': formattedDate,
          'teacher_id': teacherId,
          'test_id': testModel.id,
        })
        .then((value) => debugPrint("test result Added"))
        .catchError((error) => debugPrint("Failed to add test result: $error"));
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
      List<StudentTestModel> listStdTest = stdTests!.where((e) => getStudentId().contains(e.studentId)).toList();
      for (var j in listStdTest) {
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
