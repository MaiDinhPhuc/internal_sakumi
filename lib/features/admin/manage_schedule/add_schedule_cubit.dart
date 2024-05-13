import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_schedule_cubit.dart';

class AddScheduleCubit extends Cubit<int> {
  AddScheduleCubit() : super(0);
  int? classId;
  TextEditingController classSearch = TextEditingController();
  String classSearchValue = "";

  String fromHour = "00";
  String fromMinute = "00";
  String toHour = "00";
  String toMinute = "00";



  bool checkExistClass = true;

  List<String> listDay = [
    "Thứ HAI",
    "Thứ BA",
    "Thứ TƯ",
    "Thứ NĂM",
    "Thứ SÁU",
    "Thứ BẢY",
    "CHỦ NHẬT"
  ];

  List<bool> listCheckDay = [false, false, false, false, false, false, false];

  List<String> listCheckTime = ["", "", "", "", "", "", ""];

  Map calender = {
    'Mon': "",
    'Tue': "",
    'Wed': "",
    'Thu': "",
    'Fri': "",
    'Sat': "",
    'Sun': ""
  };

  int? teacherId;
  TextEditingController teacherSearch = TextEditingController();
  String teacherSearchValue = "";

  checkSchedule() async {
    checkExistClass = true;
    List<TeacherClassModel> listTeacherClass =
        await FireBaseProvider.instance.getTeacherClassById(teacherId!);
    List<int> listClassId = listTeacherClass.map((e) => e.classId).toList();
    if (listClassId.contains(classId!) == false) {
      checkExistClass = false;
      return;
    }
  }

  addNewCyclicSchedule(ManageScheduleCubit cubit) async {
    List<ScheduleModel> schedule =
        await FireBaseProvider.instance.getClassCyclicSchedule(classId!);
    DateTime now = DateTime.now();
    // if(schedule.isEmpty){
    //   ScheduleModel newSchedule = ScheduleModel(
    //       id: now.millisecondsSinceEpoch,
    //       teacherId: teacherId!,
    //       status: "teaching",
    //       classId: classId!,
    //       type: "cyclic",
    //       startTime: "$fromHour:$fromMinute",
    //       endTime: "$toHour:$toMinute",
    //       role: listDayChoose,
    //       date: now.millisecondsSinceEpoch);
    //
    //   await FireBaseProvider.instance.addNewSchedule(newSchedule);
    // }else{
    //   ScheduleModel newSchedule = ScheduleModel(
    //       id: schedule.first.id,
    //       teacherId: teacherId!,
    //       status: "teaching",
    //       classId: classId!,
    //       type: schedule.first.type,
    //       calendar: "$fromHour:$fromMinute",
    //       endTime: "$toHour:$toMinute",
    //       role: listDayChoose,
    //       date: schedule.first.date);
    //   await FireBaseProvider.instance.updateTeacherCyclicSchedule(newSchedule);
    // }
  }



  chooseDay(int index) {
    if (listCheckDay[index] == true) {
      listCheckDay[index] = false;
      listCheckTime[index] = "";
    }else{
      listCheckDay[index] = true;
      listCheckTime[index] = "$fromHour:$fromMinute - $toHour:$toMinute";
      fromHour = "00";
      fromMinute = "00";
      toHour = "00";
      toMinute = "00";
    }
    emit(state + 1);
  }

  bool checkTime() {
    int? fromHour = int.tryParse(this.fromHour);
    int? fromMinute = int.tryParse(this.fromMinute);
    int? toHour = int.tryParse(this.toHour);
    int? toMinute = int.tryParse(this.toMinute);

    if (fromHour == null ||
        fromMinute == null ||
        toHour == null ||
        toMinute == null) {
      return false;
    }

    if (fromHour < 0 || fromHour >= 24) return false;
    if (toHour < 0 || toHour >= 24) return false;
    if (fromMinute < 0 || fromMinute >= 60) return false;
    if (toMinute < 0 || toMinute >= 60) return false;
    return true;
  }

  inputFromHour(newValue) {
    fromHour = newValue;
  }

  inputFromMinute(newValue) {
    fromMinute = newValue;
  }

  inputToHour(newValue) {
    toHour = newValue;
  }

  inputToMinute(newValue) {
    toMinute = newValue;
  }

  chooseClass(String className, int classId) async {
    this.classId = classId;
    classSearch.text = className;
    emit(state + 1);
  }

  deleteClass() {
    classId = null;
    classSearch.text = "";
    classSearchValue = "";
    emit(state + 1);
  }

  searchClass(String newValue) {
    classSearchValue = newValue;
    emit(state + 1);
  }

  searchTeacher(String newValue) {
    teacherSearchValue = newValue;
    emit(state + 1);
  }

  deleteTeacher() {
    teacherId = null;
    teacherSearch.text = "";
    teacherSearchValue = "";
    emit(state + 1);
  }

  chooseTeacher(String teacher, int userId) {
    teacherId = userId;
    teacherSearch.text = teacher;
    emit(state + 1);
  }
}
