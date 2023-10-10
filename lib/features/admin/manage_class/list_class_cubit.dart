import 'dart:ui';

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
  List<int>? listClassIds, listClassType, listLessonCount, listLessonAvailable, listCourseIds;
  List<String>? listClassCodes, listClassStatus, listBigTitle;
  List<double>? rateAttendance, rateSubmit;
  List<CourseModel>? listAllCourse;
  List<List<int>>? rateAttendanceChart, rateSubmitChart;
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

  Color getColor(String status){
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

  String getIcon(String status){
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

  changeStatus(int id, String status){
    int index = data!.listClassIds.indexOf(id);
    data!.listClassStatus[index] = status;
  }

  init() async {
    data = await FireBaseProvider.instance.getDataForManageClassTab();
    listAllCourse = data!.listCourse;
    for (var i in listAllCourse!) {
      listStateCourseFilter.add(false);
    }
    filter();
    emit(state + 1);
  }


  updateData()async{
    data = await FireBaseProvider.instance.getDataForManageClassTab();
  }

  filter() {
    List<int> listIndex = [];
    List<int> listIndexTemp1 = [];
    for(int i = 0; i<listStateCourseFilter.length; i++ ){
      if(listStateCourseFilter[i] == true){
        for(int j = 0; j<data!.listBigTitle.length; j++){
          if("${listAllCourse![i].name} ${listAllCourse![i].level} ${listAllCourse![i].termName}" == data!.listBigTitle[j]){
            listIndexTemp1.add(j);
          }
        }
      }
    }
    if(listIndexTemp1.isEmpty){
      for(int j = 0; j< data!.listBigTitle.length; j++){
        listIndexTemp1.add(j);
      }
    }
    List<int> listIndexTemp2 = [];
    for(var i in listIndexTemp1){
      if(listClassTypeFilter[0] && !listClassTypeFilter[1]){
        if(data!.listClassType[i] == 0){
          listIndexTemp2.add(i);
        }
      }
      if(!listClassTypeFilter[0] && listClassTypeFilter[1]){
        if(data!.listClassType[i] == 1){
          listIndexTemp2.add(i);
        }
      }
      if(listClassTypeFilter[0] && listClassTypeFilter[1]){
        listIndexTemp2.add(i);
      }
    }

    List<String> listStatusTemp = [];
    for(int i= 0; i<listClassStatusFilter.length; i++){
      if(listClassStatusFilter[i]){
        listStatusTemp.add(listClassStatusMenu[i]);
      }
    }
    for(var i in listIndexTemp2){
      if(listStatusTemp.contains(data!.listClassStatus[i])){
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
    }

    emit(state + 1);
  }
}
