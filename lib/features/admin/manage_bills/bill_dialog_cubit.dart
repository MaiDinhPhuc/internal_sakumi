import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_bill_cubit.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_bill_cubit.dart';

class BillDialogCubit extends Cubit<int> {
  BillDialogCubit(this.billModel, this.std) : super(0) {
    load();
  }

  final StudentModel? std;
  final BillModel? billModel;
  int? classId, userId, paymentDate, renewDate, refund, payment;
  String? type, note, creator,currency;
  TextEditingController stdSearch = TextEditingController();
  String stdSearchValue = "";
  TextEditingController classSearch = TextEditingController();
  String classSearchValue = "";
  TextEditingController stdCtrl = TextEditingController();

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

  List<String> listCreator = [
    "Vũ",
    "Yến",
    "Phương",
    "Thuỷ",
    "Thơ"
  ];

  List<String> listCurrency = [
    "Tiền Việt(vnđ)",
    "Yên Nhật(¥)"
  ];

  load() async {
    if (billModel != null) {
      classId = billModel!.classId;
      userId = billModel!.userId;
      paymentDate = billModel!.paymentDate;
      payment = billModel!.payment;
      renewDate = billModel!.renewDate;
      refund = billModel!.refund;
      type = billModel!.type;
      note = billModel!.note;
      creator = billModel!.creator;
      currency = billModel!.currency;
      var student = await FireBaseProvider.instance.getStudentById(userId!);
      var classNow = await FireBaseProvider.instance.getClassById(classId!);
      stdSearch.text = "${student.name}-${student.studentCode}";
      classSearch.text = classNow.classCode;
      emit(state + 1);
    }
    if (std != null) {
      stdCtrl.text = "${std!.name}-${std!.studentCode}";
    }
  }

  inputRefund(String newValue) {
    refund = int.parse(newValue.replaceAll(",", ""));
    emit(state + 1);
  }

  inputCreator(String newValue) {
    creator = newValue;
    emit(state + 1);
  }

  inputCurrency(String newValue) {
    currency = newValue;
    emit(state + 1);
  }

  inputPayment(String newValue){
    payment = int.parse(newValue.replaceAll(",", ""));
    emit(state+1);
  }

  inputNote(String newValue) {
    note = newValue;
    emit(state + 1);
  }

  searchStd(String newValue) {
    stdSearchValue = newValue;
    emit(state + 1);
  }

  chooseStd(String std, int userId) {
    this.userId = userId;
    stdSearch.text = std;
    emit(state + 1);
  }

  deleteStd() {
    userId = null;
    stdSearch.text = "";
    stdSearchValue = "";
    emit(state + 1);
  }

  searchClass(String newValue) {
    classSearchValue = newValue;
    emit(state + 1);
  }

  chooseClass(String className, int classId) {
    this.classId = classId;
    classSearch.text = className;
    emit(state + 1);
  }

  deleteClass() {
    classId = null;
    classSearch.text = "";
    classSearchValue = "";
    emit(state + 1);
  }

  updatePaymentDay(DateTime newValue) {
    if (renewDate == null || newValue.millisecondsSinceEpoch < renewDate!) {
      paymentDate = newValue.millisecondsSinceEpoch;
      emit(state + 1);
    }
  }

  updateRenewDay(DateTime newValue) {
    if (paymentDate == null || newValue.millisecondsSinceEpoch > paymentDate!) {
      renewDate = newValue.millisecondsSinceEpoch;
      emit(state + 1);
    }
  }

  chooseBillType(String value) {
    type = value;
    emit(state + 1);
  }

  addNewBill(ManageBillCubit cubit) async {
    BillModel newBill = BillModel(
        classId: classId!,
        userId: userId!,
        paymentDate: paymentDate!,
        renewDate: renewDate!,
        payment: payment!,
        note: note ?? "",
        refund: 0,
        type: type!,
        status: "notRefund",
        check: "notCheck",
        createDate: DateTime.now().millisecondsSinceEpoch,
        delete: false,
        creator: creator!,currency: currency ?? "Tiền Việt(vnđ)");
    await FireBaseProvider.instance.addNewBill(newBill);
    await cubit.addNewBill(newBill);
  }

  updateBill(ManageBillCubit cubit) async {
    BillModel newBill = BillModel(
        classId: classId!,
        userId: userId!,
        paymentDate: paymentDate!,
        renewDate: renewDate!,
        payment: payment!,
        note: note ?? "",
        refund: refund!,
        type: type!,
        status: billModel!.status,
        check: billModel!.check,
        createDate: billModel!.createDate,
        delete: billModel!.delete,
        creator: creator!,currency:currency?? "Tiền Việt(vnđ)");
    await FireBaseProvider.instance.updateBill(newBill);
    await cubit.updateListBill(billModel!, newBill);
  }

  addNewBillV2(ManageStdBillCubit cubit) async {
    BillModel newBill = BillModel(
        classId: classId!,
        userId: cubit.student!.userId,
        paymentDate: paymentDate!,
        renewDate: renewDate!,
        payment: payment!,
        note: note ?? "",
        refund: 0,
        type: type!,
        status: "notRefund",
        check: "notCheck",
        createDate: DateTime.now().millisecondsSinceEpoch,
        delete: false,
        creator: creator!,currency:currency?? "Tiền Việt(vnđ)");
    await FireBaseProvider.instance.addNewBill(newBill);
    await cubit.addNewBill(newBill);
  }

  updateBillV2(ManageStdBillCubit cubit) async {
    BillModel newBill = BillModel(
        classId: classId!,
        userId: cubit.student!.userId,
        paymentDate: paymentDate!,
        renewDate: renewDate!,
        payment: payment!,
        note: note ?? "",
        refund: refund!,
        type: type!,
        status: billModel!.status,
        check: billModel!.check,
        createDate: billModel!.createDate,
        delete: billModel!.delete,
        creator: creator!,currency:currency ?? "Tiền Việt(vnđ)");
    await FireBaseProvider.instance.updateBill(newBill);
    await cubit.updateListBill(billModel!, newBill);
  }
}
