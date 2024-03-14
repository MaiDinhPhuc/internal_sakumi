import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_bills/date_choose_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/chart_bill_view.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

class StudentStatisticCubit extends Cubit<int>{
  StudentStatisticCubit() : super(0){
    setUpDate();
    getCount();
  }

  final DateChooseCubit dateChooseCubit = DateChooseCubit();
  DateTime now = DateTime.now();
  bool isChooseDate = false;
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


  setDate(DateTime start, DateTime end){
    isChooseDate = true;
    startDay = start;
    endDay = end;
    emit(state+1);
  }

  setUpDate(){
    startDay = DateTime(now.year, now.month, 1);
    endDay = DateTime(now.year, now.month +1 , 1);
  }

  clearDate() {
    isChooseDate = false;

    setUpDate();

    emit(state + 1);
  }

  checkLoad(StatisticFilterCubit filterController) async{
      await loadData(filterController);
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

    for (int i = 0; i < subLists.length; i++) {
      var listLogTemp = await DataProvider.studentClassLogStatistic(
          filterController.filter, 1, subLists[i], startDay!.millisecondsSinceEpoch, endDay!.millisecondsSinceEpoch);
      var listId = listLog.map((e) => e.id).toList();
      for(var i in listLogTemp){
        if(listId.contains(i.id) == false){
          listLog.add(i);
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