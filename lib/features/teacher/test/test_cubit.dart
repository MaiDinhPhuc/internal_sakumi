import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestCubit extends Cubit<int> {
  TestCubit() : super(0);

  List<TestModel>? listTest;
  ClassModel? classModel;
  List<List<StudentTestModel>>? listTestState;
  List<TestResultModel>? listTestResult;
  List<double>? listSubmit;
  List<double>? listGPA;
  List<StudentModel>? listStudents;
  List<bool?>? listStatus;

  load(int classId, DataCubit dataCubit) async {
    var temp = dataCubit.classes!
        .where((e) => e.classModel.classId == classId)
        .toList();
    if (temp.isEmpty) {
      dataCubit.loadMoreClass(classId);
    } else {
      var model = temp.first;
    if (model.stdTests == null) {
      classModel = model.classModel;
      emit(state + 1);
      dataCubit.loadTestInfoOfClass(model.classModel);
    } else {
      classModel = model.classModel;
      emit(state + 1);
      listTest = model.listTest;
      listTestResult = model.testResults;
      List<int> listTestIds = [];
      for (var i in model.listTest!) {
        listTestIds.add(i.id);
      }

      List<StudentTestModel> listStdTest = model.stdTests!
          .where((element) => element.classId == model.classModel.classId)
          .toList();
      List<StudentClassModel> listStudentClass = model.stdClasses!;
      List<int> listStudentIds = [];
      for (var element in listStudentClass) {
        if (element.classStatus != "Remove" &&
            element.classStatus != "Moved" &&
            element.classStatus != "Retained" &&
            element.classStatus != "Dropped" &&
            element.classStatus != "Deposit" &&
            element.classStatus != "Viewer") {
          listStudentIds.add(element.userId);
        }
      }
      List<List<StudentTestModel>> listTestState = [];
      listStatus = [];
      for (var i in listTestIds) {
        List<StudentTestModel> listTemp =
            listStdTest.where((element) => element.testID == i && listStudentIds.contains(element.studentId)).toList();
        listTestState.add(listTemp);
        bool? status;
        if (listTemp.isEmpty) {
          status = null;
        } else {
          int submitCount = 0;
          int checkCount = 0;
          int notSubmitCount = 0;
          for (var k in listTemp) {
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
          if (notSubmitCount == listTemp.length) {
            status = null;
          }
        }
        listStatus!.add(status);
      }


      List<StudentModel> listStudents = model.students!.where((e) => listStudentIds.contains(e.userId)).toList();

      List<double> listSubmit = [];
      List<double> listGPA = [];
      for (var i in listTestState) {
        int temp = 0;
        double sum = 0;
        int count = 0;
        if (i.isNotEmpty) {
          for (var j in i) {
            if (j.score > -2) {
              temp++;
              if (j.score > -1) {
                sum = sum + j.score;
                count++;
              }
            }
          }
        }
        listSubmit.add(temp / listStudents.length);
        listGPA.add(sum / (count == 0 ? 1 : count));
      }
      this.listTestState = listTestState;
      this.listSubmit = listSubmit;
      this.listGPA = listGPA;
      this.listStudents = listStudents;
      emit(state + 1);
    }
  }}

  reloadAfterAssignment(int classId, int courseId, int testId) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    int teacherId =
        int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    listTestResult!.add(TestResultModel(
        classId: classId,
        testId: testId,
        courseId: courseId,
        teacherId: teacherId,
        date: formattedDate));
    emit(state + 1);
  }

  bool checkGrading(int testId) {
    for (var i in listTestResult!) {
      if (i.testId == testId) {
        return true;
      }
    }
    return false;
  }

  bool checkAlready(int testId) {
    return listTestResult!.any((element) => element.testId == testId);
  }

  double checkSubmitted(int studentId, int testId) {
    for (var i in listTestState!) {
      bool checkExist = i.any((element) =>
          element.studentId == studentId && element.testID == testId);
      if (checkExist) {
        StudentTestModel temp = i.firstWhere((element) =>
            element.studentId == studentId && element.testID == testId);
        return temp.score;
      }
    }

    return -2;
  }

  assignmentTest(context, int classId, int courseId, int testId) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    int teacherId =
        int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    CollectionReference create =
        FirebaseFirestore.instance.collection('test_result');
    create
        .doc('test_${testId}_class_$classId')
        .set({
          'class_id': classId,
          'course_id': courseId,
          'date': formattedDate,
          'teacher_id': teacherId,
          'test_id': testId,
        })
        .then((value) => debugPrint("test result Added"))
        .catchError((error) => debugPrint("Failed to add test result: $error"))
        .whenComplete(() {
          Navigator.of(context).pop();
          reloadAfterAssignment(classId, courseId, testId);
        });
  }
}
