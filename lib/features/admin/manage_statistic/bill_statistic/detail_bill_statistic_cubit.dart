import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';

class DetailBillStatisticCubit extends Cubit<int>{
  DetailBillStatisticCubit(this.listBill):super(0){
    loadData();
  }

  List<StudentModel> students = [];
  List<ClassModel> listClass = [];

  final List<BillModel> listBill;



  loadData()async{
    var stdIds = listBill.map((e) => e.userId).toList();
    var classIds = listBill.map((e) => e.classId).toList();
    for (var i in stdIds) {
        DataProvider.studentById(i, loadStudentInfo);
    }
    listClass = await FireBaseProvider.instance.getListClassByListIdV2(classIds);
    emit(state+1);
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
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
}