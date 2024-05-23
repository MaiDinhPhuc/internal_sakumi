import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_schedule_cubit.dart';

class AddSingleScheduleCubit extends Cubit<int> {
  AddSingleScheduleCubit(this.schedule) : super(0) {
    loadData();
  }

  int? classId;
  TextEditingController classSearch = TextEditingController();
  String classSearchValue = "";

  int? teacherId;
  TextEditingController teacherSearch = TextEditingController();
  String teacherSearchValue = "";

  ScheduleModel? schedule;

  String fromHour = "00";
  String fromMinute = "00";
  String toHour = "00";
  String toMinute = "00";

  DateTime? date;

  changeTeacherLoad(int classId, DateTime date)async{
    this.classId = classId;
    this.date = date;
    var classModel = await FireBaseProvider.instance.getClassById(classId!);
    classSearch.text = classModel.classCode;
    emit(state + 1);
  }

  loadData() async {
    if (schedule != null) {
      teacherId = schedule!.teacherId;
      classId = schedule!.classId;
      date = DateTime.fromMillisecondsSinceEpoch(schedule!.date);
      String timeString = schedule!.time;

      List<String> parts = timeString.split(' - ');
      List<String> fromParts = parts[0].split(':');
      List<String> toParts = parts[1].split(':');

      fromHour = fromParts[0];
      fromMinute = fromParts[1];
      toHour = toParts[0];
      toMinute = toParts[1];
      await getClassInfo();
    }
  }

  getClassInfo() async {
    var classModel = await FireBaseProvider.instance.getClassById(classId!);
    classSearch.text = classModel.classCode;
    var teacher = await FireBaseProvider.instance.getTeacherById(teacherId!);
    teacherSearch.text = "${teacher.name} - ${teacher.teacherCode}";
    emit(state + 1);
  }

  addNewSingleSchedule(ManageScheduleCubit cubit) async {
    DateTime now = DateTime.now();
    if (schedule == null) {
      ScheduleModel newSchedule = ScheduleModel(
          id: now.millisecondsSinceEpoch,
          teacherId: teacherId!,
          status: "change_teacher",
          classId: classId!,
          type: "single",
          date: date!.millisecondsSinceEpoch,
          calendar: {},
          startDate: 0,
          endDate: 0,
          time: "$fromHour:$fromMinute - $toHour:$toMinute");

      await FireBaseProvider.instance.addNewSchedule(newSchedule);
      cubit.addSchedule(newSchedule);
    } else {
      ScheduleModel newSchedule = ScheduleModel(
          id: schedule!.id,
          teacherId: teacherId!,
          status: schedule!.status,
          classId: classId!,
          type: schedule!.type,
          calendar: schedule!.calendar,
          date: date!.millisecondsSinceEpoch,
          time: "$fromHour:$fromMinute - $toHour:$toMinute",
          startDate: schedule!.startDate,
          endDate: schedule!.endDate);
      await FireBaseProvider.instance.updateSchedule(newSchedule);
      cubit.updateSchedule(newSchedule);
    }
  }

  chooseDate(DateTime value) {
    date = value;
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
