import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';

import 'bill_dialog_cubit.dart';
import 'input_date_bill.dart';
import 'input_in_bill.dart';

class InfoBillView extends StatelessWidget {
  const InfoBillView({Key? key, required this.billDialogCubit, required this.isEdit})
      : super(key: key);
  final BillDialogCubit billDialogCubit;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtStdName.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          SizedBox(height: Resizable.padding(context, 5)),
          SearchInBill(
              onDelete: () {
                billDialogCubit.deleteStd();
              },
              onChange: (newValue) {
                billDialogCubit.searchStd(newValue);
              },
              controller: billDialogCubit.stdSearch,
              enable: billDialogCubit.userId == null),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      child: Text(AppText.txtClass.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: const Color(0xff757575)))),
                  SearchInBill(
                      onDelete: () {
                        billDialogCubit.deleteClass();
                      },
                      onChange: (newValue) {
                        billDialogCubit.searchClass(newValue);
                      },
                      controller: billDialogCubit.classSearch,
                      enable: billDialogCubit.classId == null),
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtCurrency.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? "Tiền Việt(vnđ)": billDialogCubit.billModel!.currency,
                              onChanged: (v) {
                                billDialogCubit.inputCurrency(v!);
                              },
                              items: List.generate(billDialogCubit.listCurrency.length,
                                      (index) => (billDialogCubit.listCurrency[index])).toList()),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtMoney.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputPaymentInBill(
                              initialValue: billDialogCubit.billModel == null ? "": NumberFormat('#,##0').format(billDialogCubit.billModel!.payment).toString(),
                              onChange: (value) {
                                billDialogCubit.inputPayment(value);
                              }
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                          Resizable.padding(context, 5)),
                                      child: Text(AppText.txtPaymentDate.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              Resizable.font(context, 18),
                                              color: const Color(0xff757575)))),
                                  InputDateBill(
                                    billDialogCubit: billDialogCubit,
                                    isPayment: true,
                                  )
                                ],
                              )),
                              SizedBox(width: Resizable.size(context, 20)),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Resizable.padding(context, 5)),
                                      child: Text(AppText.txtRenewDate.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color: const Color(0xff757575)))),
                                  InputDateBill(
                                    billDialogCubit: billDialogCubit,
                                    isPayment: false,
                                  )
                                ],
                              ))
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: Resizable.padding(context, 5)),
                              child: Text(AppText.txtBillType.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? AppText.txtBillType.text: billDialogCubit.billModel!.type,
                              onChanged: (v) {
                                billDialogCubit.chooseBillType(v!);
                              },
                              items: List.generate(billDialogCubit.listType.length,
                                      (index) => (billDialogCubit.listType[index])).toList()),
                          if(isEdit)
                            Padding(
                                padding: EdgeInsets.only(
                                    top: Resizable.padding(context, 5)),
                                child: Text(AppText.txtRefund.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575)))),
                          if(isEdit)
                            InputPaymentInBill(
                                initialValue: billDialogCubit.billModel == null ? "": NumberFormat('#,##0').format(billDialogCubit.billModel!.refund).toString(),
                                onChange: (value) {
                                  billDialogCubit.inputRefund(value);
                                }
                            ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtCreator.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? AppText.txtCreator.text: billDialogCubit.billModel!.creator,
                              onChanged: (v) {
                                billDialogCubit.inputCreator(v!);
                              },
                              items: List.generate(billDialogCubit.listCreator.length,
                                      (index) => (billDialogCubit.listCreator[index])).toList()),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtNote.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputInBill(
                              initialValue: billDialogCubit.billModel == null ? "": billDialogCubit.billModel!.note,
                              enable: true,
                              onChange: (value) {
                                billDialogCubit.inputNote(value);
                              },
                              isNote:true
                          ),
                        ],
                      ),
                      if (billDialogCubit.classId == null)
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("class")
                                .snapshots(),
                            builder: (c, snapshots) {
                              return (snapshots.connectionState ==
                                      ConnectionState.waiting)
                                  ? Container()
                                  : ClassSearchListV2(
                                      snapshots: snapshots,
                                      billDialogCubit: billDialogCubit);
                            })
                    ],
                  ),
                ],
              ),
              if (billDialogCubit.userId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("students")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                              ConnectionState.waiting)
                          ? Container()
                          : StdSearchListV2(
                              snapshots: snapshots,
                              billDialogCubit: billDialogCubit);
                    })
            ],
          )
        ],
      ),
    );
  }
}

class InfoBillViewV2 extends StatelessWidget {
  const InfoBillViewV2({Key? key, required this.billDialogCubit, required this.isEdit})
      : super(key: key);
  final BillDialogCubit billDialogCubit;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtStdName.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: const Color(0xff757575))),
          SizedBox(height: Resizable.padding(context, 5)),
          SearchInBillV2(
              controller: billDialogCubit.stdCtrl,
             ),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      child: Text(AppText.txtClass.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: const Color(0xff757575)))),
                  SearchInBill(
                      onDelete: () {
                        billDialogCubit.deleteClass();
                      },
                      onChange: (newValue) {
                        billDialogCubit.searchClass(newValue);
                      },
                      controller: billDialogCubit.classSearch,
                      enable: billDialogCubit.classId == null),
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtCurrency.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? "Tiền Việt(vnđ)": billDialogCubit.billModel!.currency,
                              onChanged: (v) {
                                billDialogCubit.inputCurrency(v!);
                              },
                              items: List.generate(billDialogCubit.listCurrency.length,
                                      (index) => (billDialogCubit.listCurrency[index])).toList()),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtMoney.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputPaymentInBill(
                              initialValue: billDialogCubit.billModel == null ? "": NumberFormat('#,##0').format(billDialogCubit.billModel!.payment).toString(),
                              onChange: (value) {
                                billDialogCubit.inputPayment(value);
                              }
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                              Resizable.padding(context, 5)),
                                          child: Text(AppText.txtPaymentDate.text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                  Resizable.font(context, 18),
                                                  color: const Color(0xff757575)))),
                                      InputDateBill(
                                        billDialogCubit: billDialogCubit,
                                        isPayment: true,
                                      )
                                    ],
                                  )),
                              SizedBox(width: Resizable.size(context, 20)),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                              Resizable.padding(context, 5)),
                                          child: Text(AppText.txtRenewDate.text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                  Resizable.font(context, 18),
                                                  color: const Color(0xff757575)))),
                                      InputDateBill(
                                        billDialogCubit: billDialogCubit,
                                        isPayment: false,
                                      )
                                    ],
                                  ))
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: Resizable.padding(context, 5)),
                              child: Text(AppText.txtBillType.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? AppText.txtBillType.text: billDialogCubit.billModel!.type,
                              onChanged: (v) {
                                billDialogCubit.chooseBillType(v!);
                              },
                              items: List.generate(billDialogCubit.listType.length,
                                      (index) => (billDialogCubit.listType[index])).toList()),
                          if(isEdit)
                            Padding(
                                padding: EdgeInsets.only(
                                    top: Resizable.padding(context, 5)),
                                child: Text(AppText.txtRefund.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575)))),
                          if(isEdit)
                            InputPaymentInBill(
                                initialValue: billDialogCubit.billModel == null ? "": NumberFormat('#,##0').format(billDialogCubit.billModel!.refund).toString(),
                                onChange: (value) {
                                  billDialogCubit.inputRefund(value);
                                }
                            ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtCreator.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputDropdown(
                              hint:  billDialogCubit.billModel == null ? AppText.txtCreator.text: billDialogCubit.billModel!.creator,
                              onChanged: (v) {
                                billDialogCubit.inputCreator(v!);
                              },
                              items: List.generate(billDialogCubit.listCreator.length,
                                      (index) => (billDialogCubit.listCreator[index])).toList()),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(AppText.txtNote.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18),
                                      color: const Color(0xff757575)))),
                          InputInBill(
                              initialValue: billDialogCubit.billModel == null ? "": billDialogCubit.billModel!.note,
                              enable: true,
                              onChange: (value) {
                                billDialogCubit.inputNote(value);
                              },
                              isNote:true
                          ),
                        ],
                      ),
                      if (billDialogCubit.classId == null)
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("class")
                                .snapshots(),
                            builder: (c, snapshots) {
                              return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                                  ? Container()
                                  : ClassSearchListV2(
                                  snapshots: snapshots,
                                  billDialogCubit: billDialogCubit);
                            })
                    ],
                  ),
                ],
              ),
              if (billDialogCubit.userId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("students")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? Container()
                          : StdSearchListV2(
                          snapshots: snapshots,
                          billDialogCubit: billDialogCubit);
                    })
            ],
          )
        ],
      ),
    );
  }
}
