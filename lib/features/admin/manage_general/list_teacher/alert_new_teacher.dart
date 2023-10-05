import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_teacher/alert_add_teacher_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';


void alertNewTeacher(
    BuildContext context, ManageGeneralCubit manageGeneralCubit) {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController senseiCodeCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  final TextEditingController noteCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAddTeacherCubit()
              ..loadAllUser(context, manageGeneralCubit),
            child: BlocBuilder<AlertAddTeacherCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertAddTeacherCubit>(c);
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
                                  AppText.btnAddNewTeacher.text.toUpperCase(),
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
                                  title: AppText.txtTeacherCode.text,
                                  controller: senseiCodeCon,
                                  errorText:
                                  AppText.txtPleaseInputTeacherCode.text),
                              InputItem(title: AppText.txtPhone.text, controller: phoneCon),
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
                                            if (formKey.currentState!
                                                .validate()) {
                                              await cubit.createTeacher(
                                                  context,
                                                  TeacherModel(
                                                      name: nameCon.text,
                                                      url: '',
                                                      note: noteCon.text,
                                                      userId:
                                                      cubit.userCount!,
                                                      phone: phoneCon.text,
                                                      teacherCode:
                                                      senseiCodeCon.text,
                                                      status: AppText.statusInProgress.text),
                                                  UserModel(
                                                      email: emailCon.text,
                                                      role: AppText
                                                          .selectorTeacher.text,
                                                      id:cubit.userCount!));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (cubit.checkCreate == true) {
                                                  await cubit.addTeacherToClass(
                                                      context,
                                                      TeacherClassModel(
                                                          id: cubit
                                                              .listTeacherClass!
                                                              .length +
                                                              1,
                                                          classId:
                                                          manageGeneralCubit
                                                              .selector,
                                                          userId: cubit.userCount!,
                                                          classStatus:
                                                          AppText.statusInProgress.text,
                                                          date: DateFormat(
                                                              'dd/MM/yyyy')
                                                              .format(DateTime
                                                              .now())));
                                                  if (context.mounted) {
                                                    manageGeneralCubit
                                                        .loadTeacherInClass(
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
