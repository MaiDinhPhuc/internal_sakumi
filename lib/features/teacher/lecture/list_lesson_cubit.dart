import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

// class ListLessonCubit extends Cubit<int> {
//   ListLessonCubit() : super(0);
//
//   List<LessonResultModel>? listLessonResult;
//
//   ClassModel? classModel;
//
//   List<LessonModel>? lessons;
//
//   List<List<StudentLessonModel>>? listStudentLessons;
//
//   List<StudentClassModel>? listStudentClass;
//
//   List<int>? listAttendance, listSubmitHomework, listMarked;
//
//   List<StudentModel>? listStudent;
//
//   init(context) async {
//     await loadClass(context);
//     await loadLessonResult(context);
//     await loadStudentLesson(context);
//   }
//
//   loadClass(context) async {
//     TeacherRepository teacherRepository =
//         TeacherRepository.fromContext(context);
//     var temp = Uri.dataFromString(window.location.href).toString();
//     classModel =
//         await teacherRepository.getClassById(int.parse(TextUtils.getClassId()));
//     emit(state + 1);
//   }
//
//   loadLessonResult(context) async {
//     TeacherRepository teacherRepository =
//         TeacherRepository.fromContext(context);
//     listLessonResult = await teacherRepository
//         .getLessonResultByClassId(classModel!.classId);
//     lessons =
//         await teacherRepository.getLessonsByCourseId(classModel!.courseId);
//     emit(state + 1);
//   }
//
//   loadStudentLesson(context) async {
//     listAttendance = [];
//     listSubmitHomework = [];
//     listMarked = [];
//     listStudentClass = [];
//     TeacherRepository teacherRepository =
//         TeacherRepository.fromContext(context);
//
//     List<StudentLessonModel>? listAllStudentLesson = await teacherRepository
//         .getAllStudentLessonsInClass(int.parse(TextUtils.getName()));
//
//     AdminRepository adminRepository = AdminRepository.fromContext(context);
//
//     listStudentClass = await adminRepository
//         .getStudentClassByClassId(int.parse(TextUtils.getName()));
//
//     listStudentLessons = [];
//     for (var i in listLessonResult!) {
//       List<StudentLessonModel> list = listAllStudentLesson!.fold(
//           <StudentLessonModel>[],
//           (pre, e) => [...pre, if (i.lessonId == e.lessonId) e]).toList();
//
//       listStudentLessons!.add(list);
//
//       var attendance = listStudentLessons![listLessonResult!.indexOf(i)].fold(
//           <int>[],
//           (pre, e) => [
//                 ...pre,
//                 if (e.timekeeping > 0 &&
//                     e.timekeeping < 5 &&
//                     i.lessonId == e.lessonId)
//                   e.timekeeping
//               ]).toList();
//
//       var submit = listStudentLessons![listLessonResult!.indexOf(i)].fold(
//           <int>[],
//           (pre, e) => [
//                 ...pre,
//                 if (e.hw > -2 && e.lessonId == i.lessonId) e.hw
//               ]).toList();
//
//       var marked = listStudentLessons![listLessonResult!.indexOf(i)].fold(
//           <int>[],
//           (pre, e) => [
//                 ...pre,
//                 if (e.hw > -1 && e.lessonId == i.lessonId) e.hw
//               ]).toList();
//
//       listSubmitHomework!.add(submit.length);
//       listMarked!.add(marked.length);
//       listAttendance!.add(attendance.length);
//     }
//
//     emit(state + 1);
//   }
//
//   loadStudent(context) async {
//     AdminRepository adminRepository = AdminRepository.fromContext(context);
//
//     var list = await adminRepository.getAllStudent();
//
//     listStudent = [];
//     for (var i in list) {
//       for (var j in listStudentClass!) {
//         if (i.userId == j.userId) {
//           listStudent!.add(i);
//           break;
//         }
//       }
//     }
//     print("==============> test test ${listStudent!.first.userId}");
//     emit(state + 1);
//   }
// }

// class ListLessonCubit extends Cubit<int> {
//   ListLessonCubit() : super(0);
//
//   List<LessonResultModel>? listLessonResult;
//
//   ClassModel? classModel;
//
//   List<LessonModel>? lessons;
//
//   List<List<StudentLessonModel?>>? listStudentLessons, listSL;
//
//   List<StudentClassModel>? listStudentClass;
//
//   List<int>? listAttendance, listSubmitHomework, listMarked;
//
//   List<List<int>>? listTest;
//
//   List<StudentModel>? listStudent;
//
//   init(context) async {
//     debugPrint('==============> init 1');
//     await loadClass(context);
//     debugPrint('==============> init 2');
//     await loadLessonResult(context);
//     debugPrint('==============> init 3');
//     //await loadStudent(context);
//     await loadStudentLesson(context);
//     debugPrint('==============> init 4');
//   }
//
//   loadClass(context) async {
//     debugPrint('==============> loadClass 1');
//     TeacherRepository teacherRepository =
//     TeacherRepository.fromContext(context);
//     debugPrint('==============> loadClass 2');
//     var temp = Uri.dataFromString(window.location.href).toString();
//     debugPrint('==============> loadClass 3');
//     classModel =
//     await teacherRepository.getClassById(int.parse(TextUtils.getClassId()));
//     debugPrint('==============> loadClass 4 ${classModel!.classId} ${classModel!.courseId}  ${int.parse(TextUtils.getClassId())}');
//     emit(state + 1);
//     debugPrint('==============> loadClass 5');
//   }
//
//   loadLessonResult(context) async {
//     debugPrint('==============> loadLessonResult 1');
//     TeacherRepository teacherRepository =
//     TeacherRepository.fromContext(context);
//     debugPrint('==============> loadLessonResult 2 ${classModel!.classId}');
//     listLessonResult = await teacherRepository
//         .getLessonResultByClassId(classModel!.classId);
//     debugPrint('==============> loadLessonResult 3 ${classModel!.courseId}');
//     lessons =
//     await teacherRepository.getLessonsByCourseId(classModel!.courseId);
//     debugPrint('==============> loadLessonResult 4 ${lessons!.length}');
//     emit(state + 1);
//     debugPrint('==============> loadLessonResult 5');
//   }
//
//   // loadStudentLesson(context) async {
//   //   listAttendance = [];
//   //   listSubmitHomework = [];
//   //   listMarked = [];
//   //   listStudentClass = [];
//   //   TeacherRepository teacherRepository =
//   //   TeacherRepository.fromContext(context);
//   //
//   //   List<StudentLessonModel>? listAllStudentLesson = await teacherRepository
//   //       .getAllStudentLessonsInClass(classModel!.classId);
//   //
//   //   AdminRepository adminRepository = AdminRepository.fromContext(context);
//   //
//   //   listStudentClass = await adminRepository
//   //       .getStudentClassByClassId(classModel!.classId);
//   //
//   //   listStudentLessons = [];
//   //   for (var i in listLessonResult!) {
//   //     List<StudentLessonModel> list = listAllStudentLesson!.fold(
//   //         <StudentLessonModel>[],
//   //             (pre, e) => [...pre, if (i.lessonId == e.lessonId) e]).toList();
//   //
//   //     listStudentLessons!.add(list);
//   //
//   //     var attendance = list.fold(
//   //         <int>[],
//   //             (pre, e) => [
//   //           ...pre,
//   //           if (e.timekeeping > 0 &&
//   //               e.timekeeping < 5 &&
//   //               i.lessonId == e.lessonId)
//   //             e.timekeeping
//   //         ]).toList();
//   //
//   //     var submit = list.fold(
//   //         <int>[],
//   //             (pre, e) => [
//   //           ...pre,
//   //           if (e.hw > -2 && e.lessonId == i.lessonId) e.hw
//   //         ]).toList();
//   //
//   //     var marked = list.fold(
//   //         <int>[],
//   //             (pre, e) => [
//   //           ...pre,
//   //           if (e.hw > -1 && e.lessonId == i.lessonId) e.hw
//   //         ]).toList();
//   //
//   //     listSubmitHomework!.add(submit.length);
//   //     listMarked!.add(marked.length);
//   //     listAttendance!.add(attendance.length);
//   //   }
//   //
//   //   emit(state + 1);
//   // }
//   loadStudentLesson(context) async {
//     debugPrint('==============> loadStudentLesson 1');
//     listAttendance = [];
//     listSubmitHomework = [];
//     listMarked = [];
//     listSL = []; listTest = [];
//     listStudentClass = [];
//     TeacherRepository teacherRepository =
//     TeacherRepository.fromContext(context);
//     debugPrint('==============> loadStudentLesson 2');
//     List<StudentLessonModel>? listAllStudentLesson = await teacherRepository
//         .getAllStudentLessonsInClass(classModel!.classId);
//
//     AdminRepository adminRepository = AdminRepository.fromContext(context);
//     debugPrint('==============> loadStudentLesson 3');
//     listStudentClass = await adminRepository
//         .getStudentClassByClassId(classModel!.classId);
//     debugPrint('==============> loadStudentLesson 4');
//     var lstAll = await adminRepository.getAllStudent();
//     listStudent = [];
//     debugPrint('==============> loadStudentLesson 444444');
//     for (var i in lstAll) {
//       debugPrint('==============> loadStudentLesson 444444ppppp');
//       for (var j in listStudentClass!) {
//         debugPrint('==============> loadStudentLesson 444444mmmm');
//         if (i.userId == j.userId) {
//           debugPrint('==============> loadStudentLesson 444444ccccc');
//           listStudent!.add(i);
//           break;
//         }
//         debugPrint('==============> loadStudentLesson 444444sssss');
//       }
//     }
//     debugPrint('==============> loadStudentLesson 5');
//
//     listStudentLessons = [];
//     for (var i in lessons!) {
//       debugPrint('==============> loadStudentLesson 555555 ${listAllStudentLesson!.length} == ${listAllStudentLesson!.first.lessonId} == ${lessons!.first.lessonId}');
//       List<StudentLessonModel> list = listAllStudentLesson!.fold(
//           <StudentLessonModel>[],
//               (pre, e) => [...pre, if (i.lessonId == e.lessonId) e]).toList();
//       debugPrint('==============> loadStudentLesson 6 ${list.length} == ${listStudent!.length} == ${listStudent!.length}');
//       List<StudentLessonModel?> lst = [];
//       for(var j in listStudent!){
//         debugPrint('==============> loadStudentLesson 666666 ooooo ${listStudent!.length}');
//         // for(var k in list){
//         //   if(i.lessonId == k.lessonId && j.userId == k.studentId) {
//         //     lst.add(k); break;
//         //   }
//         // }
//          List<StudentLessonModel?> llll = listAllStudentLesson!.fold(
//             <StudentLessonModel?>[],
//                 (pre, e) => [...pre, (i.lessonId == e.lessonId && j.userId == e.studentId)? e: null]).toList();
//
//         debugPrint('==============> loadStudentLesson 66666 iiiiiiii ${llll.first?.lessonId}');
//         lst.add(llll.first);
//         debugPrint('==============> loadStudentLesson 66666 nnnnnnn ${lst.length}');
//       }
//
//       debugPrint('==============> loadStudentLesson 7');
//       //listSL!.add(list.length);
//       listStudentLessons!.add(lst);
//       debugPrint('==============> loadStudentLesson 8 ${listStudentLessons!.length}');
//       var attendance = list.fold(
//           <int>[],
//               (pre, e) => [
//             ...pre,
//             if (e.timekeeping > 0 &&
//                 e.timekeeping < 5 &&
//                 i.lessonId == e.lessonId)
//               e.timekeeping
//           ]).toList();
//       debugPrint('==============> loadStudentLesson 9');
//       var submit = list.fold(
//           <int>[],
//               (pre, e) => [
//             ...pre,
//             if (e.hw > -2 && e.lessonId == i.lessonId) e.hw
//           ]).toList();
//       debugPrint('==============> loadStudentLesson 10');
//       var marked = list.fold(
//           <int>[],
//               (pre, e) => [
//             ...pre,
//             if (e.hw > -1 && e.lessonId == i.lessonId) e.hw
//           ]).toList();
//       debugPrint('==============> loadStudentLesson 11');
//       listSubmitHomework!.add(submit.length);
//       debugPrint('==============> loadStudentLesson 12');
//       listMarked!.add(marked.length);
//       debugPrint('==============> loadStudentLesson 13');
//       listAttendance!.add(attendance.length);
//       debugPrint('==============> loadStudentLesson 14');
//     }
//     debugPrint('==============> loadStudentLesson 5');
//     emit(state + 1);
//     debugPrint('==============> loadStudentLesson 6');
//   }
//
//   loadStudent(context) async {
//     AdminRepository adminRepository = AdminRepository.fromContext(context);
//     debugPrint('==============> loadStudent 1');
//     var list = await adminRepository.getAllStudent();
//     listStudentClass = [];
//     listStudentClass = await adminRepository.getStudentClassByClassId(classModel!.classId);
//     debugPrint('==============> loadStudent 2');
//     listStudent = [];
//     debugPrint('==============> loadStudent 3');
//     for (var i in list) {
//       for (var j in listStudentClass!) {
//         if (i.userId == j.userId) {
//           listStudent!.add(i);
//           break;
//         }
//       }
//     }
//     debugPrint('==============> loadStudent 4');
//
//     // for(var i in listStudent!){
//     //   if(listStudent!.indexOf(i) > listSL!.length - 1){
//     //     listSL!.add(0);
//     //   }
//     // }
//
//     //print("==============> test test ${listStudent!.first.userId} === $listSL === ${listTest}");
//     emit(state + 1);
//   }
// }

class LessonTabCubit extends Cubit<int> {
  LessonTabCubit() : super(0);

  ClassModel? classModel;
  List<LessonModel>? lessons;
  List<LessonResultModel?>? listLessonResult;
  List<StudentClassModel> listStdClass = [];
  List<StudentModel>? students;
  List<List<StudentLessonModel?>> listStdLesson = [];
  List<List<int>>? listSubmit, listAttendance;
  List<double>? listRateAttend, listRateSubmit;
  List<bool?>? listMarked;

  init(context) async {
    debugPrint('==============> init 1');
    await loadClass(context);
    debugPrint('==============> init 2');
    await loadLesson(context);
    debugPrint('==============> init 3');
    await loadStudentInClass(context);
    debugPrint('==============> init 4');
    await loadStatistic(context);
    debugPrint('==============> init 5 ${listRateAttend}');
  }

  loadLesson(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    lessons = await teacherRepo.getLessonsByCourseId(classModel!.courseId);

    emit(state + 1);
  }

  loadClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    classModel =
        await teacherRepo.getClassById(int.parse(TextUtils.getClassId()));
    debugPrint(
        '==============> loadClass 4 ${classModel!.classId} ${classModel!.courseId} ${int.parse(TextUtils.getClassId())}');
    emit(state + 1);
  }

  loadStudentInClass(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    AdminRepository adminRepo = AdminRepository.fromContext(context);
    listStdClass =
        await teacherRepo.getStudentClassInClass(classModel!.classId);
    var list = await adminRepo.getAllStudent();
    students = [];
    for (var i in list) {
      for (var j in listStdClass!) {
        if (i.userId == j.userId) {
          students!.add(i);
        }
      }
    }
    emit(state + 1);
  }

  loadLessonResult(context) async {
    debugPrint('==============> loadLessonResult 1');
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    debugPrint('==============> loadLessonResult 2 ${classModel!.classId}');
    listLessonResult = [];
    listLessonResult = await teacherRepository
        .getLessonResultByClassId(classModel!.classId);
    debugPrint('==============> loadLessonResult 3 ${classModel!.courseId}');
    lessons =
    await teacherRepository.getLessonsByCourseId(classModel!.courseId);
    debugPrint('==============> loadLessonResult 4 ${lessons!.length}');
    emit(state + 1);
    debugPrint('==============> loadLessonResult 5');
  }

  loadStatistic(context) async {
    TeacherRepository teacherRepo = TeacherRepository.fromContext(context);
    var list =
        await teacherRepo.getAllStudentLessonsInClass(classModel!.classId);
    listSubmit = [];
    listAttendance = [];
    listRateAttend = [];
    listRateSubmit = [];
    listMarked = [];
    for (var lesson in lessons!) {
      List<int> attends = [];
      List<int> submits = [];
      debugPrint('============> lesson ${lesson.lessonId}');
      List<StudentLessonModel> listStdLessonInLesson = list.fold(
          <StudentLessonModel>[],
          (pre, e) => [...pre, if (e.lessonId == lesson.lessonId) e]).toList();
      debugPrint('============> lesson0000 ${listStdLessonInLesson.length}');
      if(listStdLessonInLesson.isNotEmpty){
        for (var std in listStdClass!) {
          if ((std.userId ==
              listStdLessonInLesson[listStdClass!.indexOf(std)].studentId) &&
              (listStdClass!.indexOf(std) < listStdLessonInLesson.length)) {
            attends.add(
                listStdLessonInLesson[listStdClass!.indexOf(std)].timekeeping);
            submits.add(listStdLessonInLesson[listStdClass!.indexOf(std)].hw);
          } else {
            attends.add(-1);
            submits.add(-3);
          }
        }
        debugPrint('============> attends $attends');
        int tempAtt =
        attends.fold(0, (pre, e) => pre + ((e > 0 && e < 5) ? 1 : 0));
        int tempSbm = submits.fold(0, (pre, e) => pre + (e > -2 ? 1 : 0));
        int tempMark = submits.fold(0, (pre, e) => pre + (e > -1 ? 1 : 0));
        listAttendance!.add(attends);
        listMarked!.add(listStdClass.isEmpty ? null : tempSbm == tempMark ? true : false);
        listSubmit!.add(submits);
        listRateAttend!.add((listStdClass.isEmpty) ? 0 : tempAtt / (listStdClass!.length));
        listRateSubmit!.add((listStdClass.isEmpty) ? 0 : tempSbm / (listStdClass!.length));
      }
      else{
        for (var std in listStdClass!) {
          attends.add(-1);
          submits.add(-3);
        }
        listAttendance!.add(attends);
        listMarked!.add(null);
        listSubmit!.add(submits);
        listRateAttend!.add(0);
        listRateSubmit!.add(0);
      }
    }
    emit(state + 1);
  }
}
