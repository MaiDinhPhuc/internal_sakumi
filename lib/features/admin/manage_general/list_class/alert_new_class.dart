import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_new_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

void alertNewClass(BuildContext context) {
  TextEditingController desCon = TextEditingController();
  TextEditingController noteCon = TextEditingController();
  TextEditingController codeCon = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertNewClassCubit()..loadCourse(context),
            child: BlocBuilder<AlertNewClassCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertNewClassCubit>(c);
                return Dialog(
                    backgroundColor: Colors.white,
                    insetPadding:
                        EdgeInsets.all(Resizable.padding(context, 10)),
                    child: Form(
                        key: formKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding:
                              EdgeInsets.all(Resizable.padding(context, 20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    bottom: Resizable.padding(context, 20)),
                                child: Text(
                                  AppText.btnAddNewClass.text.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 5)),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(AppText.txtCourse.text,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Resizable.font(
                                                                context, 18),
                                                        color: const Color(
                                                            0xff757575))),
                                                InputDropdown(
                                                    title:
                                                        AppText.txtCourse.text,
                                                    hint: AppText
                                                        .textChooseCourse.text,
                                                    errorText: AppText
                                                        .txtPleaseChooseCourse
                                                        .text,
                                                    onChanged: (v) {
                                                      cubit.courseId =
                                                          cubit.choose(v, c);
                                                    },
                                                    items: cubit.listCourse ==
                                                            null
                                                        ? []
                                                        : List.generate(
                                                                cubit.listCourse!
                                                                    .length,
                                                                (index) =>
                                                                    ('${cubit.listCourse![index].title} ${cubit.listCourse![index].termName}'))
                                                            .toList())
                                              ],
                                            )),
                                        SizedBox(
                                            width: Resizable.size(context, 20)),
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(AppText.txtClassCode.text,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Resizable.font(
                                                                context, 18),
                                                        color: const Color(
                                                            0xff757575))),
                                                InputField(
                                                    controller: codeCon,
                                                    errorText: AppText
                                                        .txtPleaseInputClassCode
                                                        .text)
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                              InputItem(
                                  title: AppText.txtDescription.text,
                                  controller: noteCon,
                                  isExpand: true),
                              Row(
                                children: [
                                  Expanded(
                                      child: InputDate(
                                          title: AppText.txtStartDate.text,
                                          errorText:
                                              AppText.txtErrorStartDate.text)),
                                  SizedBox(width: Resizable.size(context, 20)),
                                  Expanded(
                                      child: InputDate(
                                          title: AppText.txtEndDate.text,
                                          isStartDate: false,
                                          errorText:
                                              AppText.txtErrorEndDate.text))
                                ],
                              ),
                              InputItem(
                                  controller: desCon,
                                  title: AppText.txtNote.text,
                                  isExpand: true),
                              Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.padding(context, 20)),
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
                                              await cubit.addNewClass(
                                                  c,
                                                  ClassModel(
                                                      classId: cubit
                                                          .listClass!.length,
                                                      courseId: cubit.courseId!,
                                                      description: desCon.text,
                                                      endTime: DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(DateTimeCubit
                                                              .endDay),
                                                      startTime: DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(DateTimeCubit
                                                              .startDay),
                                                      note: noteCon.text,
                                                      classCode: codeCon.text,classStatus: 'Preparing'));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (cubit.check == true) {
                                                  await BlocProvider.of<
                                                              ManageGeneralCubit>(
                                                          context)
                                                      .loadAfterAddClass(cubit
                                                      .listClass!.length,context);
                                                } else {
                                                  notificationDialog(
                                                      context,
                                                      AppText
                                                          .txtPleaseCheckListClass
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
                        )));
              },
            ));
      });
}
