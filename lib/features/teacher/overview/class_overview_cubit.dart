import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/class_overview_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ClassOverviewCubit extends Cubit<int> {
  ClassOverviewCubit() : super(0);

  ClassOverViewModel? data;

  ClassModel? classModel;
  List<StudentClassModel>? listStdClass;
  List<StudentModel>? students;
  List<double>? listAttendance, listHomework;
  List<Map<String, dynamic>>? listStdDetail;
  int countAvailable = 0;
  double? percentHw;
  List<String> listStudentStatusMenu = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];

  loadFirst() async {
    data = await FireBaseProvider.instance
        .getDataForClassOverViewTab(int.parse(TextUtils.getName()));

    classModel = data!.classModel;
    listStdClass = data!.listStdClass;
    students = data!.students;
    listAttendance = data!.listAttendance;
    listHomework = data!.listHomework;
    listStdDetail = data!.listStdDetail;
    percentHw = data!.percentHw;

    for (var i in listStdClass!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        countAvailable++;
      }
    }
    emit(state + 1);
  }

  loadAfterRemove()async {
    data = await FireBaseProvider.instance
        .getDataForClassOverViewTab(int.parse(TextUtils.getName()));

    classModel = data!.classModel;
    listStdClass = data!.listStdClass;
    students = data!.students;
    listAttendance = data!.listAttendance;
    listHomework = data!.listHomework;
    listStdDetail = data!.listStdDetail;
    percentHw = data!.percentHw;
    countAvailable = 0;
    for (var i in listStdClass!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        countAvailable++;
      }
    }
    emit(state + 1);
  }
}
