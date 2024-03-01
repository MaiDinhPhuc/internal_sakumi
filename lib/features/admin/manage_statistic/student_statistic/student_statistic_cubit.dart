import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/chart_bill_view.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class StudentStatisticCubit extends Cubit<int>{
  StudentStatisticCubit() : super(0){
    getCount();
  }


  int? totalStudent;
  int? totalStudentLearning;

  DateTime? startDay;
  DateTime? endDay;
  bool loading = true;
  List<StudentClassLogModel> listLog = [];

  List<ChartStatisticData> chartData = [];

  List<String> listType = [
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

  List<String> listTypeSub = [
    "Hoàn thành",
    "Đang học",
    "Người xem",
    "Đăng ký lại",
    "Lên kỳ",
    "Chuyển lớp",
    "Bảo lưu",
    "Nghỉ học",
    "Bỏ cọc",
    "Bắt buộc lên kỳ",
    "Xoá"
  ];

  String getSubType(String type){
    var index = listType.indexOf(type);
    return listTypeSub[index];
  }


  getCount()async{
    totalStudent = (await FireStoreDb.instance.getCount("students")).count;
    emit(state+1);
    var listStdClass = await FireBaseProvider.instance.getAllStudentClass();
    var listId = [];
    for(var i in listStdClass){
      if(listId.contains(i.userId) == false){
        listId.add(i.userId);
      }
    }
    totalStudentLearning = listId.length;
    emit(state+1);
  }

  clearDate() {
    startDay = null;
    endDay = null;
    emit(state + 1);
  }

  updateStartDay(DateTime newValue) {
    if (endDay == null ||
        newValue.millisecondsSinceEpoch < endDay!.millisecondsSinceEpoch) {
      startDay = newValue;
      emit(state + 1);
    }
  }

  updateEndDay(DateTime newValue) {
    if (startDay == null ||
        newValue.millisecondsSinceEpoch > startDay!.millisecondsSinceEpoch) {
      endDay = newValue;
      emit(state + 1);
    }
  }

  checkLoad(StatisticFilterCubit filterController) async{
    if (endDay != null && startDay != null) {
      await loadData(filterController);
    }
  }

  loadData(StatisticFilterCubit filterController) async {
    loading = true;
    emit(state+1);
    List<int> listCourseId = filterController.getCourseId(
        filterController.filter[StatisticFilter.course]!,
        filterController.filter[StatisticFilter.level]!);
    int courseSize =
    (30 / filterController.filter[StatisticFilter.type]!.length).floor();

    chartData = [];
    listLog = [];

    List<List<int>> subLists = [];
    for (int i = 0; i < listCourseId.length; i += courseSize) {
      List<int> subList = listCourseId.sublist(
          i,
          i + courseSize > listCourseId.length
              ? listCourseId.length
              : i + courseSize);
      subLists.add(subList);
    }
    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      for (int i = 0; i < subLists.length; i++) {
        var listLogTemp = await DataProvider.studentClassLogStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate);
        var listId = listLog.map((e) => e.id).toList();
        for(var i in listLogTemp){
          if(listId.contains(i.id) == false){
            listLog.add(i);
          }
        }
      }
    } else {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 1);
      int startDate = firstDayOfMonth.millisecondsSinceEpoch;
      int endDate = lastDayOfMonth.millisecondsSinceEpoch;
      for (int i = 0; i < subLists.length; i++) {
        var listLogTemp = await DataProvider.studentClassLogStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate);
        var listId = listLog.map((e) => e.id).toList();
        for(var i in listLogTemp){
          if(listId.contains(i.id) == false){
            listLog.add(i);
          }
        }
      }
    }

    for (var i in listType) {
      int sum = 0;
      for(var j in listLog){
        if(j.to == i ){
          sum++;
        }
      }
      chartData.add(ChartStatisticData(i, sum.toDouble()));
    }
    loading = false;
    emit(state + 1);
  }
}