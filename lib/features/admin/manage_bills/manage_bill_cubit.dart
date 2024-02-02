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

  updateListBill(BillModel billModel, BillModel newBill) async {
    var index = listBill!.indexOf(billModel);
    listBill![index] = newBill;
    await loadStudentAndClass([newBill.userId], [newBill.classId]);
    emit(state+1);
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

  checkLoad(BillFilterCubit filterController) {
    if (endDay != null && startDay != null) {
      loadData(filterController);
    }
  }

  clearDate() {
    startDay = null;
    endDay = null;
    emit(state + 1);
  }

  loadData(BillFilterCubit filterController) async {
    isLastPage = false;
    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      listBill = await DataProvider.listBill(filterController.filter,
          startDate: startDate, endDate: endDate);
    } else {
      listBill = await DataProvider.listBill(filterController.filter);
    }

    if(listBill!.length <10){
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

  addNewBill(BillModel newBill){
    listBill!.add(newBill);
    loadStudentAndClass([newBill.userId], [newBill.classId]);
    emit(state+1);
  }

  loadStudentAndClass(List<int> stdIds, List<int> classIds) async {
    var listStdId = students.map((e) => e.userId).toList();
    for (var i in stdIds) {
      if(listStdId.contains(i) == false){
        DataProvider.studentById(i, loadStudentInfo);
      }
    }
    List<ClassModel> listClassNew =
        await FireBaseProvider.instance.getListClassByListId(classIds);
    var listClassId = listClass.map((e) => e.classId).toList();
    for(var i in listClassNew){
      if(listClassId.contains(i.classId) == false){
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

  loadMore(
    BillFilterCubit filterController,
  ) async {
    BillModel lastBill = listBill!.last;
    if (startDay != null && endDay != null) {
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      List<BillModel> newListBill = await DataProvider.listBill(
          filterController.filter,
          startDate: startDate,
          endDate: endDate,
          lastItem: lastBill);
      listBill!.addAll(newListBill);
      var stdIds = newListBill.map((e) => e.userId).toList();
      var classIds = newListBill.map((e) => e.classId).toList();
      loadStudentAndClass(stdIds,classIds);
      if (newListBill.isEmpty) {
        isLastPage = true;
      }
    } else {
      List<BillModel> newListBill = await DataProvider.listBill(
          filterController.filter,
          lastItem: lastBill);
      listBill!.addAll(newListBill);
      var stdIds = newListBill.map((e) => e.userId).toList();
      var classIds = newListBill.map((e) => e.classId).toList();
      loadStudentAndClass(stdIds,classIds);
      if (newListBill.isEmpty) {
        isLastPage = true;
      }
    }
    emit(state + 1);
  }
}
