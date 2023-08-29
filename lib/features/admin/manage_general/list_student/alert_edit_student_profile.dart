import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_edit_student_profile_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_student_tab.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

void alertEditStudentProfile(BuildContext context, StudentModel student) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
          create: (context) =>
              EditStudentProfileCubit()..init(context, student),
          child: BlocBuilder<EditStudentProfileCubit, int>(
            builder: (c, s) {
              var cubit = BlocProvider.of<EditStudentProfileCubit>(c);
              final TextEditingController nameCon =
                  TextEditingController(text: cubit.name);
              final TextEditingController stdCodeCon =
                  TextEditingController(text: cubit.studentCode);
              final TextEditingController phoneCon =
                  TextEditingController(text: cubit.phone);
              final TextEditingController noteCon =
                  TextEditingController(text: cubit.note);
              final TextEditingController emailCon =
                  TextEditingController(text: cubit.email);

              final GlobalKey<FormState> formKey = GlobalKey<FormState>();
              return cubit.email == ""
                  ? const WaitingAlert()
                  : BlocProvider(create: (c)=>UpdateCubit(),
              child: BlocBuilder<UpdateCubit,bool>(
                builder: (cc,state){
                  var updateCubit = BlocProvider.of<UpdateCubit>(cc);
                  return Dialog(
                    child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.all(
                                Resizable.padding(context, 20)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InputItem(
                                    title: AppText.txtName.text,
                                    controller: nameCon,
                                    errorText:
                                    AppText.txtPleaseInputName.text,
                                    autoFocus: false,
                                    onChange: (value) {
                                      cubit.name = value;
                                      updateCubit.update(cubit, student);
                                    }),
                                InputItem(
                                    title: AppText.txtStudentCode.text,
                                    controller: stdCodeCon,
                                    errorText: AppText
                                        .txtPleaseInputStudentCode.text,
                                    autoFocus: false,
                                    onChange: (value) {
                                      cubit.studentCode = value;
                                      updateCubit.update(cubit, student);
                                    }),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Opacity(
                                            opacity: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    cubit.isInJapan();
                                                    updateCubit.update(cubit, student);
                                                  },
                                                  child: cubit.active == true
                                                      ? const Icon(
                                                    Icons.check_box,
                                                    color: primaryColor,
                                                  )
                                                      : const Icon(Icons
                                                      .check_box_outline_blank),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Resizable.padding(
                                                          context, 5),
                                                      right:
                                                      Resizable.padding(
                                                          context, 10)),
                                                  child: Text(
                                                      AppText
                                                          .txtStudentInJapan
                                                          .text,
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xff757575),
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize:
                                                          Resizable.font(
                                                              context,
                                                              18))),
                                                )
                                              ],
                                            )),
                                        Text(AppText.txtPhone.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: Resizable.font(
                                                    context, 18),
                                                color:
                                                const Color(0xff757575))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                cubit.isInJapan();
                                                updateCubit.update(cubit, student);
                                              },
                                              child: cubit.active == true
                                                  ? const Icon(
                                                Icons.check_box,
                                                color: primaryColor,
                                              )
                                                  : const Icon(Icons
                                                  .check_box_outline_blank),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Resizable.padding(
                                                      context, 5),
                                                  right: Resizable.padding(
                                                      context, 10)),
                                              child: Text(
                                                  AppText
                                                      .txtStudentInJapan.text,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff757575),
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize:
                                                      Resizable.font(
                                                          context, 18))),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                            child: InputField(
                                                controller: phoneCon,
                                                autoFocus: false,
                                                onChange: (value) {
                                                  cubit.phone = value;
                                                  updateCubit.update(cubit, student);
                                                }))
                                      ],
                                    )
                                  ],
                                ),
                                InputItem(
                                    title: AppText.textEmail.text,
                                    controller: emailCon,
                                    errorText:
                                    AppText.txtPleaseInputEmail.text,
                                    autoFocus: true,
                                    enabled: false,
                                    onChange: (value) {}),
                                InputItem(
                                    title: AppText.txtNote.text,
                                    controller: noteCon,
                                    isExpand: true,
                                    autoFocus: false,
                                    onChange: (value) {
                                      cubit.note = value;
                                      updateCubit.update(cubit, student);

                                    }),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Resizable.padding(context, 10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                            Resizable.size(context, 100)),
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
                                            minWidth:
                                            Resizable.size(context, 100)),
                                        child: SubmitButton(
                                            isActive: state,
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection('students')
                                                  .doc('student_user_${student.userId}')
                                                  .update({
                                                'in_jp':cubit.active,
                                                'name': cubit.name,
                                                'note': cubit.note,
                                                'phone': cubit.phone,
                                                'student_code': cubit.studentCode
                                              }).whenComplete(() {
                                                Navigator.pop(context);
                                                BlocProvider.of<LoadListStudentCubit>(context).update(context);
                                              });
                                            },
                                            title: AppText.btnUpdate.text),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ),);
            },
          ),
        );
      });
}
