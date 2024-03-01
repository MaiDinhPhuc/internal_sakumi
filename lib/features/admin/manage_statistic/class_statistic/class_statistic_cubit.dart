import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/chart_bill_view.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class ClassStatisticCubit extends Cubit<int>{
  ClassStatisticCubit() : super(0){
    getCount();
  }

  int? totalClass;
  int? totalClassThisMonth;
  DateTime? startDay;
  DateTime? endDay;
  List<ClassModel> listClass0 = [];
  List<ClassModel> listClass1 = [];
  bool loading = true;

  List<ChartStatisticData> classData = [];

  List<String> listStatus = [
    'Preparing',
    'InProgress',
    'Completed',
    'Cancel'
  ];

  List<String> listStatusSub = [
    'Mới tạo',
    'Đang học',
    'Hoàn thành',
    'Huỷ'
  ];

  checkLoad(StatisticFilterCubit filterController) async{
    if (endDay != null && startDay != null) {
      await loadData(filterController);
    }
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

  getCount()async{
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 1);
    int startDate = firstDayOfMonth.millisecondsSinceEpoch;
    int endDate = lastDayOfMonth.millisecondsSinceEpoch;
    totalClass = (await FireStoreDb.instance.getCount("class")).count;
    totalClassThisMonth = (await FireStoreDb.instance.getCountClass(startDate, endDate)).count;
    emit(state+1);
  }

  loadData(StatisticFilterCubit filterController) async {
    List<int> listCourseId = filterController.getCourseId(
        filterController.filter[StatisticFilter.course]!,
        filterController.filter[StatisticFilter.level]!);
    int courseSize =
    (30 / filterController.filter[StatisticFilter.type]!.length).floor();

    classData = [];
    listClass0 = [];
    listClass1 = [];

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
        var listBillTemp = await DataProvider.classStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate,0);
        var listId = listClass0.map((e) => e.classId).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.classId) == false){
            listClass0.add(i);
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
        var listBillTemp = await DataProvider.classStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate,0);
        var listId = listClass0.map((e) => e.classId).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.classId) == false){
            listClass0.add(i);
          }
        }
      }
    }

    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await DataProvider.classStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate,1);
        var listId = listClass1.map((e) => e.classId).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.classId) == false){
            listClass1.add(i);
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
        var listBillTemp = await DataProvider.classStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate,1);
        var listId = listClass1.map((e) => e.classId).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.classId) == false){
            listClass1.add(i);
          }
        }
      }
    }


    for (var i in listStatus) {
      if(i == 'Preparing' || i == 'InProgress'){
        var classTemp = listClass0.where((e) => e.classStatus == i).toList();
        classData.add(ChartStatisticData(listStatusSub[listStatus.indexOf(i)], classTemp.length.toDouble()));
      }else{
        var classTemp = listClass1.where((e) => e.classStatus == i).toList();
        classData.add(ChartStatisticData(listStatusSub[listStatus.indexOf(i)], classTemp.length.toDouble()));
      }
    }

    loading = false;
    emit(state + 1);
  }
}