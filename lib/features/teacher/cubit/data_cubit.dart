import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
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
    filterInTeacher();
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
      if (classes![classes!.indexOf(i)].lessonCount == null) {
        var lessonCount = await FireBaseProvider.instance.getCountWithCondition(
            "lesson_result", "class_id", i.classModel.classId);
        classes![classes!.indexOf(i)] = i.copyWith(lessonCount: lessonCount);
      }
      filterInTeacher();
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
        classes![classes!.indexOf(i)] = i.copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons);
      }
      filterInTeacher();
    }
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdTests == null) {
        var listTest = await FireBaseProvider.instance
            .getListTestByCourseId(i.classModel.courseId);
        var testResults = await FireBaseProvider.instance
            .getListTestResult(i.classModel.classId);
        List<int> listTestIds = [];
        for (var j in listTest) {
          listTestIds.add(j.id);
        }
        var stdTests = await FireBaseProvider.instance
            .getListStudentTestByIDs(listTestIds);
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
    classes![classes!.indexOf(classes!.firstWhere(
        (e) => e.classModel.classId == classModel.classId))] = classes![classes!
            .indexOf(classes!
                .firstWhere((e) => e.classModel.classId == classModel.classId))]
        .copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons);
    emit(state + 1);
  }

  loadTestInfoOfClass(ClassModel classModel) async {
    var listTest = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);
    var testResults =
        await FireBaseProvider.instance.getListTestResult(classModel.classId);
    List<int> listTestIds = [];
    for (var j in listTest) {
      listTestIds.add(j.id);
    }
    var stdTests =
        await FireBaseProvider.instance.getListStudentTestByIDs(listTestIds);
    classes![classes!.indexOf(classes!.firstWhere(
        (e) => e.classModel.classId == classModel.classId))] = classes![classes!
            .indexOf(classes!
                .firstWhere((e) => e.classModel.classId == classModel.classId))]
        .copyWith(
            stdTests: stdTests, listTest: listTest, testResults: testResults);
    emit(state + 1);
  }

  loadDataForGradingTab(ClassModel classModel) async {
    var lessons = await FireBaseProvider.instance
        .getLessonsByCourseId(classModel.courseId);
    var stdClasses = await FireBaseProvider.instance
        .getStudentClassInClass(classModel.classId);
    var stdLessons = await FireBaseProvider.instance
        .getAllStudentLessonsInClass(classModel.classId);
    var listTest = await FireBaseProvider.instance
        .getListTestByCourseId(classModel.courseId);
    var testResults =
        await FireBaseProvider.instance.getListTestResult(classModel.classId);
    List<int> listTestIds = [];
    for (var j in listTest) {
      listTestIds.add(j.id);
    }
    var stdTests =
        await FireBaseProvider.instance.getListStudentTestByIDs(listTestIds);
    classes![classes!.indexOf(classes!.firstWhere(
        (e) => e.classModel.classId == classModel.classId))] = classes![classes!
            .indexOf(classes!
                .firstWhere((e) => e.classModel.classId == classModel.classId))]
        .copyWith(
            stdTests: stdTests,
            listTest: listTest,
            testResults: testResults,
            listLesson: lessons,
            stdClasses: stdClasses,
            stdLessons: stdLessons);
    emit(state + 1);
  }

  filterInTeacher() {
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
    }
    var courses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].course == null) {
        var course =
            courses.firstWhere((e) => e.courseId == i.classModel.courseId);
        classes![classes!.indexOf(i)] = i.copyWith(course: course);
      }
      emit(state + 1);
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
        classes![classes!.indexOf(i)] = i.copyWith(
            listLesson: lessons,
            stdClasses: stdClasses,
            lessonResults: lessonResults,
            stdLessons: stdLessons);
      }
      emit(state + 1);
    }
    for (var i in classes!) {
      if (classes![classes!.indexOf(i)].stdTests == null) {
        var listTest = await FireBaseProvider.instance
            .getListTestByCourseId(i.classModel.courseId);
        var testResults = await FireBaseProvider.instance
            .getListTestResult(i.classModel.classId);
        List<int> listTestIds = [];
        for (var j in listTest) {
          listTestIds.add(j.id);
        }
        var stdTests = await FireBaseProvider.instance
            .getListStudentTestByIDs(listTestIds);
        classes![classes!.indexOf(i)] = i.copyWith(
            stdTests: stdTests, listTest: listTest, testResults: testResults);
      }
      emit(state + 1);
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

  updateStudentLessonAfterGrading(int classId, int lessonId, int studentId, int hw) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentLessonModel> stdLessons = classes![index].stdLessons!;

    var stdLesson = stdLessons.firstWhere((e) => e.lessonId == lessonId && e.studentId == studentId);

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
          supportNote: stdLesson.supportNote));
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
          supportNote: stdLesson.supportNote);
    }
    classes![index] = classes![index].copyWith(stdLessons: stdLessons);
  }

  updateStudentTestAfterGrading(int classId, int testId, int studentId, int score) {
    var index = classes!
        .indexOf(classes!.firstWhere((e) => e.classModel.classId == classId));
    List<StudentTestModel> stdTests = classes![index].stdTests!;

    var stdTest = stdTests.firstWhere((e) => e.testID == testId && e.studentId == studentId);

    var check = stdTests.any(
            (e) => e.testID == testId && e.studentId == stdTest.studentId);

    if (check == false) {
      stdTests.add(StudentTestModel(classId: classId, score: score, studentId: studentId, testID: testId));
    } else {
      var i = stdTests.indexOf(stdTests.firstWhere((e) =>
      e.testID == stdTest.testID &&
          e.studentId == stdTest.studentId));
      stdTests[i] = StudentTestModel(classId: classId, score: score, studentId: studentId, testID: testId);
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
}
