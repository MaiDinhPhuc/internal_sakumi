import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_schedule_cubit.dart';

class AddCyclicScheduleCubit extends Cubit<int> {
  AddCyclicScheduleCubit(this.schedule) : super(0) {
    loadData();
  }
  int? classId;
  TextEditingController classSearch = TextEditingController();
  String classSearchValue = "";

  List<int> listClassId = [];

  ScheduleModel? schedule;

  String fromHour = "19";
  String fromMinute = "00";
  String toHour = "21";
  String toMinute = "00";

  DateTime? startDate;
  DateTime? endDate;

  bool checkExistSchedule = true;

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

  int? teacherId;
  TextEditingController teacherSearch = TextEditingController();
  String teacherSearchValue = "";

  loadData()async{
    if (schedule != null) {
      teacherId = schedule!.teacherId;
      classId = schedule!.classId;
      startDate =DateTime.fromMillisecondsSinceEpoch(schedule!.startDate);
      endDate = DateTime.fromMillisecondsSinceEpoch(schedule!.endDate);
      listCheckTime = [
        schedule!.calendar['Mon'],
        schedule!.calendar['Tue'],
        schedule!.calendar['Wed'],
        schedule!.calendar['Thu'],
        schedule!.calendar['Fri'],
        schedule!.calendar['Sat'],
        schedule!.calendar['Sun']
      ];
      for (int i = 0; i < 7; i++) {
        if (listCheckTime[i] != "") {
          listCheckDay[i] = true;
        }
      }
      await getClassInfo();
    }
  }

  getClassInfo() async {
    var classModel = await FireBaseProvider.instance.getClassById(classId!);
    classSearch.text = classModel.classCode;
    var teacher = await FireBaseProvider.instance.getTeacherById(teacherId!);
    teacherSearch.text = "${teacher.name} - ${teacher.teacherCode}";
    emit(state+1);
  }

  checkSchedule() async {
    checkExistSchedule = true;
    List<ScheduleModel> listSchedule =
        await FireBaseProvider.instance.getTeacherCyclicScheduleInClass(teacherId!, classId!);
    if (listSchedule.isNotEmpty) {
      checkExistSchedule = false;
      return;
    }
  }

  addNewCyclicSchedule(ManageScheduleCubit cubit) async {
    DateTime now = DateTime.now();
    if (schedule == null){
      ScheduleModel newSchedule = ScheduleModel(
          id: now.millisecondsSinceEpoch,
          teacherId: teacherId!,
          status: "teaching",
          classId: classId!,
          type: "cyclic",
          date: now.millisecondsSinceEpoch,
          calendar: {
            'Mon': listCheckTime[0],
            'Tue': listCheckTime[1],
            'Wed': listCheckTime[2],
            'Thu': listCheckTime[3],
            'Fri': listCheckTime[4],
            'Sat': listCheckTime[5],
            'Sun': listCheckTime[6]
          },
          startDate: startDate!.millisecondsSinceEpoch,
          endDate: endDate!.millisecondsSinceEpoch,
          time: '');
      cubit.addSchedule(newSchedule);
      await FireBaseProvider.instance.addNewSchedule(newSchedule);
    } else {
      ScheduleModel newSchedule = ScheduleModel(
          id: schedule!.id,
          teacherId: teacherId!,
          status: "teaching",
          classId: classId!,
          type: schedule!.type,
          calendar: {
            'Mon': listCheckTime[0],
            'Tue': listCheckTime[1],
            'Wed': listCheckTime[2],
            'Thu': listCheckTime[3],
            'Fri': listCheckTime[4],
            'Sat': listCheckTime[5],
            'Sun': listCheckTime[6]
          },
          date: schedule!.date,
          time: '',
          startDate: startDate!.millisecondsSinceEpoch,
          endDate: endDate!.millisecondsSinceEpoch);
      cubit.updateSchedule(newSchedule);
      await FireBaseProvider.instance.updateSchedule(newSchedule);

    }
  }

  loadTime(int index) {
    if (listCheckTime[index] == "") {
      fromHour = "19";
      fromMinute = "00";
      toHour = "21";
      toMinute = "00";
    } else {
      String timeString = listCheckTime[index];
      List<String> parts = timeString.split(' - ');
      List<String> fromParts = parts[0].split(':');
      List<String> toParts = parts[1].split(':');

      fromHour = fromParts[0];
      fromMinute = fromParts[1];
      toHour = toParts[0];
      toMinute = toParts[1];
    }
  }

  cancelDay(int index) {
    listCheckDay[index] = false;
    listCheckTime[index] = "";
    fromHour = "19";
    fromMinute = "00";
    toHour = "21";
    toMinute = "00";
    emit(state + 1);
  }

  chooseDay(int index) {
    listCheckDay[index] = true;
    listCheckTime[index] = "$fromHour:$fromMinute - $toHour:$toMinute";
    fromHour = "19";
    fromMinute = "00";
    toHour = "21";
    toMinute = "00";
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
    listClassId = [];
    emit(state + 1);
  }

  chooseTeacher(String teacher, int userId) async {
    teacherId = userId;
    teacherSearch.text = teacher;
    listClassId = (await FireBaseProvider.instance.getTeacherClassById(teacherId!)).map((e) => e.classId).toList();
    emit(state + 1);
  }

  chooseEndDate(DateTime value) {
    endDate = value;
    emit(state + 1);
  }

  chooseStartDate(DateTime value) {
    startDate = value;
    emit(state + 1);
  }
}
