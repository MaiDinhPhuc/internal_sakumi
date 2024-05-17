import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/schedule_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/services/custom_firebase_firestore.dart';

import 'manage_schedule_cubit.dart';

class ManageScheduleDialogCubit extends Cubit<int> {
  ManageScheduleDialogCubit(this.cubit) : super(0){
    loadData();
  }

  final ManageScheduleCubit cubit;

  List<ScheduleModel>? listSchedule;

  ScheduleModel? selectedSchedule;

  String classSearchValue = "";
  Timer? _debounce;
  bool loading = true;

  int? classId;
  TextEditingController classController = TextEditingController();

  loadData()async{
    if(cubit.classId != null){
      classController.text = cubit.classController.text;
      classId = cubit.classId;
      listSchedule = await FireBaseProvider.instance.getScheduleByClassId(cubit.classId!);
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
    listSchedule = await FireBaseProvider.instance.getScheduleByClassId(classId!);
    emit(state+1);
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