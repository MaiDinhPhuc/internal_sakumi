import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
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

  init(context, String option) async {
    debugPrint('============> init 1');
    await loadProfileTeacher(context);
    debugPrint('============> init 2');
    await loadListClassOfTeacher(context, option);
    debugPrint('============> init 3');
    await loadStatisticClass(context);
    debugPrint('============> init 4');
  }

  loadProfileTeacher(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    teacherProfile = await teacherRepository.getTeacher(TextUtils.getName());
    emit(state + 1);
  }

  loadListClassOfTeacher(context, String option) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    List<TeacherClassModel> listTeacherClass = [];
    List<ClassModel> listAllClass = [];
    List<CourseModel> listAllCourse = [];

    listTeacherClass = await (option == AppText.optBoth.text
        ? teacherRepository.getTeacherClassById(
            'user_id', teacherProfile!.userId)
        : teacherRepository.getTeacherClassByStatus(
            teacherProfile!.userId, TeacherClassModel.fromString(option)));

    debugPrint(
        '=============>loadListClassOfTeacher ${listTeacherClass.length} == $option == ${TeacherClassModel.fromString(option)}');

    listAllClass = await adminRepository.getListClass();
    listAllCourse = await adminRepository.getAllCourse();

    listClass = [];
    for (var i in listTeacherClass) {
      for (var j in listAllClass) {
        if (i.classId == j.classId) {
          listClass!.add(j);
          break;
        }
      }
    }
    debugPrint('================> listClass ${listClass!.length}');
    courses = [];
    listStatus = [];
    var allLessonResults = await teacherRepository.getAllLessonResult();
    for (var i in listClass!) {
      var temp = allLessonResults.fold(<LessonResultModel>[], (pre, e) => [...pre, if(i.classId == e.classId) e]);
      debugPrint('================> temp 0000');
      listStatus!.add(temp
          .fold(<LessonResultModel>[],
              (pre, e) => [...pre, if (e.status == 'Complete') e])
          .toList()
          .length);
      debugPrint('================> temp 1111');
      for (var j in listAllCourse) {
        if (i.courseId == j.courseId) {
          courses!.add(j);
          break;
        }
      }
      debugPrint('================> temp 2222');
    }

    emit(state + 1);
  }

  // loadStatisticClass(context) async {
  //   TeacherRepository teacherRepository =
  //       TeacherRepository.fromContext(context);
  //   AdminRepository adminRepository = AdminRepository.fromContext(context);
  //
  //   listSubmit = [];
  //   listAttendance = [];
  //   listStudentInClass = [];
  //   listPoint = [];
  //   rateSubmit = [];
  //   rateAttendance = [];
  //   debugPrint('===============> loadStatisticClass 1');
  //   var listAllStudent = await adminRepository.getAllStudentInClass();
  //   debugPrint('===============> loadStatisticClass 2 ${listAllStudent.length}');
  //   var listAllStudentLessons = await teacherRepository.getAllStudentLessons();
  //   debugPrint('===============> loadStatisticClass 3');
  //   for (var i in listClass!) {
  //     int studentsInClass = listAllStudent.fold(
  //         0, (pre, e) => pre + ((i.classId == e.classId) ? 1 : 0));
  //     debugPrint('===============> loadStatisticClass 5 ${studentsInClass}');
  //     List<StudentLessonModel> lessonsInClass = listAllStudentLessons
  //         .fold([], (pre, e) => [...pre, if (e.classId == i.classId) e]);
  //     listStudentInClass!.add(studentsInClass);
  //
  //     var lessons = await teacherRepository.getLessonsByCourseId(i.courseId);
  //
  //     debugPrint(
  //         '============> student in class ${listStudentInClass![listClass!.indexOf(i)]}');
  //     List<int> attends = [];
  //     List<int> homeworks = [];
  //     List<double> points = [];
  //     double pts = 0.0, rateAtt = 0.0, rateSub = 0.0;
  //     int att = 0, sub = 0;
  //     //for (var j = 1; j <= courses![listClass!.indexOf(i)].lessonCount; j++) {
  //     for (var j in lessons) {
  //       debugPrint('============> lesson ${j.lessonId}');
  //       var attendance = lessonsInClass.fold(
  //           0,
  //           (pre, e) =>
  //               pre +
  //               ((e.timekeeping > 0 &&
  //                       e.timekeeping < 5 &&
  //                       e.lessonId == j.lessonId)
  //                   ? 1
  //                   : 0));
  //       debugPrint('============> lesson attendance $attendance');
  //       var hw = lessonsInClass.fold(
  //           0,
  //           (pre, e) =>
  //               pre + ((e.hw > -2 && e.lessonId == j.lessonId) ? 1 : 0));
  //
  //       var point = lessonsInClass.fold(
  //           0,
  //           (pre, e) =>
  //               pre + ((e.hw > -1 && e.lessonId == j.lessonId) ? e.hw : 0));
  //
  //       att = att + attendance;
  //       sub = sub + hw;
  //       pts = pts + point;
  //       attends.add(attendance);
  //       homeworks.add(hw);
  //       points.add(point / listStudentInClass![listClass!.indexOf(i)]);
  //       //pts.add(point / ((listStudentInClass!.length * ) / 10));
  //     }
  //     rateAtt = att/(lessons.length)/(listStudentInClass!.length);
  //     rateSub = sub/(lessons.length)/(listStudentInClass!.length);
  //     debugPrint('=----= $attends ==== $homeworks == $att == $sub ');
  //     debugPrint('==============> rate temp $rateAtt === $rateSub');
  //     // rateAttendance!.add(att /
  //     //     (listStudentInClass![0] *
  //     //         courses![0].lessonCount));
  //     // rateSubmit!.add(
  //     //     sub /listStudentInClass![0] *
  //     //         courses![0].lessonCount);
  //     rateAttendance!.add(rateAtt);
  //     rateSubmit!.add(rateSub);
  //
  //     debugPrint('==============> rate ${rateAttendance} ===== ${rateSubmit}');
  //     listAttendance!.add(attends);
  //     listSubmit!.add(homeworks);
  //     listPoint!.add(points);
  //     debugPrint('===============> total $listAttendance === $listSubmit === $listPoint');
  //   }
  //   emit(state + 1);
  // }

  loadStatisticClass(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);
    AdminRepository adminRepository = AdminRepository.fromContext(context);

    listSubmit = [];
    listAttendance = [];
    listStudentInClass = [];
    listPoint = [];
    rateSubmit = [];
    rateAttendance = [];
    debugPrint('===============> loadStatisticClass 1');
    var listAllStudent = await adminRepository.getAllStudentInClass();
    debugPrint(
        '===============> loadStatisticClass 2 ${listAllStudent.length}');
    var listAllStudentLessons = await teacherRepository.getAllStudentLessons();
    debugPrint('===============> loadStatisticClass 3');

    var lstLesson = await teacherRepository.getAllLesson();
    for (var item in listClass!) {
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
                        e.timekeeping < 6)
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
      rateAttendance!.add(rateAttend / lessons.length);
      rateSubmit!.add(rateSub / lessons.length);

      debugPrint(
          '===============> listAttendance $attendances == $submits == $points');
    }
    emit(state + 1);
  }
}
