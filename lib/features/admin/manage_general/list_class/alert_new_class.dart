import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_new_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_confirm_delete_class.dart';
import 'info_class_view.dart';

void alertNewClass(BuildContext context, bool isEdit, ClassModel? classModel,
    ManageGeneralCubit? manageGeneralCubit) {
  TextEditingController desCon = TextEditingController(
      text: classModel == null ? "" : classModel.description);
  TextEditingController noteCon =
      TextEditingController(text: classModel == null ? "" : classModel.note);
  TextEditingController codeCon = TextEditingController(
      text: classModel == null ? "" : classModel.classCode);
  TextEditingController linkCon =
      TextEditingController(text: classModel == null ? "" : classModel.link);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) {
        if (classModel != null) {
          DateTimeCubit.startDay = DateTime.fromMillisecondsSinceEpoch(classModel.startTime);
          DateTimeCubit.endDay =DateTime.fromMillisecondsSinceEpoch(classModel.endTime);
        } else {
          DateTimeCubit.startDay = DateTime.now();
          DateTimeCubit.endDay = DateTime.now();
        }
        return BlocProvider(
            create: (context) =>
                AlertNewClassCubit()..loadCourse(classModel, isEdit),
            child: BlocBuilder<AlertNewClassCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertNewClassCubit>(c);
                return cubit.listCourse == null
                    ? const WaitingAlert()
                    : Dialog(
                        backgroundColor: Colors.white,
                        insetPadding:
                            EdgeInsets.all(Resizable.padding(context, 10)),
                        child: Form(
                            key: formKey,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.all(
                                  Resizable.padding(context, 20)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Resizable.padding(context, 20)),
                                        child: Text(
                                          isEdit
                                              ? AppText.txtEditClassInfo.text
                                                  .toUpperCase()
                                              : AppText.btnAddNewClass.text
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Resizable.font(context, 20)),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 10,
                                      child: InfoClassView(
                                        isEdit: isEdit,
                                        cubit: cubit,
                                        desCon: desCon,
                                        noteCon: noteCon,
                                        codeCon: codeCon,
                                        linkCon: linkCon,
                                        classModel: classModel,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top:
                                                Resizable.padding(context, 20)),
                                        child: Row(
                                          mainAxisAlignment: isEdit
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.end,
                                          children: [
                                            if (isEdit)
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: Resizable.size(
                                                        context, 100)),
                                                child: DeleteButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return ConfirmDeleteClass(
                                                                classModel!,
                                                                () async {
                                                              await FireBaseProvider
                                                                  .instance
                                                                  .changeClassStatus(
                                                                      classModel,
                                                                      "Remove",
                                                                      manageGeneralCubit!,
                                                                      context);
                                                            });
                                                          });
                                                    },
                                                    title: AppText
                                                        .btnRemoveClass.text),
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      minWidth: Resizable.size(
                                                          context, 100)),
                                                  margin: EdgeInsets.only(
                                                      right: Resizable.padding(
                                                          context, 20)),
                                                  child: DialogButton(
                                                      AppText.textCancel.text
                                                          .toUpperCase(),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context)),
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                      minWidth: Resizable.size(
                                                          context, 100)),
                                                  child: SubmitButton(
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          if (!isEdit) {
                                                            await cubit.addNewClass(
                                                                c,
                                                                ClassModel(
                                                                    classId: cubit
                                                                        .classCount!,
                                                                    courseId: cubit
                                                                        .courseId!,
                                                                    description:
                                                                        desCon
                                                                            .text,
                                                                    endTime: DateTimeCubit
                                                                        .endDay
                                                                        .millisecondsSinceEpoch,
                                                                    startTime: DateTimeCubit
                                                                        .startDay
                                                                        .millisecondsSinceEpoch,
                                                                    note: noteCon
                                                                        .text,
                                                                    classCode: codeCon
                                                                        .text,
                                                                    classStatus:
                                                                        'Preparing',
                                                                    classType: cubit
                                                                        .classType!,
                                                                    link: linkCon
                                                                        .text,
                                                                    customLessons: [],
                                                                    informal: cubit
                                                                        .informal));
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                              if (cubit.check ==
                                                                  true) {
                                                                await BlocProvider.of<
                                                                            ManageGeneralCubit>(
                                                                        context)
                                                                    .loadAfterAddClass(
                                                                        cubit
                                                                            .classCount!);
                                                              } else {
                                                                notificationDialog(
                                                                    context,
                                                                    AppText
                                                                        .txtPleaseCheckListClass
                                                                        .text);
                                                              }
                                                            }
                                                          } else {
                                                            cubit.classStatus ??=
                                                                classModel!
                                                                    .classStatus;
                                                            cubit.classType ??=
                                                                classModel!
                                                                    .classType;

                                                            await cubit.updateClass(
                                                                c,
                                                                ClassModel(
                                                                    classId: classModel!
                                                                        .classId,
                                                                    courseId: classModel
                                                                        .courseId,
                                                                    description:
                                                                        desCon
                                                                            .text,
                                                                    endTime: DateTimeCubit
                                                                        .endDay
                                                                        .millisecondsSinceEpoch,
                                                                    startTime: DateTimeCubit
                                                                        .startDay
                                                                        .millisecondsSinceEpoch,
                                                                    note: noteCon
                                                                        .text,
                                                                    classCode:
                                                                        codeCon
                                                                            .text,
                                                                    classStatus:
                                                                        cubit
                                                                            .classStatus!,
                                                                    classType: cubit
                                                                        .classType!,
                                                                    link: linkCon
                                                                        .text,
                                                                    customLessons: [],
                                                                    informal: cubit
                                                                        .informal));
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                              await BlocProvider
                                                                      .of<ManageGeneralCubit>(
                                                                          context)
                                                                  .loadAfterChangeClassStatus();
                                                            }
                                                          }
                                                        } else {
                                                          debugPrint(
                                                              'Form is invalid');
                                                        }
                                                      },
                                                      title: isEdit
                                                          ? AppText
                                                              .btnUpdate.text
                                                          : AppText
                                                              .btnAdd.text),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            )));
              },
            ));
      });
}
