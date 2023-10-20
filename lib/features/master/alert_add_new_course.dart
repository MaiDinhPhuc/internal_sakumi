import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'manage_course_cubit.dart';

void alertAddNewCourse(BuildContext context, CourseModel? courseModel,
    bool isEdit, ManageCourseCubit cubit) {
  TextEditingController desCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.description);
  TextEditingController titleCon =
      TextEditingController(text: courseModel == null ? "" : courseModel.title);
  TextEditingController codeCon =
      TextEditingController(text: courseModel == null ? "" : courseModel.code);
  TextEditingController idCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.courseId.toString());
  TextEditingController countCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.lessonCount.toString());
  TextEditingController levelCon =
      TextEditingController(text: courseModel == null ? "" : courseModel.level);
  TextEditingController termIdCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.termId.toString());
  TextEditingController termNameCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.termName);
  TextEditingController tokenCon =
      TextEditingController(text: courseModel == null ? "" : courseModel.token);
  TextEditingController typeCon =
      TextEditingController(text: courseModel == null ? "" : courseModel.type);
  TextEditingController verCon =
  TextEditingController(text: courseModel == null ? "1" : courseModel.version.toString());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: Form(
                key: formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: isEdit
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    bottom: Resizable.padding(context, 20)),
                                child: Text(
                                  isEdit
                                      ? AppText.txtEditCourseInfo.text
                                          .toUpperCase()
                                      : AppText.btnAddNewCourse.text
                                          .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)),
                                ),
                              ),
                              if (isEdit)
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Resizable.padding(context, 20)),
                                    child: BlocProvider(
                                      create: (context) =>
                                          SwitcherCubit(courseModel!.enable),
                                      child: BlocBuilder<SwitcherCubit, bool>(
                                        builder: (c, s) {
                                          return Row(
                                            children: [
                                              Text(AppText.titleStatus.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              Switch(
                                                  value: s,
                                                  activeColor: primaryColor,
                                                  onChanged:
                                                      (bool value) async {
                                                    BlocProvider.of<
                                                            SwitcherCubit>(c)
                                                        .update();
                                                    await FireBaseProvider
                                                        .instance
                                                        .updateCourseState(
                                                            courseModel!,
                                                            value);
                                                    cubit.loadAfterChangeStatus(
                                                        courseModel, value);
                                                  })
                                            ],
                                          );
                                        },
                                      ),
                                    ))
                            ],
                          )),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                              child: Column(children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 5)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(AppText.txtTermName.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: termNameCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
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
                                              Text(AppText.txtTermId.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: termIdCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
                                            ],
                                          ))
                                    ],
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 5)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(AppText.txtCourseId.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: idCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
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
                                              Text(AppText.txtCode.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: codeCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
                                            ],
                                          ))
                                    ],
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 5)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(AppText.txtLessonCount.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: countCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
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
                                              Text(AppText.txtLevel.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: levelCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
                                            ],
                                          ))
                                    ],
                                  ),
                                )),
                            InputItem(
                                controller: titleCon,
                                title: AppText.txtTitle.text,
                                isExpand: true),
                            InputItem(
                                controller: desCon,
                                title: AppText.txtDescription.text,
                                isExpand: true),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 5)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(AppText.txtToken.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: tokenCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
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
                                              Text(AppText.txtCourseType.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: const Color(
                                                          0xff757575))),
                                              InputField(
                                                  controller: typeCon,
                                                  errorText: AppText
                                                      .txtPleaseInput.text)
                                            ],
                                          ))
                                    ],
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppText.txtDataVersion.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                                InputField(
                                    controller: verCon,
                                    errorText: AppText.txtPleaseInput.text)
                              ],
                            )
                          ]))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: Resizable.size(context, 100)),
                                    margin: EdgeInsets.only(
                                        right: Resizable.padding(context, 20)),
                                    child: DialogButton(
                                        AppText.textCancel.text.toUpperCase(),
                                        onPressed: () =>
                                            Navigator.pop(context)),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: Resizable.size(context, 100)),
                                    child: SubmitButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (!isEdit) {
                                              final bool check =
                                                  await FireBaseProvider
                                                      .instance
                                                      .addNewCourse(CourseModel(
                                                          courseId: int.parse(
                                                              idCon.text),
                                                          description:
                                                              desCon.text,
                                                          lessonCount: int.parse(
                                                              countCon.text),
                                                          level: levelCon.text,
                                                          termId: int.parse(
                                                              termIdCon.text),
                                                          termName:
                                                              termNameCon.text,
                                                          title: titleCon.text,
                                                          type: typeCon.text,
                                                          token: tokenCon.text,
                                                          code: codeCon.text,
                                                          enable: true, version: int.parse(verCon.text)));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                if (check == true) {
                                                  cubit.loadAfterAdd(
                                                      CourseModel(
                                                          courseId: int.parse(
                                                              idCon.text),
                                                          description:
                                                              desCon.text,
                                                          lessonCount:
                                                              int.parse(countCon
                                                                  .text),
                                                          level: levelCon.text,
                                                          termId: int.parse(
                                                              termIdCon.text),
                                                          termName:
                                                              termNameCon.text,
                                                          title: titleCon.text,
                                                          type: typeCon.text,
                                                          token: tokenCon.text,
                                                          code: codeCon.text,
                                                          enable: true, version: int.parse(verCon.text)));
                                                } else {
                                                  notificationDialog(
                                                      context,
                                                      AppText
                                                          .txtPleaseCheckListCourse
                                                          .text);
                                                }
                                              }
                                            } else {
                                              await FireBaseProvider.instance
                                                  .updateCourseInfo(CourseModel(
                                                      courseId:
                                                          int.parse(idCon.text),
                                                      description: desCon.text,
                                                      lessonCount: int.parse(
                                                          countCon.text),
                                                      level: levelCon.text,
                                                      termId: int.parse(
                                                          termIdCon.text),
                                                      termName:
                                                          termNameCon.text,
                                                      title: titleCon.text,
                                                      type: typeCon.text,
                                                      token: tokenCon.text,
                                                      code: codeCon.text,
                                                      enable: true, version: int.parse(verCon.text)));

                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                cubit.loadAfterEdit(
                                                    CourseModel(
                                                        courseId: int.parse(
                                                            idCon.text),
                                                        description:
                                                            desCon.text,
                                                        lessonCount: int.parse(
                                                            countCon.text),
                                                        level: levelCon.text,
                                                        termId: int.parse(
                                                            termIdCon.text),
                                                        termName:
                                                            termNameCon.text,
                                                        title: titleCon.text,
                                                        type: typeCon.text,
                                                        token: tokenCon.text,
                                                        code: codeCon.text,
                                                        enable: true, version: int.parse(verCon.text)),
                                                    courseModel!.courseId);
                                              }
                                            }
                                          } else {
                                            print('Form is invalid');
                                          }
                                        },
                                        title: isEdit
                                            ? AppText.btnUpdate.text
                                            : AppText.btnAdd.text),
                                  ),
                                ],
                              )))
                    ],
                  ),
                )));
      });
}

class SwitcherCubit extends Cubit<bool> {
  SwitcherCubit(bool value) : super(value);

  update() {
    emit(!state);
  }
}
