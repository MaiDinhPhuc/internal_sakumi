import 'dart:ui';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_home_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherCubit extends Cubit<int> {
  TeacherCubit() : super(0);

  TeacherHomeClass? data;

  List<int>? listClassIds,
      listClassType,
      listLessonCount,
      listLessonAvailable;
  List<String>? listClassCodes, listClassStatus, listBigTitle;
  List<double>? rateAttendance, rateSubmit;
  List<List<int>>? rateAttendanceChart, rateSubmitChart;
  List<bool> listFilter = [true, false];
  List<String> listClassStatusMenu = ["InProgress", "Completed"];
  loadFirst() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    int teacherId =
        int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
    data =
        await FireBaseProvider.instance.getDataForTeacherHomeScreen(teacherId);
    filter();
    emit(state + 1);
  }

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
      }else{
        for(int i = 0; i<data!.listClassStatus.length; i++){
          if(data!.listClassStatus[i] == listClassStatusMenu[1]){
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
}
