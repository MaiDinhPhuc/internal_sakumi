import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCubit extends Cubit<int> {
  List<ClassModel2>? classes;


  List<TeacherModel>? teachers;

  List<ClassModel2>? classNow;

  List<UserModel>? users;


  final SearchCubit searchCubit = SearchCubit();

  List<bool> listFilterTeacher = [true, false];
  List<String> listClassStatusMenuTeacher = ["InProgress", "Completed"];
  List<bool> listClassStatusFilter = [true, true, false, false];
  List<String> listClassStatusMenuAdmin = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel"
  ];
  List<bool> listCourseTypeFilter = [false, false, false, false, false];
  List<String> listCourseTypeMenuAdmin = [
    "GENERAL",
    "KAIWA",
    "JLPT",
    "KID",
    "1VS1"
  ];
  List<bool> levelFilter = [true, false, false, false, false];
  List<String> listLevelMenu = ["N5", "N4", "N3", "N2", "N1"];
  List<bool> listClassTypeFilter = [true, true];
  List<String> listClassTypeMenu = ["Lớp Chung", "Lớp 1-1"];

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
    filterInTeacher();
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
    }
    var courses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].course == null) {
        var course =
            courses.firstWhere((e) => e.courseId == i.classModel.courseId);
        classes![classes!.indexOf(i)] = i.copyWith(course: course);
      }
      filterInTeacher();
    }
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdLessons == null) {
        var lessons = await FireBaseProvider.instance
            .getLessonsByCourseId(i.classModel.courseId);
        var stdClasses = await FireBaseProvider.instance
            .getStudentClassInClass(i.classModel.classId);
        var lessonResults = await FireBaseProvider.instance
            .getLessonResultByClassId(i.classModel.classId);
        var stdLessons = await FireBaseProvider.instance
            .getAllStudentLessonsInClass(i.classModel.classId);
        var listStdIds = stdClasses.map((e) => e.userId).toList();
        var students = await FireBaseProvider.instance
            .getAllStudentInFoInClass(listStdIds);
        classes![classes!.indexOf(i)] = i.copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons,
            lessonCount: lessonResults.length,
            students: students);
      }
      filterInTeacher();
    }
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdTests == null) {
        var listTest = await FireBaseProvider.instance
            .getListTestByCourseId(i.classModel.courseId);
        var testResults = await FireBaseProvider.instance
            .getListTestResult(i.classModel.classId);
        var stdTests = await FireBaseProvider.instance
            .getAllStudentTest(i.classModel.classId);
        classes![classes!.indexOf(i)] = i.copyWith(
            stdTests: stdTests, listTest: listTest, testResults: testResults);
      }
      filterInTeacher();
    }
  }

  loadLessonInfoOfClass(ClassModel classModel) async {
    var lessons = await FireBaseProvider.instance
        .getLessonsByCourseId(classModel.courseId);
    var stdClasses = await FireBaseProvider.instance
        .getStudentClassInClass(classModel.classId);
    var lessonResults = await FireBaseProvider.instance
        .getLessonResultByClassId(classModel.classId);
    var stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInClass(classModel.classId);
    var listStdIds = stdClasses.map((e) => e.userId).toList();
    var students = await FireBaseProvider.instance
        .getAllStudentInFoInClass(listStdIds);
    classes![classes!.indexOf(classes!
        .firstWhere((e) => e.classModel.classId == classModel.classId))] =
        classes![classes!.indexOf(classes!.firstWhere(
                (e) => e.classModel.classId == classModel.classId))]
            .copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons,
            lessonCount: lessonResults.length,
            students: students);

    emit(state + 1);
  }

  loadTestInfoOfClass(ClassModel classModel) async {
    var listTest = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);
    var testResults =
        await FireBaseProvider.instance.getListTestResult(classModel.classId);
    var stdTests =
        await FireBaseProvider.instance.getAllStudentTest(classModel.classId);
    var stdClasses = await FireBaseProvider.instance
        .getStudentClassInClass(classModel.classId);
    var listStdIds = stdClasses.map((e) => e.userId).toList();
    var students = await FireBaseProvider.instance
        .getAllStudentInFoInClass(listStdIds);
    classes![classes!.indexOf(classes!
        .firstWhere((e) => e.classModel.classId == classModel.classId))] =
        classes![classes!.indexOf(classes!.firstWhere(
                (e) => e.classModel.classId == classModel.classId))]
            .copyWith(
            stdTests: stdTests,
            listTest: listTest,
            testResults: testResults,
            students: students,
        stdClasses: stdClasses);

    emit(state + 1);
  }

  loadDataForGradingTab(ClassModel classModel) async {
    var lessons = await FireBaseProvider.instance
        .getLessonsByCourseId(classModel.courseId);
    var stdClasses = await FireBaseProvider.instance
        .getStudentClassInClass(classModel.classId);
    var lessonResults = await FireBaseProvider.instance
        .getLessonResultByClassId(classModel.classId);
    var stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInClass(classModel.classId);
    var listStdIds = stdClasses.map((e) => e.userId).toList();
    var students = await FireBaseProvider.instance
        .getAllStudentInFoInClass(listStdIds);
    var listTest = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);
    var testResults =
    await FireBaseProvider.instance.getListTestResult(classModel.classId);
    var stdTests =
    await FireBaseProvider.instance.getAllStudentTest(classModel.classId);
    classes![classes!.indexOf(classes!.firstWhere(
            (e) => e.classModel.classId == classModel.classId))] = classes![classes!
        .indexOf(classes!
        .firstWhere((e) => e.classModel.classId == classModel.classId))]
        .copyWith(
        stdTests: stdTests,
        listTest: listTest,
        testResults: testResults,
        lessonResults: lessonResults,
        lessonCount: lessonResults.length,
        listLesson: lessons,
        stdClasses: stdClasses,
        stdLessons: stdLessons,
        students: students);

    emit(state + 1);
  }

  filterInTeacher() {
    classNow = [];
    if (listFilterTeacher[0] == true) {
      for (var i in classes!) {
        if (i.classModel.classStatus == listClassStatusMenuTeacher[0] ||
            i.classModel.classStatus == "Preparing") {
          classNow!.add(i);
        }
      }
    }
    if (listFilterTeacher[1] == true) {
      for (var i in classes!) {
        if (i.classModel.classStatus == listClassStatusMenuTeacher[1]) {
          classNow!.add(i);
        }
      }
    }
    emit(state + 1);
  }

  filterInAdmin() {
    var list1 = [];
    var list2 = [];
    var list3 = [];
    var list4 = [];

    for (int i = 0; i < listClassTypeFilter.length; i++) {
      if (listClassTypeFilter[i] == true) {
        list1.add(i);
      }
    }

    for (int i = 0; i < listCourseTypeFilter.length; i++) {
      if (listCourseTypeFilter[i] == true) {
        list2.add(listCourseTypeMenuAdmin[i]);
      }
    }

    for (int i = 0; i < listClassStatusFilter.length; i++) {
      if (listClassStatusFilter[i] == true) {
        list3.add(listClassStatusMenuAdmin[i]);
      }
    }

    for (int i = 0; i < levelFilter.length; i++) {
      if (levelFilter[i] == true) {
        list4.add(listLevelMenu[i]);
      }
    }

    classNow = classes!
        .where((e) =>
            list3.contains(e.classModel.classStatus) &&
            list1.contains(e.classModel.classType) &&
            (list2.isEmpty
                ? true
                : list2.contains(e.course!.type.toUpperCase())) &&
            (list4.isEmpty
                ? true
                : list4.contains(e.course!.level.toUpperCase())))
        .toList();

    emit(state + 1);
  }

  loadClassForAdminRole() async {
    classes = await FireBaseProvider.instance.getClassByAdmin();
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
    }
    var courses = await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].course == null) {
        var course =
            courses.firstWhere((e) => e.courseId == i.classModel.courseId);
        classes![classes!.indexOf(i)] = i.copyWith(course: course);
      }
      emit(state + 1);
    }
    filterInAdmin();
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdLessons == null) {
        var lessons = await FireBaseProvider.instance
            .getLessonsByCourseId(i.classModel.courseId);
        var stdClasses = await FireBaseProvider.instance
            .getStudentClassInClass(i.classModel.classId);
        var lessonResults = await FireBaseProvider.instance
            .getLessonResultByClassId(i.classModel.classId);
        var stdLessons = await FireBaseProvider.instance
            .getAllStudentLessonsInClass(i.classModel.classId);
        var listStdIds = stdClasses.map((e) => e.userId).toList();
        var students = await FireBaseProvider.instance
            .getAllStudentInFoInClass(listStdIds);
        classes![classes!.indexOf(i)] = i.copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons,
            lessonCount: lessonResults.length,
            students: students);
      }
      filterInAdmin();
    }
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdTests == null) {
        var listTest = await FireBaseProvider.instance
            .getListTestByCourseId(i.classModel.courseId);
        var testResults = await FireBaseProvider.instance
            .getListTestResult(i.classModel.classId);
        var stdTests = await FireBaseProvider.instance
            .getAllStudentTest(i.classModel.classId);
        classes![classes!.indexOf(i)] = i.copyWith(
            stdTests: stdTests, listTest: listTest, testResults: testResults);
      }
      filterInAdmin();
    }
  }

  updateLessonResults(int classId, LessonResultModel resultModel) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<LessonResultModel> listResult = classes![index].lessonResults!;

    var check = listResult.any((e) => e.lessonId == resultModel.lessonId);

    if (check == false) {
      listResult.add(resultModel);
    } else {
      var i = listResult.indexOf(
          listResult.firstWhere((e) => e.lessonId == resultModel.lessonId));
      listResult[i] = resultModel;
    }
    classes![index] = classes![index].copyWith(lessonResults: listResult);
  }

  updateStudentLesson(int classId, StudentLessonModel stdLesson) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentLessonModel> stdLessons = classes![index].stdLessons!;

    var check = stdLessons.any((e) =>
        e.lessonId == stdLesson.lessonId && e.studentId == stdLesson.studentId);

    if (check == false) {
      stdLessons.add(stdLesson);
    } else {
      var i = stdLessons.indexOf(stdLessons.firstWhere((e) =>
          e.lessonId == stdLesson.lessonId &&
          e.studentId == stdLesson.studentId));
      stdLessons[i] = stdLesson;
    }
    classes![index] = classes![index].copyWith(stdLessons: stdLessons);
  }

  updateStudentLessonAfterGrading(
      int classId, int lessonId, int studentId, int hw) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentLessonModel> stdLessons = classes![index].stdLessons!;

    var stdLesson = stdLessons
        .firstWhere((e) => e.lessonId == lessonId && e.studentId == studentId);

    var check = stdLessons.any(
        (e) => e.lessonId == lessonId && e.studentId == stdLesson.studentId);

    if (check == false) {
      stdLessons.add(StudentLessonModel(
          grammar: stdLesson.grammar,
          hw: hw,
          id: stdLesson.id,
          classId: classId,
          kanji: stdLesson.kanji,
          lessonId: lessonId,
          listening: stdLesson.listening,
          studentId: studentId,
          timekeeping: stdLesson.timekeeping,
          vocabulary: stdLesson.vocabulary,
          teacherNote: stdLesson.teacherNote,
          supportNote: stdLesson.supportNote,
          time: stdLesson.time));
    } else {
      var i = stdLessons.indexOf(stdLessons.firstWhere((e) =>
          e.lessonId == stdLesson.lessonId &&
          e.studentId == stdLesson.studentId));
      stdLessons[i] = StudentLessonModel(
          grammar: stdLesson.grammar,
          hw: hw,
          id: stdLesson.id,
          classId: classId,
          kanji: stdLesson.kanji,
          lessonId: lessonId,
          listening: stdLesson.listening,
          studentId: studentId,
          timekeeping: stdLesson.timekeeping,
          vocabulary: stdLesson.vocabulary,
          teacherNote: stdLesson.teacherNote,
          supportNote: stdLesson.supportNote,
          time: stdLesson.time);
    }
    classes![index] = classes![index].copyWith(stdLessons: stdLessons);
  }

  updateStudentTestAfterGrading(
      int classId, int testId, int studentId, double score) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentTestModel> stdTests = classes![index].stdTests!;

    var stdTest = stdTests
        .firstWhere((e) => e.testID == testId && e.studentId == studentId);

    var check = stdTests
        .any((e) => e.testID == testId && e.studentId == stdTest.studentId);

    if (check == false) {
      stdTests.add(StudentTestModel(
          classId: classId,
          score: score,
          studentId: studentId,
          testID: testId,
          time: stdTest.time));
    } else {
      var i = stdTests.indexOf(stdTests.firstWhere((e) =>
          e.testID == stdTest.testID && e.studentId == stdTest.studentId));
      stdTests[i] = StudentTestModel(
          classId: classId,
          score: score,
          studentId: studentId,
          testID: testId,
          time: stdTest.time);
    }
    classes![index] = classes![index].copyWith(stdTests: stdTests);
  }

  updateStudentClass(int classId, StudentClassModel studentClassModel) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentClassModel> stdClasses = classes![index].stdClasses!;

    var i = stdClasses.indexOf(
        stdClasses.firstWhere((e) => e.userId == studentClassModel.userId));
    stdClasses[i] = studentClassModel;
    classes![index] = classes![index].copyWith(stdClasses: stdClasses);
  }

  updateClassStatus(ClassModel classModel) {
    var index = classes!.indexOf(
        classes!.firstWhere((e) => e.classModel.classId == classModel.classId));
    classes![index] = classes![index].copyWith(classModel: classModel);
  }
}
