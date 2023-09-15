import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';

class LoadListClassCubit extends Cubit<int> {
  LoadListClassCubit() : super(0);

  List<ClassModel>? listClass;
  List<CourseModel>? courses;
  List<int>? listStatus, listStudentInClass;
  List<List<int>>? listSubmit, listAttendance;
  List<List<double>>? listPoint;
  List<double>? rateAttendance, rateSubmit;
  List<LessonResultModel> allLessonResults = [];

  init(context) async {
    await loadListClass(context);
    await loadStatisticClass(context);
  }

  loadListClass(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    List<ClassModel> listAllClass = [];
    List<CourseModel> listAllCourse = [];

    listAllClass = await adminRepository.getAllClass();
    listAllCourse = await adminRepository.getAllCourse();

    listClass = [];

      for (var i in listAllClass) {
        if (i.classStatus != "Remove") {
          listClass!.add(i);
        }
      }


    courses = [];
    listStatus = [];
    allLessonResults = await teacherRepository.getAllLessonResult();

    for (var i in listClass!) {
      var temp = allLessonResults.fold(<LessonResultModel>[],
              (pre, e) => [...pre, if (i.classId == e.classId) e]);

      listStatus!.add(temp
          .fold(<LessonResultModel>[],
              (pre, e) => [...pre, if (e.status == 'Complete') e])
          .toList()
          .length);
      for (var j in listAllCourse) {
        if (i.courseId == j.courseId && i.classStatus != "Remove") {
          courses!.add(j);
          break;
        }
      }

    }

    emit(state + 1);
  }

  loadStatisticClass(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    listSubmit = [];
    listAttendance = [];
    listStudentInClass = [];
    listPoint = [];
    rateSubmit = [];
    rateAttendance = [];

    var listAllStudentLessons = await teacherRepository.getAllStudentLessons();

    var lstLesson = await teacherRepository.getAllLesson();
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