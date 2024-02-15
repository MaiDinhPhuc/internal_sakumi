import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';

class ManageStdBillCubit extends Cubit<int> {
  ManageStdBillCubit() : super(0) {
    loadBill();
  }

  List<BillModel>? listBill;
  List<ClassModel>? listClass;
  List<int> listClassId = [];
  StudentModel? student;
  bool loading = true;


  updateListBill(BillModel billModel, BillModel newBill) async {
    var index = listBill!.indexOf(billModel);
    listBill![index] = newBill;
    int length = listClassId.length;
    for (var i in listBill!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }
    if(listClassId.length != length){
      listClass = await FireBaseProvider.instance.getListClassByListId(listClassId);
    }
    emit(state+1);
  }


  addNewBill(BillModel newBill)async{
    listBill!.add(newBill);
    int length = listClassId.length;
    for (var i in listBill!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }
    if(listClassId.length != length){
      listClass = await FireBaseProvider.instance.getListClassByListId(listClassId);
    }
    emit(state+1);
  }

  loadBill() async {
    int stdId = int.parse(TextUtils.getName());
    await DataProvider.studentById(stdId, loadStudentInfo);
    listBill = await FireBaseProvider.instance.getListBillByStdId(stdId);
    for (var i in listBill!) {
      if (listClassId.contains(i.classId) == false) {
        listClassId.add(i.classId);
      }
    }
    listClass = await FireBaseProvider.instance.getListClassByListId(listClassId);
    loading = false;
    emit(state+1);
  }

  String getClassCode(int classId){
    if(listClass == null) return "";
    var classTemp = listClass!.where((e) => e.classId == classId).toList();
    if(classTemp.isEmpty) return "";
    return classTemp.first.classCode;
  }

  String convertDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }


  loadStudentInfo(Object student) {
    this.student = student as StudentModel;
  }
}
