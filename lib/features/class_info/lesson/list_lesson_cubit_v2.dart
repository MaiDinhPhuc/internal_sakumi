import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ListLessonCubitV2 extends Cubit<int>{
  ListLessonCubitV2(this.classId):super(0){
    loadData();
  }
  final int classId;
  ClassModel? classModel;
  List<TeacherModel> teachers = [];
  List<StudentModel> students = [];
  List<StudentClassModel>? listStdClass;
  List<StudentLessonModel>? stdLessons;
  List<LessonResultModel>? lessonResults;
  List<LessonModel>? lessons;

  loadData()async{
    classModel = await FireBaseProvider.instance.getClassById(classId);

    emit(state+1);

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classId, loadLessonResult);

    await DataProvider.lessonByCourseId(classModel!.courseId, loadLessonInClass);

    List<int> listTeacherId = [];
    for (var i in lessonResults!) {
      if (!listTeacherId.contains(i.teacherId)) {
        listTeacherId.add(i.teacherId);
      }
    }
    for(var i in listTeacherId){
      await DataProvider.teacherById(i, loadTeacherInfo);
    }

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    for(var i in listStdId){
      await DataProvider.studentById(i, loadStudentInfo);
    }

  }

  // loadDetail()async{
  //
  //   List<LessonModel> lessonNotBTVN =
  //   lessons!.where((element) => element.btvn == 0).toList();
  //
  //   List<int> lessonNotBTVNIds = [];
  //   for (var i in lessonNotBTVN) {
  //     lessonNotBTVNIds.add(i.lessonId);
  //   }
  //
  //   List<LessonResultModel?> listLessonResultTemp = [];
  //
  //   for (var i in lessonResults!) {
  //     listLessonResultTemp.add(i);
  //   }
  //
  //   while (listLessonResultTemp.length < lessons!.length) {
  //     listLessonResultTemp.add(null);
  //   }
  //   listSpNote = [];
  //   listSpNoteForTeacher = [];
  //   listTeachingDay = [];
  //   listTeacherNote = [];
  //   listStatus = [];
  //   listLessonInfo = [];
  //   for (int i = 0; i < listLessonResultTemp.length; i++) {
  //     if (listLessonResultTemp[i] != null) {
  //       listSpNote!.add(listLessonResultTemp[i]!.noteForSupport!);
  //       listSpNoteForTeacher!
  //           .add(listLessonResultTemp[i]!.supportNoteForTeacher!);
  //       listTeacherNote!.add(listLessonResultTemp[i]!.noteForTeacher!);
  //       listStatus!.add(listLessonResultTemp[i]!.status!);
  //       listLessonInfo!.add({
  //         'id': lessons!
  //             .firstWhere((element) =>
  //         element.lessonId == listLessonResultTemp[i]!.lessonId)
  //             .lessonId,
  //         'title': lessons!
  //             .firstWhere((element) =>
  //         element.lessonId == listLessonResultTemp[i]!.lessonId)
  //             .title
  //       });
  //       listTeachingDay!
  //           .add(listLessonResultTemp[i]!.date!.split(" ").first);
  //       LessonModel temp = lessons!.firstWhere((element) =>
  //       element.lessonId == listLessonResultTemp[i]!.lessonId);
  //       lessons!.remove(lessons!.firstWhere((element) =>
  //       element.lessonId == listLessonResultTemp[i]!.lessonId));
  //       lessons!.insert(i, temp);
  //     } else {
  //       listTeachingDay!.add("");
  //       listSpNote!.add("");
  //       listSpNoteForTeacher!.add("");
  //       listTeacherNote!.add("");
  //       listStatus!.add("Pending");
  //       listLessonInfo!
  //           .add({'id': lessons![i].lessonId, 'title': lessons![i].title});
  //     }
  //   }
  //   List<int> listTeacherId = [];
  //   for (var i in lessonResults!) {
  //     if (!listTeacherId.contains(i.teacherId)) {
  //       listTeacherId.add(i.teacherId);
  //     }
  //   }
  //
  //   teachers = [];
  //
  //   await loadListTeacherInfo(listTeacherId);
  //
  //
  //   List<TeacherModel?> listTeacher = [];
  //   for (var i in listLessonResultTemp) {
  //     if (i != null) {
  //       listTeacher.add(teachers!
  //           .firstWhere((e) => e.userId == i.teacherId));
  //     } else {
  //       listTeacher.add(null);
  //     }
  //   }
  //
  //   List<StudentClassModel> listStdClassTemp = listStdClass!
  //       .where((i) =>
  //   i.classStatus != "Remove" &&
  //       i.classStatus != "Dropped" &&
  //       i.classStatus != "Deposit" &&
  //       i.classStatus != "Retained" &&
  //       i.classStatus != "Moved" &&
  //       i.classStatus != "Viewer")
  //       .toList();
  //   List<int> sdtIdsTemp = [];
  //   for (var i in listStdClassTemp) {
  //     sdtIdsTemp.add(i.userId);
  //   }
  //   List<int> studentIds = [];
  //   for (var i in listStdClass!) {
  //     if (i.classStatus != "Remove" &&
  //         i.classStatus != "Dropped" &&
  //         i.classStatus != "Deposit" &&
  //         i.classStatus != "Retained" &&
  //         i.classStatus != "Moved") {
  //       studentIds.add(i.userId);
  //     }
  //   }
  //
  //   List<StudentModel> students = this.students!
  //       .where((e) => studentIds.contains(e.userId))
  //       .toList();
  //   students.sort((a, b) => a.userId.compareTo(b.userId));
  //   List<String> names = [];
  //   for (var i in students) {
  //     names.add(i.name);
  //   }
  //   this.students = students;
  //   List<StudentLessonModel> listStdLesson = stdLessons!;
  //   List<double?> listAttendance = [];
  //   List<double?> listHw = [];
  //   List<bool?> listHwStatus = [];
  //   List<Map<String, dynamic>?> listDetailLesson = [];
  //   for (var i in listLessonResultTemp) {
  //     if (i == null) {
  //       listAttendance.add(null);
  //       listHw.add(null);
  //       listHwStatus.add(null);
  //       listDetailLesson.add(null);
  //     } else {
  //       List<StudentLessonModel> list = listStdLesson
  //           .where((element) => element.lessonId == i.lessonId)
  //           .toList();
  //       List<StudentLessonModel> tempList = listStdLesson
  //           .where((element) =>
  //       element.lessonId == i.lessonId &&
  //           element.timekeeping != 0 &&
  //           sdtIdsTemp.contains(element.studentId))
  //           .toList();
  //       double tempAttendance = 0;
  //       double tempHw = 0;
  //       bool? status;
  //       for (var j in tempList) {
  //         if (j.timekeeping < 5 && j.timekeeping > 0) {
  //           tempAttendance++;
  //         }
  //         if (j.hw != -2) {
  //           tempHw++;
  //         }
  //       }
  //
  //       if (tempList.isEmpty) {
  //         status = null;
  //       } else {
  //         int submitCount = 0;
  //         int checkCount = 0;
  //         int notSubmitCount = 0;
  //         for (var k in tempList) {
  //           if (k.hw != -2) {
  //             submitCount++;
  //           }
  //           if (k.hw > -1) {
  //             checkCount++;
  //           }
  //           if (k.hw == -2) {
  //             notSubmitCount++;
  //           }
  //         }
  //         if (checkCount == submitCount) {
  //           status = true;
  //         } else {
  //           status = false;
  //         }
  //         if (notSubmitCount == tempList.length) {
  //           status = null;
  //         }
  //       }
  //       List<int?> attendanceDetail = [];
  //       List<double?> hwDetail = [];
  //       List<String> noteDetail = [];
  //       for (var k in students) {
  //         bool check = false;
  //         for (var j in list) {
  //           if (k.userId == j.studentId) {
  //             check = true;
  //           }
  //         }
  //         if (check) {
  //           attendanceDetail.add(list
  //               .firstWhere((element) => element.studentId == k.userId)
  //               .timekeeping);
  //           hwDetail.add(lessonNotBTVNIds.contains(i.lessonId)
  //               ? null
  //               : list
  //               .firstWhere((element) => element.studentId == k.userId)
  //               .hw);
  //           noteDetail.add(list
  //               .firstWhere((element) => element.studentId == k.userId)
  //               .teacherNote);
  //         } else {
  //           attendanceDetail.add(null);
  //           hwDetail.add(lessonNotBTVNIds.contains(i.lessonId) ? null : -2);
  //           noteDetail.add("");
  //         }
  //       }
  //
  //       listAttendance
  //           .add(tempAttendance / (tempList.isEmpty ? 1 : tempList.length));
  //       if (lessonNotBTVNIds.contains(i.lessonId)) {
  //         listHw.add(null);
  //       } else {
  //         listHw.add(tempHw / (tempList.isEmpty ? 1 : tempList.length));
  //       }
  //
  //       listHwStatus.add(status);
  //       listDetailLesson.add({
  //         'names': names,
  //         'attendance': attendanceDetail,
  //         'hw': hwDetail,
  //         'note': noteDetail
  //       });
  //     }
  //   }
  //   this.listDetailLesson = listDetailLesson;
  //   this.listAttendance = listAttendance;
  //   this.listHw = listHw;
  //   this.listHwStatus = listHwStatus;
  //   this.listTeacher = listTeacher;
  //   emit(state + 1);
  // }


  loadTeacherInfo(Object student) {
    teachers.add(student as TeacherModel);
  }


  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    emit(state+1);
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }


  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
    emit(state+1);
  }

}