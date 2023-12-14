import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'manage_survey_cubit.dart';

void alertAddNewSurvey(BuildContext context,
    ManageSurveyCubit cubit) {
  TextEditingController titleCon = TextEditingController();
  TextEditingController codeCon = TextEditingController();
  TextEditingController desCon = TextEditingController();

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
                  height: MediaQuery.of(context).size.height * 0.55,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20)),
                            child: Text(
                               AppText.txtAddNewSurvey.text.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          )),
                      Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                              child: Column(children: [
                                InputItem(
                                    onChange: (String? value) {
                                      debugPrint(value);
                                    },
                                    controller: codeCon,
                                    title: AppText.txtSurveyCode.text,
                                    isExpand: false),
                                InputItem(
                                    onChange: (String? value) {
                                      debugPrint(value);
                                    },
                                    controller: titleCon,
                                    title: AppText.txtSurveyTitle.text,
                                    isExpand: false),
                                InputItem(
                                    onChange: (String? value) {
                                      debugPrint(value);
                                    },
                                    controller: desCon,
                                    title: AppText.txtDescription.text,
                                    isExpand: true),
                              ]))),
                      Expanded(
                          flex: 2,
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment:  MainAxisAlignment.end,
                                children: [
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
                                            AppText.textCancel.text
                                                .toUpperCase(),
                                            onPressed: () =>
                                                Navigator.pop(context)),
                                      ),
                                      AddNewLessonButton(() async {
                                        if (formKey.currentState!.validate()) {
                                          final bool check = false;
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            if (check == true) {

                                            } else {
                                              notificationDialog(
                                                  context,
                                                  AppText
                                                      .txtPleaseCheckListSurvey
                                                      .text);
                                            }
                                          }
                                        } else {
                                          print('Form is invalid');
                                        }
                                      }, false)
                                    ],
                                  )
                                ],
                              )))
                    ],
                  ),
                )));
      });
}