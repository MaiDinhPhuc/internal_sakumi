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

  updateStartDay(DateTime newValue){
    startDay = newValue;
    emit(state+1);
  }

  updateEndDay(DateTime newValue){
    endDay = newValue;
    emit(state+1);
  }

  clearDate(){
    startDay = null;
    endDay = null;
    emit(state+1);
  }

  loadData(BillFilterCubit filterController)async{
    if(startDay != null && endDay != null){
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      listBill = await DataProvider.listBill(filterController.filter, startDate: startDate, endDate: endDate);
    }else{
      listBill = await DataProvider.listBill(filterController.filter);
    }

    List<int> stdIdTemp = [];
    List<int> classIdTemp = [];
    for(var i in listBill!){
      if(listStdId.contains(i.userId) == false){
        listStdId.add(i.userId);
        stdIdTemp.add(i.userId);
      }
      if(listClassId.contains(i.classId) == false){
        listClassId.add(i.classId);
        classIdTemp.add(i.classId);
      }
    }
    emit(state+1);
    loadStudentAndClass(stdIdTemp,classIdTemp);
  }

  loadStudentAndClass(List<int> stdIds, List<int> classIds)async{
    for(var i in stdIds){
      DataProvider.studentById(i, loadStudentInfo);
    }
    List<ClassModel> listClassNew = await FireBaseProvider.instance.getListClassForTeacher(classIds);
    listClass.addAll(listClassNew);
    emit(state+1);
  }

  String getStudent(int stdId){
    var std = students.where((e) => e.userId == stdId).toList();
    if(std.isEmpty){
      return "";
    }
    return std.first.name;
  }

  String getClassCode(int classId){
    var classModel = listClass.where((e) => e.classId == classId).toList();
    if(classModel.isEmpty){
      return "";
    }
    return classModel.first.classCode;
  }

  String convertDate(int date){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
  }

  loadMore(BillFilterCubit filterController, )async{
    BillModel lastBill = listBill!.last;
    if(startDay != null && endDay != null){
      int startDate = startDay!.millisecondsSinceEpoch;
      int endDate = endDay!.millisecondsSinceEpoch;
      List<BillModel> newListBill = await DataProvider.listBill(filterController.filter, startDate: startDate, endDate: endDate, lastItem:lastBill);
      listBill!.addAll(newListBill);
    }else{
      List<BillModel> newListBill = await DataProvider.listBill(filterController.filter, lastItem: lastBill);
      listBill!.addAll(newListBill);
    }
    emit(state+1);
  }

}
