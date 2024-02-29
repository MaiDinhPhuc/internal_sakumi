import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:intl/intl.dart';

class DetailBillStatisticCubit extends Cubit<int> {
  DetailBillStatisticCubit(this.listBill) : super(0) {
    loadData();
  }

  List<StudentModel> students = [];
  List<ClassModel> listClass = [];

  final List<BillModel> listBill;

  List<bool> types = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  List<bool> creators = [true, true, true, true, true];

  List<bool> currency = [true, true];

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

  List<String> listCreator = ["Vũ", "Yến", "Phương", "Thuỷ", "Thơ"];

  List<String> listCurrency = ["Tiền Việt(vnđ)", "Yên Nhật(¥)"];

  update(){
    emit(state+1);
  }

  List<BillModel> getListBill(){
    List<String> list1 = [];
    List<String> list2 = [];
    List<String> list3 = [];

    for(int i = 0; i < types.length; i++){
      if(types[i]){
        list1.add(listType[i]);
      }
    }
    for(int i = 0; i < creators.length; i++){
      if(creators[i]){
        list2.add(listCreator[i]);
      }
    }
    for(int i = 0; i < currency.length; i++){
      if(currency[i]){
        list3.add(listCurrency[i]);
      }
    }

    List<BillModel> listBill = this.listBill.where((e) => list1.contains(e.type) && list2.contains(e.creator) && list3.contains(e.currency)).toList();

    return listBill;
  }

  loadData() async {
    var stdIds = listBill.map((e) => e.userId).toList();
    var classIds = listBill.map((e) => e.classId).toList();
    for (var i in stdIds) {
      DataProvider.studentById(i, loadStudentInfo);
    }
    listClass =
        await FireBaseProvider.instance.getListClassByListIdV2(classIds);
    emit(state + 1);
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
