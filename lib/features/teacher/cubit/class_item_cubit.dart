import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/home_teacher/class_statistic_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';

class ClassItemCubit extends Cubit<int> {
  final ClassModel2 classModel;
  ClassItemCubit(this.classModel) : super(0) {
    load();
  }
  double? lessonPercent;
  ClassStatisticModel? classStatistic;
  String lastLesson = "";
  load() async {
    lessonPercent = classModel.lessonCount == null || classModel.course == null
        ? 0
        : (classModel.lessonCount! / classModel.course!.lessonCount);
    emit(state + 1);
    if(classModel.stdLessons != null){
      loadInfoStatistic();
    }
  }

  loadInfoStatistic() async {
    List<int> listStdIdsEnable = [];

    for (var element in classModel.stdClasses!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }

    var stdLessons = classModel.stdLessons!
        .where(
            (e) => listStdIdsEnable.contains(e.studentId) && e.timekeeping != 0)
        .toList();
    var listStatus = classModel.stdClasses!.map((e) => e.classStatus).toList();
    List<LessonResultModel> listLessonResult = classModel.lessonResults!;

    List<int> listLessonId = [];
    for (var i in listLessonResult) {
      if (listLessonId.contains(i.lessonId) == false) {
        listLessonId.add(i.lessonId);
      }
    }
    List<LessonModel> lessonTemp =
        classModel.listLesson!.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    classStatistic = ClassStatisticModel.make(stdLessons, listStatus,
        classModel.classModel.classId, listLessonId, lessonExceptionIds);

    var lastLesson = classModel.listLesson!.firstWhere((e) => e.lessonId == classModel.lessonResults!.last.lessonId);
    this.lastLesson = lastLesson.title;

    emit(state + 1);
  }
}
