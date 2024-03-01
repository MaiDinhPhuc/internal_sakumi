import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_add_student_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

void alertNewStudent(
    BuildContext context, ManageGeneralCubit manageGeneralCubit) {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController stdCodeCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  final TextEditingController noteCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAddStudentCubit()
              ..loadAllUser(manageGeneralCubit),
            child: BlocBuilder<AlertAddStudentCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertAddStudentCubit>(c);
                return Dialog(
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding:
                              EdgeInsets.all(Resizable.padding(context, 20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    bottom: Resizable.padding(context, 10)),
                                child: Text(
                                  AppText.btnManageStudent.text.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)),
                                ),
                              ),
                              InputItem(
                                  title: AppText.txtName.text,
                                  controller: nameCon,
                                  errorText: AppText.txtPleaseInputName.text),
                              InputItem(
                                  title: AppText.txtStudentCode.text,
                                  controller: stdCodeCon,
                                  errorText:
                                      AppText.txtPleaseInputStudentCode.text),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Opacity(
                                          opacity: 0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () => cubit.isInJapan(),
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
                                          )),
                                      Text(AppText.txtPhone.text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  Resizable.font(context, 18),
                                              color: const Color(0xff757575))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () => cubit.isInJapan(),
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
                                                AppText.txtStudentInJapan.text,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff757575),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: Resizable.font(
                                                        context, 18))),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                          child:
                                              InputField(controller: phoneCon))
                                    ],
                                  )
                                ],
                              ),
                              InputItem(
                                  title: AppText.textEmail.text,
                                  controller: emailCon,
                                  errorText: AppText.txtPleaseInputEmail.text),
                              InputItem(
                                  title: AppText.txtNote.text,
                                  controller: noteCon,
                                  isExpand: true),
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
                                          right:
                                              Resizable.padding(context, 20)),
                                      child: DialogButton(
                                          AppText.textCancel.text.toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      child: SubmitButton(
                                          onPressed: () async {
                                            int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
                                            if (formKey.currentState!
                                                .validate()) {
                                              await cubit.createStudent(
                                                  context,
                                                  StudentModel(
                                                      name: nameCon.text,
                                                      url: '',
                                                      note: noteCon.text,
                                                      userId:
                                                      millisecondsSinceEpoch,
                                                      inJapan: cubit.active,
                                                      phone: phoneCon.text,
                                                      studentCode:
                                                          stdCodeCon.text,
                                                      status: AppText.statusInProgress.text),
                                                  UserModel(
                                                      email: emailCon.text,
                                                      role: AppText
                                                          .selectorStudent.text,
                                                      id: millisecondsSinceEpoch));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (cubit.checkCreate == true) {
                                                  debugPrint(
                                                      '===========> listStudentClass ${cubit.studentClassCount! + 1}');

                                                  await cubit.addStudentToClass(
                                                      context,
                                                      StudentClassModel(
                                                          id: cubit
                                                                  .studentClassCount!,
                                                          classId:
                                                              manageGeneralCubit
                                                                  .selector,
                                                          activeStatus: 1,
                                                          learningStatus: 1,
                                                          moveTo: 0,
                                                          userId: millisecondsSinceEpoch,
                                                          classStatus:
                                                              AppText.statusInProgress.text,
                                                          date: DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .now()), timeChange: 0));
                                                  if (context.mounted) {
                                                    manageGeneralCubit
                                                        .loadStudentInClass(
                                                            manageGeneralCubit
                                                                .selector);
                                                  }
                                                } else {
                                                  notificationDialog(
                                                      context,
                                                      AppText
                                                          .txtPleaseCheckListUser
                                                          .text);
                                                }
                                              }
                                            } else {
                                              print('Form is invalid');
                                            }
                                          },
                                          title: AppText.btnAdd.text),
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
            ));
      });
}
