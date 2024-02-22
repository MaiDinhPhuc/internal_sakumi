import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';

class ManageBillCubit extends Cubit<int> {
  ManageBillCubit() : super(0);

  DateTime? startDay;
  DateTime? endDay;

  List<StudentModel> students = [];
  List<ClassModel> listClass = [];
  List<int> listStdId = [];
  List<int> listClassId = [];
  List<BillModel>? listBill;
  bool isLastPage = false;

  List<List<int>> listLastBill = [];

  updateListBill(BillModel billModel, BillModel newBill) async {
    var index = listBill!.indexOf(billModel);
    listBill![index] = newBill;
    await loadStudentAndClass([newBill.userId], [newBill.classId]);
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

  checkLoad(BillFilterCubit filterController) async{
    if (endDay != null && startDay != null) {
      await loadData(filterController);
    }
  }

  clearDate() {
    startDay = null;
    endDay = null;
    emit(state + 1);
  }

  loadData(BillFilterCubit filterController) async {
    isLastPage = false;

    List? listType = filterController.filter[BillFilter.type];
    List? listStatus = filterController.filter[BillFilter.status];
    List? listCreator = filterController.filter[BillFilter.creator];
    List<String> listTypeQuery = listType!.map((e) => billType(e)).toList();
    List<String> listStatusQuery =
    listStatus!.map((e) => billStatus(e)).toList();
    List<String> listCreatorQuery =
    listCreator!.map((e) => billCreator(e)).toList();

    int typeSize = (30 /
        (filterController.filter[BillFilter.status]!.length *
            filterController.filter[BillFilter.creator]!.length))
        .floor();

    List<List<String>> subLists = [];
    for (int i = 0; i < listTypeQuery.length; i += typeSize) {
      List<String> subList = listTypeQuery.sublist(
          i,
          i + typeSize > listTypeQuery.length
              ? listTypeQuery.length
              : i + typeSize);
      subLists.add(subList);
    }
    listBill = [];
    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      List<int> lastBills = [];
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await FireBaseProvider.instance
            .getListBillWithFilterAndDate(listStatusQuery, subLists[i],
            listCreatorQuery, startDate, endDate);
        if(listBillTemp.isNotEmpty){
          listBill!.addAll(listBillTemp);
          lastBills.add(listBillTemp.last.createDate);
        }else{
          lastBills.add(9999999999999);
        }
      }
      listLastBill.add(lastBills);
    } else {
      List<int> lastBills = [];
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await FireBaseProvider.instance.getListBillWithFilter(
            listStatusQuery, subLists[i], listCreatorQuery);
        if(listBillTemp.isNotEmpty){
          listBill!.addAll(listBillTemp);
          lastBills.add(listBillTemp.last.createDate);
        }else{
          lastBills.add(9999999999999);
        }
      }
      listLastBill.add(lastBills);
    }

    if (listBill!.length < 10) {
      isLastPage = true;
    }

    List<int> stdIdTemp = [];
    List<int> classIdTemp = [];
    for (var i in listBill!) {
      if (listStdId.contains(i.userId) == false) {
        listStdId.add(i.userId);
        stdIdTemp.add(i.userId);
      }
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
        classIdTemp.add(i.classId);
      }
    }

    emit(state + 1);
    loadStudentAndClass(stdIdTemp, classIdTemp);
  }

  addNewBill(BillModel newBill) {
    listBill!.add(newBill);
    loadStudentAndClass([newBill.userId], [newBill.classId]);
    emit(state + 1);
  }

  loadStudentAndClass(List<int> stdIds, List<int> classIds) async {
    var listStdId = students.map((e) => e.userId).toList();
    for (var i in stdIds) {
      if (listStdId.contains(i) == false) {
        DataProvider.studentById(i, loadStudentInfo);
      }
    }
    List<ClassModel> listClassNew =
        await FireBaseProvider.instance.getListClassByListId(classIds);
    var listClassId = listClass.map((e) => e.classId).toList();
    for (var i in listClassNew) {
      if (listClassId.contains(i.classId) == false) {
        listClass.add(i);
      }
    }
    emit(state + 1);
  }

  String getStudent(int stdId) {
    var std = students.where((e) => e.userId == stdId).toList();
    if (std.isEmpty) {
      return "";
    }
    return std.first.name;
  }

  String getClassCode(int classId) {
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if (classModel.isEmpty) {
      return "";
    }
    return classModel.first.classCode;
  }

  String convertDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
  }

  loadMore(BillFilterCubit filterController) async {
    List? listType = filterController.filter[BillFilter.type];
    List? listStatus = filterController.filter[BillFilter.status];
    List? listCreator = filterController.filter[BillFilter.creator];
    List<String> listTypeQuery = listType!.map((e) => billType(e)).toList();
    List<String> listStatusQuery =
    listStatus!.map((e) => billStatus(e)).toList();
    List<String> listCreatorQuery =
    listCreator!.map((e) => billCreator(e)).toList();

    int typeSize = (30 /
        (filterController.filter[BillFilter.status]!.length *
            filterController.filter[BillFilter.creator]!.length))
        .floor();

    List<List<String>> subLists = [];
    for (int i = 0; i < listTypeQuery.length; i += typeSize) {
      List<String> subList = listTypeQuery.sublist(
          i,
          i + typeSize > listTypeQuery.length
              ? listTypeQuery.length
              : i + typeSize);
      subLists.add(subList);
    }
    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      List<BillModel> newListBill = [];
      List<int> lastBills = listLastBill.last;
      List<int> lastBillNew = [];
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await FireBaseProvider.instance
            .getMoreListBillWithFilterAndDate(listStatusQuery, subLists[i],
            listCreatorQuery, lastBills[i], startDate, endDate);
        if(listBillTemp.isNotEmpty){
          listBill!.addAll(listBillTemp);
          lastBillNew.add(listBillTemp.last.createDate);
          newListBill.addAll(listBillTemp);
        }else{
          lastBills.add(9999999999999);
        }
      }
      if(lastBillNew.isNotEmpty){
        listLastBill.add(lastBillNew);
      }
      var stdIds = newListBill.map((e) => e.userId).toList();
      var classIds = newListBill.map((e) => e.classId).toList();
      loadStudentAndClass(stdIds, classIds);
      if (newListBill.isEmpty) {
        isLastPage = true;
      }
    } else {
      List<BillModel> newListBill = [];
      List<int> lastBills = listLastBill.last;
      List<int> lastBillNew = [];
      for (int i = 0; i < subLists.length; i++) {
        var listBillTemp = await FireBaseProvider.instance
            .getMoreListBillWithFilter(listStatusQuery, subLists[i],
            listCreatorQuery, lastBills[i]);
        if(listBillTemp.isNotEmpty){
          listBill!.addAll(listBillTemp);
          lastBillNew.add(listBillTemp.last.createDate);
          newListBill.addAll(listBillTemp);
        }else{
          lastBills.add(9999999999999);
        }
      }
      if(lastBillNew.isNotEmpty){
        listLastBill.add(lastBillNew);
      }
      var stdIds = newListBill.map((e) => e.userId).toList();
      var classIds = newListBill.map((e) => e.classId).toList();
      loadStudentAndClass(stdIds, classIds);
      if (newListBill.isEmpty) {
        isLastPage = true;
      }
    }
    emit(state + 1);
  }


  // Future<List<BillModel>> getListBill(Map<BillFilter, List> filter,
  //     {BillModel? lastItem, int? startDate, int? endDate}) async {
  //
  //
  //   List<BillModel> listBills = [];
  //
  //   if (lastItem == null && startDate != null && endDate != null) {
  //     List<BillModel> lastBills = [];
  //     for (int i = 0; i < subLists.length; i++) {
  //       var listBill = await FireBaseProvider.instance
  //           .getListBillWithFilterAndDate(listStatusQuery, subLists[i],
  //           listCreatorQuery, startDate, endDate);
  //       listBills.addAll(listBill);
  //       lastBills.add(listBill.last);
  //     }
  //     listLastBill.add(lastBills);
  //   } else if (lastItem != null && startDate == null && endDate == null) {
  //     List<BillModel> lastBills = listLastBill.last;
  //     List<BillModel> lastBillNew = [];
  //     for (int i = 0; i < subLists.length; i++) {
  //       var listBill = await FireBaseProvider.instance
  //           .getMoreListBillWithFilter(listStatusQuery, subLists[i],
  //           listCreatorQuery, lastBills[i].createDate);
  //       if(listBill.isNotEmpty){
  //         listBills.addAll(listBill);
  //         lastBillNew.add(listBill.last);
  //       }
  //     }
  //     if(lastBillNew.isNotEmpty){
  //       listLastBill.add(lastBillNew);
  //     }
  //   } else if (lastItem != null && startDate != null && endDate != null) {
  //     List<BillModel> lastBills = listLastBill.last;
  //     List<BillModel> lastBillNew = [];
  //     for (int i = 0; i < subLists.length; i++) {
  //       var listBill = await FireBaseProvider.instance
  //           .getMoreListBillWithFilter(listStatusQuery, subLists[i],
  //           listCreatorQuery, lastBills[i].createDate);
  //       if(listBill.isNotEmpty){
  //         listBills.addAll(listBill);
  //         lastBillNew.add(listBill.last);
  //       }
  //     }
  //     if(lastBillNew.isNotEmpty){
  //       listLastBill.add(lastBillNew);
  //     }
  //   } else {
  //     List<BillModel> lastBills = [];
  //     for (int i = 0; i < subLists.length; i++) {
  //       var listBill = await FireBaseProvider.instance.getListBillWithFilter(
  //           listStatusQuery, subLists[i], listCreatorQuery);
  //       listBills.addAll(listBill);
  //       lastBills.add(listBill.last);
  //     }
  //     listLastBill.add(lastBills);
  //   }
  //
  //   return listBills;
  // }

  static String billStatus(FilterBillStatus status) {
    switch (status) {
      case FilterBillStatus.check:
        return "check";
      case FilterBillStatus.notCheck:
        return "notCheck";
    }
  }

  static String billCreator(FilterBillCreator creator) {
    switch (creator) {
      case FilterBillCreator.Vu:
        return "Vũ";
      case FilterBillCreator.Yen:
        return "Yến";
      case FilterBillCreator.Phuong:
        return "Phương";
      case FilterBillCreator.Thuy:
        return "Thuỷ";
      case FilterBillCreator.Tho:
        return "Thơ";
    }
  }

  static String billType(FilterBillType type) {
    switch (type) {
      case FilterBillType.sale1Term:
        return "SALE - 1 KÌ";
      case FilterBillType.saleFull:
        return "SALE - FULL KHOÁ";
      case FilterBillType.saleDeposit1:
        return "SALE - CỌC 1 KÌ";
      case FilterBillType.saleDepositFull:
        return "SALE - CỌC FULL KHOÁ";
      case FilterBillType.saleBSHP1:
        return "SALE - BSHP 1 KÌ";
      case FilterBillType.saleBSHPFull:
        return "SALE - BSHP FULL KHOÁ";
      case FilterBillType.combo:
        return "COMBO";
      case FilterBillType.saleDeposit1And1:
        return "SALE - CỌC 1:1";
      case FilterBillType.upSaleFull:
        return "UPSALE - FULL KHOÁ";
      case FilterBillType.upSale1Term:
        return "UPSALE - 1 KÌ";
      case FilterBillType.upSaleTo1And1:
        return "UPSALE - TỪ NHÓM QUA 1:1";
      case FilterBillType.upSaleDeposit1:
        return "UPSALE - CỌC 1 KÌ";
      case FilterBillType.upSaleDepositFull:
        return "UPSALE - CỌC FULL KHOÁ";
      case FilterBillType.upSaleBSHP1:
        return "UPSALE - BSHP 1 KÌ";
      case FilterBillType.upSaleBSHPFull:
        return "UPSALE - BSHP FULL KHOÁ";
      case FilterBillType.renew1Term:
        return "RENEW - 1 KÌ";
      case FilterBillType.renew2Term:
        return "RENEW - 2 KÌ";
      case FilterBillType.renewDeposit1:
        return "RENEW - CỌC 1 KÌ";
      case FilterBillType.renewDeposit2:
        return "RENEW - CỌC 2 KÌ";
      case FilterBillType.renewBSHP1:
        return "RENEW - BSHP 1 KÌ";
      case FilterBillType.renewBSHP2:
        return "RENEW - BSHP 2 KÌ";
    }
  }
}
