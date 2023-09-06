import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class GradingCubit extends Cubit<int> {
  GradingCubit() : super(0);

  ClassModel? classModel;

  List<LessonModel>? lessons;
  List<StudentLessonModel>? listStudentLessons;
  List<LessonResultModel>? listLessonResult;

  List<TestResultModel>? listTestResult;
  List<StudentTestModel>? listStudentTests;
  List<TestModel>? tests;

  bool isBTVN = true;
  bool isNotGrading = true;


  init(context) async {
    await loadClass(context);
    await loadBTVN(context);
    await loadTest(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    classModel =
        await teacherRepository.getClassById(int.parse(TextUtils.getName()));

    emit(state + 2);
  }

  loadBTVN(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    listLessonResult = await teacherRepository
        .getLessonResultByClassId(int.parse(TextUtils.getName()));
    lessons =
        await teacherRepository.getLessonsByCourseId(classModel!.courseId);
    listStudentLessons = await teacherRepository
        .getAllStudentLesson(int.parse(TextUtils.getName()));
    emit(state + 2);
  }

  loadTest(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    tests = await teacherRepository.getListTestByCourseId(classModel!.courseId);
    listTestResult = await teacherRepository
        .getListTestResult(int.parse(TextUtils.getName()));
    listStudentTests = await teacherRepository
        .getAllStudentTest(int.parse(TextUtils.getName()));
    emit(state + 1);
  }

  update(){
    emit(state+2);
  }

  int getBTVNResultCount(int lessonId, int type){
    int temp = 0;
    if(type == 1){
      for(var i in listStudentLessons!){
        if(i.hw != -2 && i.lessonId == lessonId){
          temp++;
        }
      }
    }else{
      for(var i in listStudentLessons!){
        if(i.hw == -1 && i.lessonId == lessonId){
          temp++;
        }
      }
    }
    return temp;
  }

  int getTestResultCount(int testId, int type){
    int temp = 0;
    if(type == 1){
      for(var i in listStudentTests!){
        if(i.score != -2 && i.testID == testId){
          temp++;
        }
      }
    }else{
      for(var i in listStudentTests!){
        if(i.score == -1 && i.testID == testId){
          temp++;
        }
      }
    }
    return temp;
  }

  List<LessonResultModel> filterListLesson(){
    List<LessonResultModel> list = [];
    if(isNotGrading){
      for(var i in listLessonResult!){
        if(getBTVNResultCount(i.lessonId, 0)!=0){
          list.add(i);
        }
      }
    }else{
      for(var i in listLessonResult!){
        if(getBTVNResultCount(i.lessonId, 0)==0){
          list.add(i);
        }
      }
    }
    return list;
  }
  List<TestResultModel> filterListTest(){
    List<TestResultModel> list = [];
    if(isNotGrading){
      for(var i in listTestResult!){
        if(getTestResultCount(i.testId, 0)!=0){
          list.add(i);
        }
      }
    }else{
      for(var i in listTestResult!){
        if(getTestResultCount(i.testId, 0)==0){
          list.add(i);
        }
      }
    }
    return list;
  }

}
