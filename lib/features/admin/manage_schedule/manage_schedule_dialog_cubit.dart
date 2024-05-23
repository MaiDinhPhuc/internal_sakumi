import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';

import 'manage_schedule_cubit.dart';

class ManageScheduleDialogCubit extends Cubit<int> {
  ManageScheduleDialogCubit(this.cubit) : super(0){
    loadData();
  }

  final ManageScheduleCubit cubit;

  List<ScheduleModel>? listSchedule;
  List<TeacherModel>? listTeacher;

  ScheduleModel? selectedSchedule;

  String classSearchValue = "";
  Timer? _debounce;
  bool loading = true;

  bool loadingTeacher = false;

  int? classId;
  TextEditingController classController = TextEditingController();

  loadData()async{
    if(cubit.classId != null){
      classController.text = cubit.classController.text;
      classId = cubit.classId;
      listSchedule = (await FireBaseProvider.instance.getScheduleByClassId(cubit.classId!)).where((e) => e.status == "teaching" || e.status == "change_teacher").toList();
      List<int> listTeacherId = [];
      for (var element in listSchedule!) {
        if(!listTeacherId.contains(element.teacherId)){
          listTeacherId.add(element.teacherId);
        }
      }
      listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
      loading = false;
      emit(state+1);
    }else {
      listSchedule = [];
      loading = false;
      emit(state+1);
    }
  }

  searchClass(String newValue) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      classSearchValue = newValue;
      emit(state + 1);
    });
  }


  chooseClass(String className, int classId) async {
    this.classId = classId;
    classController.text = className;
  }

  loadSchedule()async{

    loadingTeacher = true;
    emit(state+1);

    listSchedule = (await FireBaseProvider.instance.getScheduleByClassId(classId!)).where((e) => e.status == "teaching" || e.status == "change_teacher").toList();
    List<int> listTeacherId = [];
    for (var element in listSchedule!) {
      if(!listTeacherId.contains(element.teacherId)){
        listTeacherId.add(element.teacherId);
      }
    }
    listTeacher = await FireBaseProvider.instance.getListTeacherByListId(listTeacherId);
    loadingTeacher = false;
    emit(state+1);
  }

  getInfo(ScheduleModel schedule){
    if(schedule.type == "single"){
      var date =  DateTime.fromMillisecondsSinceEpoch(schedule.date);
      return "${DateFormat('dd/MM/yyyy').format(DateTime(
          date.year,
          date.month,
          date.day))} ${schedule.time}";
    }

    String time = "";

    var listCheckTime = [
      schedule.calendar['Mon'],
      schedule.calendar['Tue'],
      schedule.calendar['Wed'],
      schedule.calendar['Thu'],
      schedule.calendar['Fri'],
      schedule.calendar['Sat'],
      schedule.calendar['Sun']
    ];

    var listDay = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    for (int i = 0; i < 7; i++) {
      if (listCheckTime[i] != "") {
        time += "${listDay[i]}: ${listCheckTime[i]}\n";
      }
    }

    return time.trimRight();
  }

  String getTeacher(int teacherId) {
    if (listTeacher == null) return "";
    for (var element in listTeacher!) {
      if(element.userId == teacherId){
        return element.name;
      }
    }
    return "";
  }

  selectSchedule(ScheduleModel scheduleModel){
    if(selectedSchedule == scheduleModel){
      selectedSchedule = null;
      emit(state+1);
      return;
    }
    selectedSchedule = scheduleModel;
    emit(state+1);
  }
}