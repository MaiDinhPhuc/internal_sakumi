import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ManageCourseCubit extends Cubit<int> {
  ManageCourseCubit() : super(-1);
  List<CourseModel>? listAllCourse;
  List<CourseModel>? listCourseNow;
  List<LessonModel>? listLesson;
  List<TestModel>? listTest;
  bool canAdd = false;
  int selector = -1;
  List<String> listStatus = ["Enable", "Disable"];
  List<bool> listState = [true, false];

  loadAllCourse() async {
    listAllCourse = await FireBaseProvider.instance.getAllCourse();
    filter();
    //listCourseNow = listAllCourse!.where((element) => element.enable == true).toList();
    emit(state + 1);
  }

  filter() {
    listCourseNow = [];
    if (listState.contains(false) == false) {
      listCourseNow = listAllCourse;
    } else {
      if (listState[0] == true) {
        List<CourseModel> list =
            listAllCourse!.where((element) => element.enable == true).toList();
        listCourseNow = listCourseNow! + list;
      }
      if (listState[1] == true) {
        List<CourseModel> list =
            listAllCourse!.where((element) => element.enable == false).toList();
        listCourseNow = listCourseNow! + list;
      }
    }
    selector = -1;
    canAdd = false;
    emit(state + 1);
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
    filter();
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
    filter();
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
        token: model.token,
        code: model.code,
        enable: value,
        version: model.version);
    filter();
  }

  loadAfterEdit(CourseModel model, int id) {
    listAllCourse![listAllCourse!.indexOf(
            listAllCourse!.firstWhere((element) => element.courseId == id))] =
        model;
    selector = model.courseId;
    filter();
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

  loadTestInCourse(int selector) async {
    listTest = null;
    listTest = await FireBaseProvider.instance.getListTestByCourseId(selector);
    emit(state + 1);
  }
}
