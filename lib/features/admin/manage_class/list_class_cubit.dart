import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/teacher_home_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class LoadListClassCubit extends Cubit<int> {
  LoadListClassCubit() : super(0);

  TeacherHomeClass? data;
  List<int>? listClassIds,
      listClassType,
      listLessonCount,
      listLessonAvailable;
  List<String>? listClassCodes, listClassStatus, listBigTitle;
  List<double>? rateAttendance, rateSubmit;
  List<List<int>>? rateAttendanceChart, rateSubmitChart;
  List<bool> listFilter = [true, true, false, false];
  List<String> listClassStatusMenu = ["Preparing","InProgress", "Completed", "Cancel"];

  init() async {
    data = await FireBaseProvider.instance.getDataForManageClassTab();
    filter();
    emit(state + 1);
  }

  filter() {
    if(listFilter.every((element) => element == true)){
      listClassIds = data!.listClassIds;
      listClassType = data!.listClassType;
      listLessonCount = data!.listLessonCount;
      listClassCodes = data!.listClassCodes;
      listClassStatus = data!.listClassStatus;
      listBigTitle = data!.listBigTitle;
      rateAttendance = data!.rateAttendance;
      rateSubmit = data!.rateSubmit;
      rateAttendanceChart = data!.rateAttendanceChart;
      rateSubmitChart = data!.rateSubmitChart;
      listLessonAvailable = data!.listLessonAvailable;
    }else{
      listClassIds = [];
      listClassType = [];
      listLessonCount = [];
      listClassCodes = [];
      listClassStatus = [];
      listBigTitle = [];
      rateAttendance = [];
      rateSubmit = [];
      rateAttendanceChart = [];
      rateSubmitChart = [];
      listLessonAvailable = [];
      List<int> listIndex = [];
      if(listFilter[0]){
        for(int i = 0; i<data!.listClassStatus.length; i++){
          if(data!.listClassStatus[i] == listClassStatusMenu[0]){
            listIndex.add(i);
          }
        }
      }
      if(listFilter[1]){
        for(int i = 0; i<data!.listClassStatus.length; i++){
          if(data!.listClassStatus[i] == listClassStatusMenu[1]){
            listIndex.add(i);
          }
        }
      }
      if(listFilter[2]){
        for(int i = 0; i<data!.listClassStatus.length; i++){
          if(data!.listClassStatus[i] == listClassStatusMenu[2]){
            listIndex.add(i);
          }
        }
      }
      if(listFilter[3]){
        for(int i = 0; i<data!.listClassStatus.length; i++){
          if(data!.listClassStatus[i] == listClassStatusMenu[3]){
            listIndex.add(i);
          }
        }
      }
      for(var i in listIndex){
        listClassIds!.add(data!.listClassIds[i]);
        listClassType!.add(data!.listClassType[i]);
        listLessonCount!.add(data!.listLessonCount[i]);
        listClassCodes!.add(data!.listClassCodes[i]);
        listClassStatus!.add(data!.listClassStatus[i]);
        listBigTitle!.add(data!.listBigTitle[i]);
        rateAttendance!.add(data!.rateAttendance[i]);
        rateSubmit!.add(data!.rateSubmit[i]);
        rateAttendanceChart!.add(data!.rateAttendanceChart[i]);
        rateSubmitChart!.add(data!.rateSubmitChart[i]);
        listLessonAvailable!.add(data!.listLessonAvailable[i]);
      }
    }
    emit(state + 1);
  }
  // loadListClass() async {
  //   List<ClassModel> listAllClass = [];
  //   List<CourseModel> listAllCourse = [];
  //
  //   listAllClass = await FireBaseProvider.instance.getAllClass();
  //   listAllCourse = await FireBaseProvider.instance.getAllCourse();
  //
  //   listClass = [];
  //
  //     for (var i in listAllClass) {
  //       if (i.classStatus != "Remove") {
  //         listClass!.add(i);
  //       }
  //     }
  //
  //
  //   courses = [];
  //   listStatus = [];
  //   allLessonResults = await FireBaseProvider.instance.getAllLessonResult();
  //
  //   for (var i in listClass!) {
  //     var temp = allLessonResults.fold(<LessonResultModel>[],
  //             (pre, e) => [...pre, if (i.classId == e.classId) e]);
  //
  //     listStatus!.add(temp
  //         .fold(<LessonResultModel>[],
  //             (pre, e) => [...pre, if (e.status == 'Complete') e])
  //         .toList()
  //         .length);
  //     for (var j in listAllCourse) {
  //       if (i.courseId == j.courseId && i.classStatus != "Remove") {
  //         courses!.add(j);
  //         break;
  //       }
  //     }
  //
  //   }
  //
  //   emit(state + 1);
  // }
  //
  // loadStatisticClass() async {
  //
  //   listSubmit = [];
  //   listAttendance = [];
  //   listStudentInClass = [];
  //   listPoint = [];
  //   rateSubmit = [];
  //   rateAttendance = [];
  //
  //   var listAllStudentLessons = await FireBaseProvider.instance.getAllStudentLessons();
  //
  //   var lstLesson = await FireBaseProvider.instance.getAllLesson();
  //   for (var item in listClass!) {
  //     var activeLessonResults = allLessonResults.fold(<LessonResultModel>[],
  //             (pre, e) => [...pre, if (item.classId == e.classId) e]);
  //
  //     List<LessonModel> lessons = lstLesson.fold(<LessonModel>[],
  //             (pre, e) => [...pre, if (item.courseId == e.courseId) e]);
  //
  //     List<int> attendances = [], submits = [];
  //     List<double> points = [];
  //     double rateAttend = 0.0, rateSub = 0.0;
  //     for (var lesson in lessons) {
  //       int att = listAllStudentLessons.fold(
  //           0,
  //               (pre, e) =>
  //           pre +
  //               ((e.classId == item.classId &&
  //                   e.lessonId == lesson.lessonId &&
  //                   e.timekeeping > 0 &&
  //                   e.timekeeping < 5)
  //                   ? 1
  //                   : 0));
  //       int sub = listAllStudentLessons.fold(
  //           0,
  //               (pre, e) =>
  //           pre +
  //               ((e.classId == item.classId &&
  //                   e.lessonId == lesson.lessonId &&
  //                   e.hw > -2)
  //                   ? 1
  //                   : 0));
  //       double pts = listAllStudentLessons.fold(
  //           0,
  //               (pre, e) =>
  //           pre +
  //               ((e.classId == item.classId &&
  //                   e.lessonId == lesson.lessonId &&
  //                   e.hw > -1)
  //                   ? e.hw
  //                   : 0));
  //       int sumItem = listAllStudentLessons.fold(
  //           0,
  //               (pre, e) =>
  //           pre +
  //               ((e.classId == item.classId && e.lessonId == lesson.lessonId)
  //                   ? 1
  //                   : 0));
  //
  //       rateAttend = rateAttend + (sumItem == 0 ? 0 : (att / sumItem));
  //       rateSub = rateSub + (sumItem == 0 ? 0 : (sub / sumItem));
  //
  //       attendances.add(att);
  //       submits.add(sub);
  //       points.add(pts);
  //     }
  //
  //     listAttendance!.add(attendances);
  //     listSubmit!.add(submits);
  //     listPoint!.add(points);
  //     rateAttendance!.add(activeLessonResults.isEmpty ? 0 : rateAttend / activeLessonResults.length);
  //     rateSubmit!.add(activeLessonResults.isEmpty ? 0 : rateSub / activeLessonResults.length);
  //   }
  //   emit(state + 1);
  // }
}