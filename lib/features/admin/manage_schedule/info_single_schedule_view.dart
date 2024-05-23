import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/admin/search/item_search_list.dart';
import 'package:internal_sakumi/services/custom_firebase_firestore.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'add_single_schedule_cubit.dart';

class InfoSingleScheduleView extends StatelessWidget {
  const InfoSingleScheduleView({super.key, required this.addCubit});
  final AddSingleScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtTeacherName.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: greyColor.shade600)),
          SizedBox(height: Resizable.padding(context, 5)),
          SearchInBill(
              hint:AppText.txtSearchTeacher.text,
              onDelete: () {
                if(addCubit.schedule == null){
                  addCubit.deleteTeacher();
                }
              },
              onChange: (newValue) {
                addCubit.searchTeacher(newValue);
              },
              controller: addCubit.teacherSearch,
              enable:addCubit.schedule == null ? addCubit.teacherId == null : false),
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
                              color: greyColor.shade600))),
                  SearchInBill(
                      hint:AppText.txtSearchClass.text,
                      onDelete: () {
                        if(addCubit.schedule == null){
                          addCubit.deleteClass();
                        }

                      },
                      onChange: (newValue) {
                        addCubit.searchClass(newValue);
                      },
                      controller: addCubit.classSearch,
                      enable:addCubit.schedule == null ? addCubit.classId == null : false ),
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(
                                "Ngày dạy:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              )),
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                        child: SizedBox(
                                          height: Resizable.size(context, 250),
                                          width: Resizable.size(context, 250),
                                          child: SfDateRangePicker(
                                            cancelText: AppText.textCancel.text,
                                            onCancel: (){
                                              Navigator.pop(context);
                                            },
                                            onSubmit: (v) {
                                              var value = v as DateTime;
                                              addCubit.chooseDate(value);
                                              Navigator.pop(context);
                                            },
                                            showActionButtons: true,
                                            headerHeight: Resizable.size(context, 50),
                                            headerStyle: DateRangePickerHeaderStyle(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Resizable.font(context, 24),
                                                    color: Colors.black)),
                                            showNavigationArrow: true,
                                            selectionMode: DateRangePickerSelectionMode.single,
                                          ),
                                        ));
                                  });
                            },
                            child: IgnorePointer(
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(Icons.calendar_month_outlined),
                                  hintText: addCubit.date == null
                                      ? "dd/MM/yyyy"
                                      : DateFormat('dd/MM/yyyy').format(DateTime(
                                      addCubit.date!.year,
                                      addCubit.date!.month,
                                      addCubit.date!.day)),
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.transparent,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                              "Từ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                              Container(
                                margin:
                                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                width: Resizable.size(context, 100),
                                height: Resizable.size(context, 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.fromHour,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: addCubit.fromHour,
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputFromHour(value);
                                          },
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Resizable.padding(context, 5)),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 20)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          initialValue: addCubit.fromMinute,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputFromMinute(value);
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              Text(
                                "Đến",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                              Container(
                                margin:
                                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                width: Resizable.size(context, 100),
                                height: Resizable.size(context, 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.toHour,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputToHour(value);
                                          },
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Resizable.padding(context, 5)),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 20)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.toMinute,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputToMinute(value);
                                          },
                                        ))
                                  ],
                                ),
                              )],
                          ),
                        ],
                      ),
                      if (addCubit.classId == null)
                        StreamBuilder<QuerySnapshot>(
                            stream: CustomFirebaseFireStore.database
                                .collection("class")
                                .snapshots(),
                            builder: (c, snapshots) {
                              return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                                  ? Container()
                                  : ClassSearchSingleSchedule(
                                snapshots: snapshots, addCubit: addCubit,
                              );
                            })
                    ],
                  ),
                ],
              ),
              if (addCubit.teacherId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: CustomFirebaseFireStore.database
                        .collection("teacher")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? Container()
                          : TeacherSearchSingleSchedule(
                          snapshots: snapshots, addCubit: addCubit
                      );
                    })
            ],
          )
        ],
      ),
    );
  }
}

class InfoChangeTeacherScheduleView extends StatelessWidget {
  const InfoChangeTeacherScheduleView({super.key, required this.addCubit});
  final AddSingleScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.txtTeacherName.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 18),
                  color: greyColor.shade600)),
          SizedBox(height: Resizable.padding(context, 5)),
          SearchInBill(
              hint:AppText.txtSearchTeacher.text,
              onDelete: () {
                if(addCubit.schedule == null){
                  addCubit.deleteTeacher();
                }
              },
              onChange: (newValue) {
                addCubit.searchTeacher(newValue);
              },
              controller: addCubit.teacherSearch,
              enable: addCubit.teacherId == null ),
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
                              color: greyColor.shade600))),
                  SearchInBill(
                      hint:AppText.txtSearchClass.text,
                      onDelete: () {
                        if(addCubit.schedule == null){
                          addCubit.deleteClass();
                        }

                      },
                      onChange: (newValue) {
                        addCubit.searchClass(newValue);
                      },
                      controller: addCubit.classSearch,
                      enable: false ),
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 5)),
                              child: Text(
                                "Ngày dạy:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              )),
                          InkWell(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                        child: SizedBox(
                                          height: Resizable.size(context, 250),
                                          width: Resizable.size(context, 250),
                                          child: SfDateRangePicker(
                                            cancelText: AppText.textCancel.text,
                                            onCancel: (){
                                              Navigator.pop(context);
                                            },
                                            onSubmit: (v) {
                                              var value = v as DateTime;
                                              addCubit.chooseDate(value);
                                              Navigator.pop(context);
                                            },
                                            showActionButtons: true,
                                            headerHeight: Resizable.size(context, 50),
                                            headerStyle: DateRangePickerHeaderStyle(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Resizable.font(context, 24),
                                                    color: Colors.black)),
                                            showNavigationArrow: true,
                                            selectionMode: DateRangePickerSelectionMode.single,
                                          ),
                                        ));
                                  });
                            },
                            child: IgnorePointer(
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: const Icon(Icons.calendar_month_outlined),
                                  hintText: addCubit.date == null
                                      ? "dd/MM/yyyy"
                                      : DateFormat('dd/MM/yyyy').format(DateTime(
                                      addCubit.date!.year,
                                      addCubit.date!.month,
                                      addCubit.date!.day)),
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.transparent,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                              "Từ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                              Container(
                                margin:
                                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                width: Resizable.size(context, 100),
                                height: Resizable.size(context, 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.fromHour,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: addCubit.fromHour,
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputFromHour(value);
                                          },
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Resizable.padding(context, 5)),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 20)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          initialValue: addCubit.fromMinute,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputFromMinute(value);
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              Text(
                                "Đến",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                              Container(
                                margin:
                                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                width: Resizable.size(context, 100),
                                height: Resizable.size(context, 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.toHour,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputToHour(value);
                                          },
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Resizable.padding(context, 5)),
                                        child: Text(
                                          ":",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 20)),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child:  TextFormField(
                                          initialValue: addCubit.toMinute,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: Colors.white,
                                            hoverColor: Colors.transparent,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xffE0E0E0),
                                                  width: Resizable.size(context, 0.5)),
                                              borderRadius: BorderRadius.circular(
                                                  Resizable.padding(context, 5)),
                                            ),
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                    Resizable.padding(context, 5)),
                                                borderSide: BorderSide(
                                                    color: const Color(0xffE0E0E0),
                                                    width: Resizable.size(context, 0.5))),
                                          ),
                                          onChanged: (value) {
                                            addCubit.inputToMinute(value);
                                          },
                                        ))
                                  ],
                                ),
                              )],
                          ),
                        ],
                      ),
                      if (addCubit.classId == null)
                        StreamBuilder<QuerySnapshot>(
                            stream: CustomFirebaseFireStore.database
                                .collection("class")
                                .snapshots(),
                            builder: (c, snapshots) {
                              return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                                  ? Container()
                                  : ClassSearchSingleSchedule(
                                snapshots: snapshots, addCubit: addCubit,
                              );
                            })
                    ],
                  ),
                ],
              ),
              if (addCubit.teacherId == null)
                StreamBuilder<QuerySnapshot>(
                    stream: CustomFirebaseFireStore.database
                        .collection("teacher")
                        .snapshots(),
                    builder: (c, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? Container()
                          : TeacherSearchSingleSchedule(
                          snapshots: snapshots, addCubit: addCubit
                      );
                    })
            ],
          )
        ],
      ),
    );
  }
}