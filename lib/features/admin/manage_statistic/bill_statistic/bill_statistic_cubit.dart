import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

import 'chart_bill_view.dart';

class BillStatisticCubit extends Cubit<int> {
  BillStatisticCubit() : super(0){
    getCount();
  }

  DateTime? startDay;
  DateTime? endDay;
  List<BillModel> listBill = [];
  bool loading = true;
  int? totalBill;
  int? totalBillThisMonth;

  List<ChartStatisticData> vndData = [];
  List<ChartStatisticData> yenData = [];

  List<String> listType = [
    "SALE - 1 KÌ",
    "SALE - FULL KHOÁ",
    "SALE - CỌC 1 KÌ",
    "SALE - CỌC FULL KHOÁ",
    "SALE - BSHP 1 KÌ",
    "SALE - BSHP FULL KHOÁ",
    "COMBO",
    "SALE - CỌC 1:1",
    "UPSALE - FULL KHOÁ",
    "UPSALE - 1 KÌ",
    "UPSALE - TỪ NHÓM QUA 1:1",
    "UPSALE - CỌC 1 KÌ",
    "UPSALE - CỌC FULL KHOÁ",
    "UPSALE - BSHP 1 KÌ",
    "UPSALE - BSHP FULL KHOÁ",
    "RENEW - 1 KÌ",
    "RENEW - 2 KÌ",
    "RENEW - CỌC 1 KÌ",
    "RENEW - CỌC 2 KÌ",
    "RENEW - BSHP 1 KÌ",
    "RENEW - BSHP 2 KÌ"
  ];

  resetData(){
    vndData = [];
    yenData = [];
    listBill = [];
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

  getCount()async{
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    int startDate = firstDayOfMonth.millisecondsSinceEpoch;
    int endDate = lastDayOfMonth.millisecondsSinceEpoch;
    totalBill = (await FireStoreDb.instance.getCount("bill")).count;
    totalBillThisMonth = (await FireStoreDb.instance.getCountBill(startDate, endDate)).count;
    emit(state+1);
  }

  loadData(StatisticFilterCubit filterController) async {
    List<int> listCourseId = filterController.getCourseId(
        filterController.filter[StatisticFilter.course]!,
        filterController.filter[StatisticFilter.level]!);
    int courseSize =
        (30 / filterController.filter[StatisticFilter.type]!.length).floor();

    vndData = [];
    yenData = [];
    listBill = [];

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
        var listBillTemp = await DataProvider.billStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate);
        var listId = listBill.map((e) => e.createDate).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.createDate) == false){
            listBill.add(i);
          }
        }
      }
    } else {
      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      int startDate = firstDayOfMonth.millisecondsSinceEpoch;
      int endDate = lastDayOfMonth.millisecondsSinceEpoch;
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await DataProvider.billStatistic(
            filterController.filter, 1, subLists[i], startDate, endDate);
        var listId = listBill.map((e) => e.createDate).toList();
        for(var i in listBillTemp){
          if(listId.contains(i.createDate) == false){
            listBill.add(i);
          }
        }
      }
    }


    for (var i in listType) {
      int vndSum = 0;
      int yenSum = 0;
      for(var j in listBill){
        if(j.type == i && j.currency == "Tiền Việt(vnđ)"){
          vndSum++;
        }
        if(j.type == i && j.currency == "Yên Nhật(¥)"){
          yenSum++;
        }
      }

      vndData.add(ChartStatisticData(i, vndSum.toDouble()));
      yenData.add(ChartStatisticData(i, yenSum.toDouble()));
    }
    loading = false;
    emit(state + 1);
  }
}
