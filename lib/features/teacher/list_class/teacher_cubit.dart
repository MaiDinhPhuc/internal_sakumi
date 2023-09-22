import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class TeacherCubit extends Cubit<int> {
  TeacherCubit() : super(0);

  TeacherModel? teacherProfile;
  List<ClassModel>? listClass;
  List<CourseModel>? courses;
  List<int>? listStatus, listStudentInClass;
  List<List<int>>? listSubmit, listAttendance;
  List<List<double>>? listPoint;
  List<double>? rateAttendance, rateSubmit;
  List<LessonResultModel> allLessonResults = [];
  bool isListDone = true;
  bool isListInProgress = true;
  bool isListDoneOld = true;
  bool isListInProgressOld = true;
  bool isChange = false;

  init(context) async {
    debugPrint('============> init 1');
    await loadProfileTeacher(context);
    debugPrint('============> init 2');
    await loadListClassOfTeacher(context);
    debugPrint('============> init 3');
    await loadStatisticClass(context);
    debugPrint('============> init 4');
  }

  loadProfileTeacher(context) async {
    teacherProfile = await FireBaseProvider.instance.getTeacherByTeacherCode(TextUtils.getName());
    emit(state + 1);
  }

  loadListClassOfTeacher(context) async {
    List<TeacherClassModel> listTeacherClass = [];
    List<ClassModel> listAllClass = [];
    List<CourseModel> listAllCourse = [];


    if(isListInProgress && isListDone){
      listTeacherClass = await  FireBaseProvider.instance.getTeacherClassById(
          'user_id', teacherProfile!.userId);
    }else if(isListInProgress && !isListDone){
      listTeacherClass = await  FireBaseProvider.instance.getTeacherClassByStatus(
          teacherProfile!.userId, TeacherClassModel.fromString(AppText.optInProgress.text));
    }else if(!isListInProgress && isListDone){
      listTeacherClass = await  FireBaseProvider.instance.getTeacherClassByStatus(
          teacherProfile!.userId, TeacherClassModel.fromString(AppText.optComplete.text));
    }

    // listTeacherClass = await (option == AppText.optBoth.text
    //     ? teacherRepository.getTeacherClassById(
    //         'user_id', teacherProfile!.userId)
    //     : teacherRepository.getTeacherClassByStatus(
    //         teacherProfile!.userId, TeacherClassModel.fromString(option)));

    listAllClass = await FireBaseProvider.instance.getAllClass();
    listAllCourse = await FireBaseProvider.instance.getAllCourse();

    listClass = [];
    for (var i in listTeacherClass) {
      for (var j in listAllClass) {
        if (i.classId == j.classId) {
          listClass!.add(j);
          break;
        }
      }
    }

    courses = [];
    listStatus = [];
    allLessonResults = await FireBaseProvider.instance.getAllLessonResult();

    for (var i in listClass!) {
      var temp = allLessonResults.fold(<LessonResultModel>[],
          (pre, e) => [...pre, if (i.classId == e.classId) e]);

      listStatus!.add(temp
          .fold(<LessonResultModel>[],
              (pre, e) => [...pre, if (e.status == 'Complete') e])
          .toList()
          .length);

      for (var j in listAllCourse) {
        if (i.courseId == j.courseId) {
          courses!.add(j);
          break;
        }
      }
    }

    emit(state + 1);
  }

  loadStatisticClass(context) async {

    listSubmit = [];
    listAttendance = [];
    listStudentInClass = [];
    listPoint = [];
    rateSubmit = [];
    rateAttendance = [];

    var listAllStudentLessons = await FireBaseProvider.instance.getAllStudentLessons();

    var lstLesson = await FireBaseProvider.instance.getAllLesson();
    for (var item in listClass!) {
      var activeLessonResults = allLessonResults.fold(<LessonResultModel>[],
          (pre, e) => [...pre, if (item.classId == e.classId) e]);

      List<LessonModel> lessons = lstLesson.fold(<LessonModel>[],
          (pre, e) => [...pre, if (item.courseId == e.courseId) e]);

      List<int> attendances = [], submits = [];
      List<double> points = [];
      double rateAttend = 0.0, rateSub = 0.0;
      for (var lesson in lessons) {
        int att = listAllStudentLessons.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == item.classId &&
                        e.lessonId == lesson.lessonId &&
                        e.timekeeping > 0 &&
                        e.timekeeping < 5)
                    ? 1
                    : 0));
        int sub = listAllStudentLessons.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == item.classId &&
                        e.lessonId == lesson.lessonId &&
                        e.hw > -2)
                    ? 1
                    : 0));
        double pts = listAllStudentLessons.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == item.classId &&
                        e.lessonId == lesson.lessonId &&
                        e.hw > -1)
                    ? e.hw
                    : 0));
        int sumItem = listAllStudentLessons.fold(
            0,
            (pre, e) =>
                pre +
                ((e.classId == item.classId && e.lessonId == lesson.lessonId)
                    ? 1
                    : 0));

        rateAttend = rateAttend + (sumItem == 0 ? 0 : (att / sumItem));
        rateSub = rateSub + (sumItem == 0 ? 0 : (sub / sumItem));

        attendances.add(att);
        submits.add(sub);
        points.add(pts);
      }

      listAttendance!.add(attendances);
      listSubmit!.add(submits);
      listPoint!.add(points);
      rateAttendance!.add(activeLessonResults.isEmpty ? 0 : rateAttend / activeLessonResults.length);
      rateSubmit!.add(activeLessonResults.isEmpty ? 0 : rateSub / activeLessonResults.length);
    }
    emit(state + 1);
  }
}
