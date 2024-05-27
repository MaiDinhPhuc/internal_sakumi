import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageCourseCubit extends Cubit<int> {
  ManageCourseCubit() : super(-1);
  List<CourseModel>? listAllCourse;
  List<LessonModel>? listLesson;
  List<TestModel>? listTest;
  bool canAdd = false;
  int selector = -1;
  List<String> listStatus = ["Enable", "Disable"];
  List<bool> listStatusState = [true, false];

  List<String> listLevel = ["N5", "N4", "N3", "N2", "N1"];
  List<bool> listLevelState = [true, true, true, true, true];

  List<String> listType = ["general", "kaiwa", "JLPT", "kid", "sub"];
  List<bool> listTypeState = [true, true, true, true, true];

  loadAllCourse() async {
    listAllCourse ??= await FireBaseProvider.instance.getAllCourse();
    filter();
  }

  filter() {
    selector = -1;
    canAdd = false;
    emit(state + 1);
  }

  List<CourseModel> getListCourse(){

    List<CourseModel> listCourseTemp = [];
    if (listStatusState.contains(false) == false) {
      listCourseTemp = listAllCourse!;
    } else {
      if (listStatusState[0] == true) {
        List<CourseModel> list =
            listAllCourse!.where((element) => element.enable == true).toList();
        listCourseTemp = listCourseTemp + list;
      }
      if (listStatusState[1] == true) {
        List<CourseModel> list =
            listAllCourse!.where((element) => element.enable == false).toList();
        listCourseTemp = listCourseTemp + list;
      }
    }

    List<String> listLevel = [];
    List<String> listType = [];

    for(int i = 0; i < this.listLevel.length; i++){
      if(listLevelState[i]){
        listLevel.add(this.listLevel[i]);
      }
    }

    for(int i = 0; i < this.listType.length; i++){
      if(listTypeState[i]){
        listType.add(this.listType[i].toUpperCase());
      }
    }


    List<CourseModel> listCourse = listCourseTemp.where((e) => listLevel.contains(e.level) && listType.contains(e.type.toUpperCase())).toList();

    return listCourse;
  }

  selectedCourse(int index) {
    selector = index;
    canAdd = true;
    emit(state + 1);
    loadLessonInCourse(index);
    loadTestInCourse(index);
  }

  loadAfterAdd(CourseModel model) {
    listAllCourse!.add(model);
    //filter();
    //listCourseNow = listAllCourse;
    selector = model.courseId;
    canAdd = true;
    emit(state + 1);
    loadLessonInCourse(model.courseId);
    loadTestInCourse(model.courseId);
  }

  loadAfterAddCourseFromJson() async {
    listAllCourse = await FireBaseProvider.instance.getAllCourse();
    //listCourseNow = listAllCourse!.where((element) => element.enable == true).toList();
    //filter();
    selector = -1;
    canAdd = false;
    emit(state + 1);
  }

  loadAfterChangeStatus(CourseModel model, bool value) {
    int index = listAllCourse!.indexOf(model);

    listAllCourse![index] = CourseModel(
        courseId: model.courseId,
        description: model.description,
        lessonCount: model.lessonCount,
        level: model.level,
        termId: model.termId,
        termName: model.termName,
        title: model.title,
        type: model.type,
        btvnToken: model.btvnToken,
        code: model.code,
        enable: value,
        version: model.version,
        prefix: model.prefix,
        suffix: model.suffix, dataToken: model.dataToken);
    filter();
  }

  loadAfterEdit(CourseModel model, int id) {
    listAllCourse![listAllCourse!.indexOf(
            listAllCourse!.firstWhere((element) => element.courseId == id))] =
        model;
    selector = model.courseId;
    //filter();
    //listCourseNow = listAllCourse;
    canAdd = true;
    emit(state + 1);
    loadLessonInCourse(model.courseId);
    loadTestInCourse(model.courseId);
  }

  loadLessonInCourse(int selector) async {
    listLesson = null;
    listLesson = await FireBaseProvider.instance.getLessonsByCourseId(selector);
    emit(state + 1);
  }

  updateLesson(LessonModel lesson){
    var index = listLesson!.indexOf(listLesson!.firstWhere((e) => e.lessonId == lesson.lessonId));
    listLesson![index] = lesson;
    emit(state+1);
  }

  loadTestInCourse(int selector) async {
    listTest = null;
    listTest = await FireBaseProvider.instance.getListTestByCourseId(selector);
    emit(state + 1);
  }
}
