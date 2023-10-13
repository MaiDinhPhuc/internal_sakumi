import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class ManageCourseCubit extends Cubit<int>{
  ManageCourseCubit() : super(-1);
  List<CourseModel>? listAllCourse;
  List<CourseModel>? listCourseNow;
  List<LessonModel>? listLesson;
  List<TestModel>? listTest;
  bool canAdd = false;
  int selector = -1;


  loadAllCourse() async {
    listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    listCourseNow = listAllCourse;
    emit(state+1);
  }

  selectedCourse(int index) {
    selector = index;
    canAdd = true;
    emit(state+1);
    loadLessonInCourse(index);
    loadTestInCourse(index);
  }

  loadAfterAdd(CourseModel model){
    listAllCourse!.add(model);
    listCourseNow = listAllCourse;
    selector = model.courseId;
    canAdd = true;
    emit(state+1);
    loadLessonInCourse(model.courseId);
    loadTestInCourse(model.courseId);
  }

  loadAfterAddCourseFromJson()async{
    listAllCourse = await FireBaseProvider.instance.getAllCourseEnable();
    listCourseNow = listAllCourse;
    selector = -1;
    canAdd = false;
    emit(state+1);
  }


  loadAfterDelete(CourseModel model){
    listAllCourse!.remove(model);
    listCourseNow = listAllCourse;
    selector = model.courseId;
    canAdd = false;
    emit(state+1);
  }

  loadAfterEdit(CourseModel model, int id){
    listAllCourse![listAllCourse!.indexOf(listAllCourse!.firstWhere((element) => element.courseId == id))] = model;
    selector = model.courseId;
    listCourseNow = listAllCourse;
    canAdd = true;
    emit(state+1);
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