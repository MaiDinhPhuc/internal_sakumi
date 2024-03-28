import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/date_choose_cubit.dart';
import 'package:internal_sakumi/model/report_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherReportCubit extends Cubit<int> {
  TeacherReportCubit() : super(0);

  DateTime? startDate;
  DateTime? endDate;

  final DateChooseCubit dateChooseCubit = DateChooseCubit();

  bool changeDate = false;

  List<ReportModel>? listReport;

  List<bool> status = [true, true, true, true];
  List<String> listStatus = ['Tốt', 'Bình thường', 'Chưa tốt', 'Tệ'];

  bool isLoading = true;
  int? userId;

  update() {
    emit(state + 1);
  }

  loadReport(String role) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 1);
    startDate = firstDayOfMonth;
    endDate = lastDayOfMonth;

    if (role == 'teacher') {
      SharedPreferences localData = await SharedPreferences.getInstance();
      int userId = localData.getInt(PrefKeyConfigs.userId)!;
      this.userId = userId;
      listReport = await FireBaseProvider.instance.getReportByTeacherId(userId);
    } else {
      int userId = int.parse(TextUtils.getName());
      this.userId = userId;
      listReport = await FireBaseProvider.instance.getReportByTeacherId(userId);
    }

    isLoading = false;
    emit(state + 1);
  }

  List<ReportModel> getListReport() {
    List<String> listStatus = [];
    for (int i = 0; i < status.length; i++) {
      if (status[i]) {
        listStatus.add(this.listStatus[i]);
      }
    }

    return listReport!
        .where((e) =>
            listStatus.contains(e.status) &&
            e.id < endDate!.millisecondsSinceEpoch &&
            e.id > startDate!.millisecondsSinceEpoch && e.delete == false)
        .toList();
  }

  bool checkIsUrl(value) {
    if (value is String) {
      return true;
    } else if (value is Uint8List) {
      return false;
    }
    return true;
  }

  setDateTime(DateTime startDate, DateTime endDate){
    this.startDate = startDate;
    this.endDate = endDate;
    changeDate = true;
    emit(state+1);
  }

  String parseDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    String formattedDate = dateFormat.format(dateTime);

    return formattedDate;
  }

  clearDate(){
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 1);
    startDate = firstDayOfMonth;
    endDate = lastDayOfMonth;
    changeDate = false;
    emit(state+1);
  }

  addNewReport(ReportModel newReport){
    listReport!.add(newReport);
    emit(state+1);
  }

  updateReport(ReportModel newReport){
    var index = listReport!.indexOf(listReport!.firstWhere((e) => e.id == newReport.id));
    listReport![index] = newReport;
    emit(state+1);
  }

  removeReport(int id) async {
    var index = listReport!.indexOf(listReport!.firstWhere((e) => e.id == id));
    listReport!.remove(listReport![index]);
    emit(state+1);
    await  FirebaseFirestore.instance.collection('reports').doc('report_$id').update({
      'delete': true
    });
  }

  String convertDate(int time){


    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    DateFormat formattedDate = DateFormat('HH:mm:ss - dd/MM/yyyy');
    String formattedString = formattedDate.format(dateTime);

    return formattedString;
  }
}
