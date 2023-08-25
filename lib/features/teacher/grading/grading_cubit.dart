import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class GradingCubit extends Cubit<int>{
  GradingCubit():super(0);

  List<LessonResultModel>? listLessonResult;
  ClassModel? classModel;
  List<LessonModel>? lessons;
  List<List<StudentLessonModel>>? listStudentLessons;
  List<int>? listResultNotGradingCount;
  List<int>? listResultCount;

  init(context) async {
    await loadClass(context);
    await loadLessonResult(context);
    await loadStudentLessons(context);
  }

  loadClass(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    classModel =
    await teacherRepository.getClassById(int.parse(TextUtils.getName()));

    emit(state + 1);
  }

  loadLessonResult(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    listLessonResult = await teacherRepository
        .getLessonResultByClassId(int.parse(TextUtils.getName()));

    lessons =
    await teacherRepository.getLessonsByCourseId(classModel!.courseId);

    emit(state + 1);
  }
  loadStudentLessons(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    listStudentLessons = [];
    print("=========>lesson result: ${listLessonResult!.length}");
    for(var i in listLessonResult!){
      var list = await teacherRepository.getAllStudentLessonInLesson(
          int.parse(TextUtils.getName(position: 2)),
          i.lessonId);
      listStudentLessons!.add(list);
    }
    listResultNotGradingCount = [];
    listResultCount = [];
    for(var i in listStudentLessons!){
      int temp1 = 0;
      int temp2 = 0;
      for(var j in i){
        if(j.hw > -2){
          temp1++;
        }
        if(j.hw == -1){
          temp2++;
        }
      }
      listResultCount!.add(temp1);
      listResultNotGradingCount!.add(temp2);
    }

    emit(state + 1);
  }
}