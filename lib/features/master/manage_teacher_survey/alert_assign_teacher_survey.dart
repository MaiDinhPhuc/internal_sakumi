import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/search_in_bill.dart';
import 'package:internal_sakumi/features/master/manage_student_survey/alert_assign_teacher_survey_cubit.dart';
import 'package:internal_sakumi/services/custom_firebase_firestore.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'manage_assign_teacher_survey_cubit.dart';

void alertAssignTeacherSurvey(
    BuildContext context, ManageAssignTeacherSurveyCubit cubit) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAssignTeacherSurveyCubit(),
            child: BlocBuilder<AlertAssignTeacherSurveyCubit, int>(
              builder: (c, _) {
                var assignCubit =
                    BlocProvider.of<AlertAssignTeacherSurveyCubit>(c);
                return assignCubit.listSurvey == null
                    ? const WaitingAlert()
                    : Dialog(
                        backgroundColor: Colors.white,
                        insetPadding:
                            EdgeInsets.all(Resizable.padding(context, 10)),
                        child: Form(
                            key: formKey,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.8,
                              padding: EdgeInsets.all(
                                  Resizable.padding(context, 20)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 10,
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Resizable.padding(context, 20)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: Resizable.padding(
                                                          context, 15)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          AppText
                                                              .txtAssignSurvey
                                                              .text
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize:
                                                                  Resizable.font(
                                                                      context,
                                                                      20))),
                                                      SizedBox(
                                                          height:
                                                              Resizable.font(
                                                                  context, 55)),
                                                      Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            ...assignCubit.listSurvey!.map(
                                                                (e) => Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: Resizable.padding(
                                                                            context,
                                                                            5)),
                                                                    child: BlocProvider(
                                                                      create: (context) => CheckStateCubit( assignCubit.checkSurvey(e.id)),
                                                                      child: BlocBuilder<CheckStateCubit, bool>(
                                                                        builder: (cc, ss) {
                                                                          var checkCubit = BlocProvider.of<CheckStateCubit>(cc);
                                                                          return InkWell(
                                                                              onTap: () {
                                                                                if (assignCubit
                                                                                    .checkSurvey(e.id)) {
                                                                                  assignCubit.removeSurvey(e.id);
                                                                                } else {
                                                                                  assignCubit.addSurvey(e.id);
                                                                                }
                                                                                checkCubit.change();
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(Resizable.padding(
                                                                                    context,
                                                                                    5)),
                                                                                decoration:
                                                                                BoxDecoration(
                                                                                  border:
                                                                                  Border.all(width: 1, color: ss ? primaryColor : grey2),
                                                                                  borderRadius:
                                                                                  BorderRadius.circular(5),
                                                                                ),
                                                                                child:
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(ss ? Icons.check_box : Icons.check_box_outline_blank, color: ss ? primaryColor : Colors.black),
                                                                                    Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 5)), child: Text(e.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.font(context, 18))))
                                                                                  ],
                                                                                ),
                                                                              ));
                                                                        },
                                                                      ),
                                                                    ) ))
                                                          ],
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SearchInBill(
                                                      hint: AppText
                                                          .txtSearchTeacher
                                                          .text,
                                                      onDelete: () {},
                                                      onChange: (newValue) {
                                                        assignCubit.searchClass(
                                                            newValue);
                                                      },
                                                      controller: assignCubit
                                                          .teacherCon,
                                                      enable: true),
                                                  SizedBox(
                                                      height: Resizable.padding(
                                                          context, 20)),
                                                  Expanded(
                                                      child: StreamBuilder<
                                                              QuerySnapshot>(
                                                          stream:
                                                              CustomFirebaseFireStore
                                                                  .database
                                                                  .collection(
                                                                      "teacher")
                                                                  .snapshots(),
                                                          builder:
                                                              (c, snapshots) {
                                                            return (snapshots
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting)
                                                                ? Container()
                                                                : ListView
                                                                    .builder(
                                                                        itemCount: snapshots
                                                                            .data!
                                                                            .docs
                                                                            .length,
                                                                        itemBuilder:
                                                                            (c, index) {
                                                                          var data = snapshots
                                                                              .data!
                                                                              .docs[index]
                                                                              .data() as Map<String, dynamic>;
                                                                          if (data["name"].toString().toLowerCase().contains(assignCubit.teacherSearchValue.toLowerCase()) ||
                                                                              data["teacher_code"].toString().toLowerCase().contains(assignCubit.teacherSearchValue.toLowerCase()) ||
                                                                              data["email"].toString().toLowerCase().contains(assignCubit.teacherSearchValue.toLowerCase())) {
                                                                            return Padding(
                                                                                padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                                                                                child: BlocProvider(
                                                                                  create: (context) => CheckStateCubit(assignCubit.checkTeacher(data['user_id'] as int)),
                                                                                  child: BlocBuilder<CheckStateCubit, bool>(
                                                                                    builder: (cc, ss) {
                                                                                      var checkCubit = BlocProvider.of<CheckStateCubit>(cc);
                                                                                      return InkWell(
                                                                                        onTap: () {
                                                                                          if (assignCubit.checkTeacher(data['user_id'] as int)) {
                                                                                            assignCubit.removeTeacher(data['user_id'] as int);
                                                                                          } else {
                                                                                            assignCubit.addTeacher(data['user_id'] as int);
                                                                                          }
                                                                                          checkCubit.change();
                                                                                        },
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(Resizable.padding(context, 5)),
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(width: 1, color: ss ? primaryColor : grey2),
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Icon(ss ? Icons.check_box : Icons.check_box_outline_blank, color: ss ? primaryColor : Colors.black),
                                                                                              Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 5)), child: Text("${data["name"].toString()} - ${data["teacher_code"].toString()}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: Resizable.font(context, 18))))
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ));
                                                                          }
                                                                          return Container();
                                                                        });
                                                          }))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: Resizable.size(
                                                        context, 100),
                                                    minHeight: Resizable.size(
                                                        context, 20)),
                                                margin: EdgeInsets.only(
                                                    right: Resizable.padding(
                                                        context, 20)),
                                                child: DialogButton(
                                                    AppText.textCancel.text
                                                        .toUpperCase(),
                                                    onPressed: () =>
                                                        Navigator.pop(context)),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: Resizable.size(
                                                        context, 100),
                                                    minHeight: Resizable.size(
                                                        context, 20)),
                                                child: SubmitButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        int millisecondsSinceEpoch =
                                                            DateTime.now()
                                                                .millisecondsSinceEpoch;
                                                      } else {
                                                        debugPrint(
                                                            'Form is invalid');
                                                      }
                                                    },
                                                    title: AppText
                                                        .txtAssignTest.text),
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            )));
              },
            ));
      });
}
