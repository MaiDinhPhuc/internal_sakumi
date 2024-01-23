import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TestCubitV2 extends Cubit<int>{
  TestCubitV2(this.classId):super(0){
    loadData();
  }

  final int classId;
  ClassModel? classModel;
  List<TestModel>? listTest;
  List<StudentModel> students = [];
  List<TestResultModel>? listTestResult;
  List<StudentTestModel>? stdTests;
  List<StudentClassModel>? listStdClass;

  loadData()async{
    classModel = await FireBaseProvider.instance.getClassById(classId);

    emit(state+1);

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    for(var i in listStdId){
      DataProvider.studentById(i, loadStudentInfo);
    }

    await DataProvider.testResultByClassId(classId, loadTestResult);

    await DataProvider.stdTestByClassId(classId, loadStdTest);

    await DataProvider.testByCourseId(classModel!.courseId, loadTest);
  }

  updateListTestResult(TestResultModel testResult){
    listTestResult!.add(testResult);
    DataProvider.updateTestResult(classId,listTestResult!);
    emit(state+1);
  }

  loadTest(Object test) {
    listTest = test as List<TestModel>;
    sortTest();
  }

  sortTest(){
    var listId = listTestResult!.map((e) => e.testId).toList();

    List<TestModel> listTemp1 = List.of(listTest!).where((e) => listId.contains(e.id)).toList();

    List<TestModel> listTemp2 = List.of(listTest!).where((e) => !listId.contains(e.id)).toList();

    listTest = listTemp1;

    listTest!.addAll(listTemp2);

    emit(state+1);
  }

  loadStdTest(Object stdTest) {
    stdTests = stdTest as List<StudentTestModel>;
  }

  loadTestResult(Object testResult) {
    listTestResult = testResult as List<TestResultModel>;
  }

  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
  }
}