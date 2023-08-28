import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class TestCubit extends Cubit<int>{
  TestCubit():super(0);

  List<TestModel>? listTest;
  ClassModel? classModel;
  List<List<StudentTestModel>>? listTestState;
  List<TestResultModel>? listTestResult;
  List<double>? listSubmit;

  init(context){
    loadListTest(context);
    loadListTestResult(context);
    loadListTestState(context);
  }

  loadListTest(context)async{
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    classModel = await teacherRepository.getClassById(int.parse(TextUtils.getName()));
    listTest = await teacherRepository.getListTestByCourseId(classModel!.courseId);
    emit(state+1);
  }

  loadListTestResult(context)async{
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    listTestResult = await teacherRepository.getListStudentResult(int.parse(TextUtils.getName()));
    emit(state+1);
  }

  loadListTestState(context)async{
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    listTestState = [];
    for(var i in listTest!){
      listTestState!.add(await teacherRepository.getListStudentTest(int.parse(TextUtils.getName()),i.id));
    }
    emit(state+1);
  }

  loadStatistic(context){
    listSubmit = [];
    for(var i in listTestState!){
      double temp = 0;
      if(i.isNotEmpty){
        for(var j in i){
          if(j.score>-2){
            temp++;
          }
        }
        listSubmit!.add(temp/i.length);
      }
    }
  }


}