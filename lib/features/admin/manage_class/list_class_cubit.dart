import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/teacher_home_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:intl/intl.dart';

class LoadListClassCubit extends Cubit<int> {
  LoadListClassCubit() : super(0);

  TeacherHomeClass? data;
  List<int>? listClassIds,
      listClassType,
      listLessonCount,
      listLessonAvailable,
      listCourseIds;
  List<String>? listClassCodes,
      listClassStatus,
      listBigTitle,
      listClassNote,
      listClassDes;
  List<double>? rateAttendance, rateSubmit;
  List<CourseModel>? listAllCourse;
  List<List<int>>? rateAttendanceChart, rateSubmitChart;
  List<List<double>>? colStd;
  List<bool> listStateCourseFilter = [];
  List<bool> listClassStatusFilter = [true, true, false, false];
  List<String> listClassStatusMenu = [
    "Preparing",
    "InProgress",
    "Completed",
    "Cancel"
  ];
  List<bool> listClassTypeFilter = [true, true];
  List<String> listClassTypeMenu = ["Lớp Chung", "Lớp 1-1"];
  List<String?> listLastLessonTitle = [];
  List<String?> listLastLessonTitleNow = [];
  List<LessonModel> listLastLesson = [];

  Color getColor(String status) {
    switch (status) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon(String status) {
    switch (status) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }

  changeStatus(int id, String status) {
    int index = data!.listClassIds.indexOf(id);
    data!.listClassStatus[index] = status;
  }

  loadLastLessonTitle(int classId, int courseId, int index) async {
    List<LessonResultModel> listLessonResult =
        await FireBaseProvider.instance.getLessonResultByClassId(classId);

    if (listLessonResult.isEmpty) {
      listLastLessonTitle[data!.listClassIds.indexOf(classId)] =
          AppText.txtLastLessonEmpty.text;
      listLastLessonTitleNow[index] = AppText.txtLastLessonEmpty.text;
    } else {
      listLessonResult.sort((a, b) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
        var tempA = a.date;
        var tempB = b.date;
        if (tempA!.length == 10) {
          tempA += ' 00:00:00';
        }
        if (tempB!.length == 10) {
          tempB += ' 00:00:00';
        }
        final dateA = dateFormat.parse(tempA);
        final dateB = dateFormat.parse(tempB);
        return dateA.compareTo(dateB);
      });

      if (listLastLesson.isEmpty) {
        LessonModel lastLesson = await FireBaseProvider.instance
            .getLesson(courseId, listLessonResult.last.lessonId);
        listLastLesson.add(lastLesson);
        listLastLessonTitle[data!.listClassIds.indexOf(classId)] =
            lastLesson.title;
        listLastLessonTitleNow[index] = lastLesson.title;
      } else {
        bool check = false;
        for (var i in listLastLesson) {
          if (i.lessonId == listLessonResult.last.lessonId) {
            check = true;
            break;
          }
        }
        if (check == false) {
          LessonModel lastLesson = await FireBaseProvider.instance
              .getLesson(courseId, listLessonResult.last.lessonId);
          listLastLesson.add(lastLesson);
          listLastLessonTitle[data!.listClassIds.indexOf(classId)] =
              lastLesson.title;
          listLastLessonTitleNow[index] = lastLesson.title;
        } else {
          listLastLessonTitle[data!.listClassIds.indexOf(classId)] =
              listLastLesson
                  .firstWhere((element) =>
                      element.lessonId == listLessonResult.last.lessonId)
                  .title;
          listLastLessonTitleNow[index] = listLastLesson
              .firstWhere((element) =>
                  element.lessonId == listLessonResult.last.lessonId)
              .title;
        }
      }
    }

    emit(state + 1);
  }

  load() async {
    data = await FireBaseProvider.instance.getDataForManageClassTab();
    for (var i in data!.listClassIds) {
      listLastLessonTitle.add(null);
    }
    listAllCourse =
        data!.listCourse.where((element) => element.enable == true).toList();
    for (var i in listAllCourse!) {
      listStateCourseFilter.add(false);
    }
    filter();
    emit(state + 1);
  }

  filter() {
    List<int> listIndex = [];
    List<int> listIndexTemp1 = [];
    for (int i = 0; i < listStateCourseFilter.length; i++) {
      if (listStateCourseFilter[i] == true) {
        for (int j = 0; j < data!.listBigTitle.length; j++) {
          if ("${listAllCourse![i].name} ${listAllCourse![i].level} ${listAllCourse![i].termName}" ==
              data!.listBigTitle[j]) {
            listIndexTemp1.add(j);
          }
        }
      }
    }
    if (listIndexTemp1.isEmpty) {
      for (int j = 0; j < data!.listBigTitle.length; j++) {
        listIndexTemp1.add(j);
      }
    }
    List<int> listIndexTemp2 = [];
    for (var i in listIndexTemp1) {
      if (listClassTypeFilter[0] && !listClassTypeFilter[1]) {
        if (data!.listClassType[i] == 0) {
          listIndexTemp2.add(i);
        }
      }
      if (!listClassTypeFilter[0] && listClassTypeFilter[1]) {
        if (data!.listClassType[i] == 1) {
          listIndexTemp2.add(i);
        }
      }
      if (listClassTypeFilter[0] && listClassTypeFilter[1]) {
        listIndexTemp2.add(i);
      }
    }

    List<String> listStatusTemp = [];
    for (int i = 0; i < listClassStatusFilter.length; i++) {
      if (listClassStatusFilter[i]) {
        listStatusTemp.add(listClassStatusMenu[i]);
      }
    }
    for (var i in listIndexTemp2) {
      if (listStatusTemp.contains(data!.listClassStatus[i])) {
        listIndex.add(i);
      }
    }

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
    listCourseIds = [];
    colStd = [];
    listClassNote = [];
    listClassDes = [];
    listLastLessonTitleNow = [];

    for (var i in listIndex) {
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
      listCourseIds!.add(data!.listCourseId[i]);
      colStd!.add(data!.colStd[i]);
      listClassNote!.add(data!.listClassNote[i]);
      listClassDes!.add(data!.listClassDes[i]);
      listLastLessonTitleNow.add(listLastLessonTitle[i]);
    }

    emit(state + 1);
  }
}
