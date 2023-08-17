import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_teacher/alert_add_teacher_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

void alertCheckBoxTeacher(
    BuildContext context, ManageGeneralCubit manageGeneralCubit) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAddTeacherCubit()
              ..loadAllUser(context, manageGeneralCubit),
            child: BlocBuilder<AlertAddTeacherCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertAddTeacherCubit>(c);
                return cubit.listSensei == null
                    ? const WaitingAlert()
                    : cubit.listSensei!.isEmpty
                        ? NotifyAlert(AppText.txtNoTeacher.text)
                        : Dialog(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Resizable.padding(context, 20),
                                            vertical:
                                                Resizable.padding(context, 10)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: Resizable.padding(
                                                      context, 2),
                                                  offset: Offset(
                                                      0,
                                                      Resizable.size(
                                                          context, 1)))
                                            ]),
                                        child: Text(
                                          AppText.btnAddTeacher.text
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Resizable.font(context, 20)),
                                        ),
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 0)),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                  cubit.listSensei!.length,
                                                  (index) => BlocProvider(
                                                      create: (c) =>
                                                          CheckBoxCubit(),
                                                      child: BlocBuilder<
                                                          CheckBoxCubit, bool>(
                                                        builder: (cc, state) =>
                                                            CheckboxListTile(
                                                                contentPadding: EdgeInsets.symmetric(
                                                                    horizontal: Resizable
                                                                        .padding(
                                                                            context,
                                                                            30)),
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                                value: state,
                                                                onChanged: (v) {
                                                                  BlocProvider.of<
                                                                          CheckBoxCubit>(cc)
                                                                      .update();
                                                                  cubit
                                                                      .listSelectedTeacher!
                                                                      .add(cubit
                                                                              .listSensei![
                                                                          index]);
                                                                },
                                                                title: Text(
                                                                    "${cubit.listSensei![index].name} ${cubit.listSensei![index].teacherCode}")),
                                                      ))).toList(),
                                              SizedBox(
                                                  height: Resizable.size(
                                                      context, 50))
                                            ],
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 20),
                                        vertical:
                                            Resizable.padding(context, 10)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius:
                                                  Resizable.padding(context, 2),
                                              offset: Offset(0,
                                                  Resizable.size(context, -1)))
                                        ]),
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
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                waitingDialog(context);
                                                for (var i in cubit
                                                    .listSelectedTeacher!) {
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
                                                          userId: cubit
                                                              .listSelectedTeacher![
                                                                  cubit
                                                                      .listSelectedTeacher!
                                                                      .indexOf(
                                                                          i)]
                                                              .userId,
                                                          classStatus:
                                                          AppText.statusInProgress.text,
                                                          date: DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .now())));
                                                }
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  manageGeneralCubit
                                                      .loadTeacherInClass(
                                                      context,
                                                      manageGeneralCubit
                                                          .selector);
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
                          );
              },
            ));
      });
}
