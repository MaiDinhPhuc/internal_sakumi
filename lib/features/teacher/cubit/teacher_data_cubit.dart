import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCubit extends Cubit<int> {
  List<ClassModel2>? classes;

  List<ClassModel2>? classNow;

  List<bool> listFilter = [true, false];
  List<String> listClassStatusMenu = ["InProgress", "Completed"];

  DataCubit() : super(0) {
    loadClass();
  }

  loadClass() async {
    classes = null;
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    if (userId == null || userId == -1) return;

    var user = await FireBaseProvider.instance.getUserById(userId);

    if (user.role == 'master') return;

    if (user.role == 'teacher') {
      loadClassForTeacherRole(userId);
    } else {
      loadClassForAdminRole();
    }

    debugPrint("======================> loadClass");
  }

  loadClassForTeacherRole(int userId) async {
    classes = await FireBaseProvider.instance.getClassByTeacherId(userId);
    filter();
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
      var lessonCount = await FireBaseProvider.instance.getCountWithCondition(
          "lesson_result", "class_id", i.classModel.classId);
      classes![classes!.indexOf(i)] = i.copyWith(
          null, null, lessonCount, null, null, null, null, null, null, null);
      filter();
    }
    var courses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      var course =
          courses.firstWhere((e) => e.courseId == i.classModel.courseId);
      classes![classes!.indexOf(i)] = i.copyWith(
          null, course, null, null, null, null, null, null, null, null);
      filter();
    }
    for (var i in classes!) {
      var lessons = await FireBaseProvider.instance
          .getLessonsByCourseId(i.classModel.courseId);
      var stdClasses = await FireBaseProvider.instance
          .getStudentClassInClass(i.classModel.classId);
      var lessonResults = await FireBaseProvider.instance
          .getLessonResultByClassId(i.classModel.classId);
      var stdLessons = await FireBaseProvider.instance
          .getAllStudentLessonsInClass(i.classModel.classId);
      classes![classes!.indexOf(i)] = i.copyWith(null, null, null, lessons,
          stdClasses, lessonResults, stdLessons, null, null, null);
      filter();
    }
    for (var i in classes!) {
      var listTest = await FireBaseProvider.instance
          .getListTestByCourseId(i.classModel.courseId);
      var testResults = await FireBaseProvider.instance
          .getListTestResult(i.classModel.classId);
      List<int> listTestIds = [];
      for (var j in listTest) {
        listTestIds.add(j.id);
      }
      var stdTests =
          await FireBaseProvider.instance.getListStudentTestByIDs(listTestIds);
      classes![classes!.indexOf(i)] = i.copyWith(null, null, null, null, null,
          null, null, stdTests, listTest, testResults);
      filter();
    }
  }

  filter() {
    classNow = [];
    if (listFilter[0] == true) {
      for (var i in classes!) {
        if (i.classModel.classStatus == listClassStatusMenu[0] ||
            i.classModel.classStatus == "Preparing") {
          classNow!.add(i);
        }
      }
    }
    if (listFilter[1] == true) {
      for (var i in classes!) {
        if (i.classModel.classStatus == listClassStatusMenu[1]) {
          classNow!.add(i);
        }
      }
    }
    emit(state + 1);
  }

  loadClassForAdminRole() async {
    classes = await FireBaseProvider.instance.getClassByAdmin();
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
      var lessonCount = await FireBaseProvider.instance.getCountWithCondition(
          "lesson_result", "class_id", i.classModel.classId);
      classes![classes!.indexOf(i)] = i.copyWith(
          null, null, lessonCount, null, null, null, null, null, null, null);
      emit(state+1);
    }
    var courses =
    await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      var course =
      courses.firstWhere((e) => e.courseId == i.classModel.courseId);
      classes![classes!.indexOf(i)] = i.copyWith(
          null, course, null, null, null, null, null, null, null, null);
      emit(state+1);
    }
    for (var i in classes!) {
      var lessons = await FireBaseProvider.instance
          .getLessonsByCourseId(i.classModel.courseId);
      var stdClasses = await FireBaseProvider.instance
          .getStudentClassInClass(i.classModel.classId);
      var lessonResults = await FireBaseProvider.instance
          .getLessonResultByClassId(i.classModel.classId);
      var stdLessons = await FireBaseProvider.instance
          .getAllStudentLessonsInClass(i.classModel.classId);
      classes![classes!.indexOf(i)] = i.copyWith(null, null, null, lessons,
          stdClasses, lessonResults, stdLessons, null, null, null);
      emit(state+1);
    }
    for (var i in classes!) {
      var listTest = await FireBaseProvider.instance
          .getListTestByCourseId(i.classModel.courseId);
      var testResults = await FireBaseProvider.instance
          .getListTestResult(i.classModel.classId);
      List<int> listTestIds = [];
      for (var j in listTest) {
        listTestIds.add(j.id);
      }
      var stdTests =
      await FireBaseProvider.instance.getListStudentTestByIDs(listTestIds);
      classes![classes!.indexOf(i)] = i.copyWith(null, null, null, null, null,
          null, null, stdTests, listTest, testResults);
      emit(state+1);
    }
  }

  updateLessonResults(int classId, LessonResultModel resultModel){
    var index = classes!.indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<LessonResultModel> listResult = classes![index].lessonResults!;

    var check = listResult.any((e) => e.lessonId == resultModel.lessonId);

    if(check == false){
      listResult.add(resultModel);
    }else{
      var i = listResult.indexOf(listResult.firstWhere((e) => e.lessonId == resultModel.lessonId));
      listResult[i] = resultModel;
    }
    classes![index] = classes![index].copyWith(null, null, null, null,
        null, listResult, null, null, null, null);
  }

  updateStudentLesson(int classId, StudentLessonModel stdLesson){
    var index = classes!.indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentLessonModel> stdLessons = classes![index].stdLessons!;

    var check = stdLessons.any((e) => e.lessonId == stdLesson.lessonId && e.studentId == stdLesson.studentId);

    if(check == false){
      stdLessons.add(stdLesson);
    }else{
      var i = stdLessons.indexOf(stdLessons.firstWhere((e) => e.lessonId == stdLesson.lessonId && e.studentId == stdLesson.studentId));
      stdLessons[i] = stdLesson;
    }
    classes![index] = classes![index].copyWith(null, null, null, null,
        null, null, stdLessons, null, null, null);
  }

  updateStudentClass(int classId, StudentClassModel studentClassModel){
    var index = classes!.indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentClassModel> stdClasses = classes![index].stdClasses!;

    var i = stdClasses.indexOf(stdClasses.firstWhere((e) => e.userId == studentClassModel.userId));
    stdClasses[i] = studentClassModel;
    classes![index] = classes![index].copyWith(null, null, null, null,
        stdClasses, null, null, null, null, null);
  }
}
