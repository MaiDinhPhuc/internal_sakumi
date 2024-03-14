import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_add_student_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_teacher/alert_add_teacher_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

void alertAddNewTeacherAccount(
    BuildContext context) {
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
            create: (context) => AlertAddTeacherCubit(),
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
                                              int teacherId = DateTime.now().millisecondsSinceEpoch;
                                              await cubit.createTeacher(
                                                  context,
                                                  TeacherModel(
                                                      name: nameCon.text,
                                                      url: '',
                                                      note: noteCon.text,
                                                      userId: teacherId,
                                                      phone: phoneCon.text,
                                                      teacherCode:
                                                      senseiCodeCon.text,
                                                      status: AppText.statusInProgress.text),
                                                  UserModel(
                                                      email: emailCon.text,
                                                      role: AppText
                                                          .selectorTeacher.text,
                                                      id:teacherId));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (cubit.checkCreate == false){
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