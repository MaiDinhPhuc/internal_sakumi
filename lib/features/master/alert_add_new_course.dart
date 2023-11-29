import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'header_alert_course.dart';
import 'input_2_filed.dart';
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
  TextEditingController verCon = TextEditingController(
      text: courseModel == null ? "1" : courseModel.version.toString());
  TextEditingController prefixCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.prefix);
  TextEditingController suffixCon = TextEditingController(
      text: courseModel == null ? "" : courseModel.suffix);

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
                          child: HeaderAlertCourse(isEdit: isEdit, courseModel: courseModel, cubit: cubit)),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                              child: Column(children: [
                            Input2Field(
                                title1: AppText.txtTermName.text,
                                title2: AppText.txtTermId.text,
                                con1: termNameCon,
                                con2: termIdCon),
                            Input2Field(
                                title1: AppText.txtCourseId.text,
                                title2: AppText.txtCode.text,
                                con1: idCon,
                                con2: codeCon),
                            Input2Field(
                                title1: AppText.txtLessonCount.text,
                                title2: AppText.txtLevel.text,
                                con1: countCon,
                                con2: levelCon),
                            Input2Field(
                                title1: AppText.txtPrefix.text,
                                title2: AppText.txtSuffix.text,
                                con1: prefixCon,
                                con2: suffixCon),
                            InputItem(
                                controller: titleCon,
                                title: AppText.txtTitle.text,
                                isExpand: true),
                            InputItem(
                                controller: desCon,
                                title: AppText.txtDescription.text,
                                isExpand: true),
                            Input2Field(
                                title1: AppText.txtToken.text,
                                title2: AppText.txtCourseType.text,
                                con1: tokenCon,
                                con2: typeCon),
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
                                                          enable: true,
                                                          version: int.parse(
                                                              verCon.text),
                                                          prefix:
                                                              prefixCon.text,
                                                          suffix:
                                                              suffixCon.text));
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
                                                          enable: true,
                                                          version: int.parse(
                                                              verCon.text),
                                                          prefix:
                                                              prefixCon.text,
                                                          suffix:
                                                              suffixCon.text));
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
                                                      enable: true,
                                                      version: int.parse(
                                                          verCon.text),
                                                      prefix: prefixCon.text,
                                                      suffix: suffixCon.text));

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
                                                        enable:
                                                            courseModel!.enable,
                                                        version: int.parse(
                                                            verCon.text),
                                                        prefix: prefixCon.text,
                                                        suffix: suffixCon.text),
                                                    courseModel.courseId);
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
