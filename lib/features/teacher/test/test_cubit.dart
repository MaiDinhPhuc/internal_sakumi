import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/list_test_data_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestCubit extends Cubit<int> {
  TestCubit() : super(0);


  ListTestDataModel? data;

  List<TestModel>? listTest;
  ClassModel? classModel;
  List<List<StudentTestModel>>? listTestState;
  List<TestResultModel>? listTestResult;
  List<double>? listSubmit;
  List<double>? listGPA;
  List<StudentModel>? listStudents;

  load()async{
    data = await FireBaseProvider.instance.getDataForTestTab(int.parse(TextUtils.getName()));
    listTest = data!.listTest;
    classModel = data!.classModel;
    listTestState = data!.listTestState;
    listTestResult = data!.listTestResult;
    listSubmit = data!.listSubmit;
    listGPA = data!.listGPA;
    listStudents = data!.listStudents;
    emit(state+1);
  }

  // init(context) async {
  //   classModel =
  //       await FireBaseProvider.instance.getClassById(int.parse(TextUtils.getName()));
  //   listTest =
  //       await FireBaseProvider.instance.getListTestByCourseId(classModel!.courseId);
  //   listTestState = [];
  //   for (var i in listTest!) {
  //     listTestState!.add(await FireBaseProvider.instance.getListStudentTest(
  //         int.parse(TextUtils.getName()), i.id));
  //   }
  //   List<StudentClassModel> listStudentClass = await FireBaseProvider.instance
  //       .getStudentClassInClass(int.parse(TextUtils.getName()));
  //   listStudents = [];
  //   for (var i in listStudentClass) {
  //     if(i.classStatus != "Remove"){
  //       listStudents!.add(await FireBaseProvider.instance.getStudentInfo(i.userId));
  //     }
  //   }
  //   listSubmit = [];
  //   listGPA = [];
  //   for (var i in listTestState!) {
  //     int temp = 0;
  //     int sum = 0;
  //     int count = 0;
  //     if (i.isNotEmpty) {
  //       for (var j in i) {
  //         if (j.score > -2) {
  //           temp++;
  //           if (j.score > -1) {
  //             sum = sum + j.score;
  //             count++;
  //           }
  //         }
  //       }
  //     }
  //     listSubmit!.add(temp / listStudents!.length);
  //     listGPA!.add(sum / (count == 0 ? 1 : count));
  //   }
  //   listTestResult = await FireBaseProvider.instance
  //       .getListTestResult(int.parse(TextUtils.getName()));
  //   emit(state + 1);
  // }

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

  int checkSubmitted(int studentId, int testId){

    for(var i in listTestState!){
      bool checkExist = i.any((element) => element.studentId == studentId && element.testID == testId);
      if(checkExist){
        StudentTestModel temp = i.firstWhere((element) => element.studentId == studentId && element.testID == testId);
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
        .whenComplete((){
      Navigator.of(context).pop();
      reloadAfterAssignment(classId,courseId,testId);
    });
  }
}
