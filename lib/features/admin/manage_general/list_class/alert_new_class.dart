import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/alert_new_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

import 'alert_confirm_delete_class.dart';

void alertNewClass(BuildContext context, bool isEdit, ClassModel? classModel, ManageGeneralCubit? manageGeneralCubit ) {
  TextEditingController desCon = TextEditingController(text: classModel == null ? "" : classModel.description);
  TextEditingController noteCon = TextEditingController(text: classModel == null ? "" : classModel.note);
  TextEditingController codeCon = TextEditingController(text: classModel == null ? "" : classModel.classCode);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) {
        if(classModel!=null){
          DateTimeCubit.startDay = DateFormat('dd/MM/yyyy').parse(classModel.startTime);
          DateTimeCubit.endDay = DateFormat('dd/MM/yyyy').parse(classModel.endTime);
        }else{
          DateTimeCubit.startDay = DateTime.now();
          DateTimeCubit.endDay = DateTime.now();
        }
        return BlocProvider(
            create: (context) => AlertNewClassCubit()..loadCourse(),
            child: BlocBuilder<AlertNewClassCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertNewClassCubit>(c);
                return cubit.listCourse == null ? const WaitingAlert() :Dialog(
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
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    bottom: Resizable.padding(context, 20)),
                                child: Text(
                                  isEdit ? AppText.txtEditClassInfo.text.toUpperCase() :AppText.btnAddNewClass.text.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)),
                                ),
                              )),
                              Expanded(
                                  flex: 10,
                                  child: SingleChildScrollView(child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Resizable.padding(context, 5)),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          if(!isEdit)
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
                                                      hint: cubit.findCourse(classModel == null ? -1 : classModel.courseId),
                                                      errorText: AppText
                                                          .txtPleaseChooseCourse
                                                          .text,
                                                      onChanged: (v) {
                                                        cubit.courseId =
                                                            cubit.chooseCourse(v);
                                                      },
                                                      items: List.generate(
                                                          cubit.listCourse!
                                                              .length,
                                                              (index) =>
                                                          ('${cubit.listCourse![index].title} ${cubit.listCourse![index].termName}'))
                                                          .toList())
                                                ],
                                              )),
                                          if(isEdit)
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    style: TextStyle(
                                                        fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
                                                    initialValue: cubit.findCourse(classModel == null ? -1 : classModel.courseId),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      fillColor: Colors.white,
                                                      hoverColor: Colors.transparent,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: const Color(0xffE0E0E0),
                                                            width: Resizable.size(context, 0.5)),
                                                        borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
                                                      ),
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(Resizable.padding(context, 5)),
                                                          borderSide: BorderSide(
                                                              color: const Color(0xffE0E0E0),
                                                              width: Resizable.size(context, 0.5))),
                                                    ),
                                                  ),
                                                )],
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
                                if(isEdit == false)
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(AppText.txtClassType.text,
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
                                          AppText.txtClassType.text,
                                          hint: AppText.txtChooseClassType.text,
                                          errorText: AppText
                                              .txtPleaseChooseType
                                              .text,
                                          onChanged: (v) {
                                            cubit.classType =
                                                cubit.chooseType(v);
                                          },
                                          items: List.generate(
                                              cubit.listClassType
                                                  .length,
                                                  (index) =>
                                              (cubit.listClassType[index]))
                                              .toList())
                                    ],
                                  ),
                                if(isEdit)
                                  Row(children: [
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(AppText.txtClassType.text,
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
                                                AppText.txtClassType.text,
                                                hint: cubit.findClassType(classModel!.classType),
                                                onChanged: (v) {
                                                  cubit.classType =
                                                      cubit.chooseType(v);
                                                },
                                                items: List.generate(
                                                    cubit.listClassType
                                                        .length,
                                                        (index) =>
                                                    (cubit.listClassType[index]))
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
                                            Text(AppText.titleStatus.text,
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
                                                AppText.titleStatus.text,
                                                hint: cubit.findStatus(classModel.classStatus),
                                                onChanged: (v) {
                                                  cubit.classStatus =
                                                      cubit.chooseStatus(v);
                                                },
                                                items: List.generate(
                                                    cubit.listClassStatusMenu
                                                        .length,
                                                        (index) =>
                                                    (vietnameseSubText(cubit.listClassStatusMenu[index])))
                                                    .toList())
                                          ],
                                        )),
                                  ]),
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
                                    isExpand: true)
                              ]))),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.padding(context, 20)),
                                child: Row(
                                  mainAxisAlignment: isEdit ? MainAxisAlignment.spaceBetween :  MainAxisAlignment.end,
                                  children: [
                                    if(isEdit)
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth:
                                            Resizable.size(context, 100)),
                                        child: DeleteButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(context: context, builder: (_){
                                                return ConfirmDeleteClass(classModel!,()async{
                                                  await FireBaseProvider.instance.changeClassStatus(classModel,"Remove", manageGeneralCubit! , context);
                                                });
                                              });
                                            },
                                            title: AppText.btnRemoveClass.text),
                                      ),
                                    Row(
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
                                                  if(!isEdit){
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
                                                            classCode: codeCon.text,classStatus: 'Preparing',classType: cubit.classType!));
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
                                                  }else{

                                                    cubit.classStatus ??= classModel!.classStatus;
                                                    cubit.classType ??= classModel!.classType;

                                                    await cubit.updateClass(
                                                        c,
                                                        ClassModel(
                                                            classId: classModel!.classId,
                                                            courseId: classModel.courseId,
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
                                                            classCode: codeCon.text,classStatus: cubit.classStatus!,classType: cubit.classType!));
                                                    if(context.mounted){
                                                      Navigator.pop(context);
                                                      await BlocProvider.of<
                                                          ManageGeneralCubit>(
                                                          context)
                                                          .loadAfterChangeClassStatus();
                                                    }
                                                  }
                                                } else {
                                                  print('Form is invalid');
                                                }
                                              },
                                              title: isEdit ? AppText.btnUpdate.text : AppText.btnAdd.text),
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
