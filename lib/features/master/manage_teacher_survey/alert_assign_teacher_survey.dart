import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_course/add_new_lesson_button.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

import 'manage_assign_teacher_survey_cubit.dart';

void alertAssignTeacherSurvey(BuildContext context, ManageAssignTeacherSurveyCubit cubit) {
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
                  width: MediaQuery.of(context).size.width* 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                bottom: Resizable.padding(context, 20)),
                            child: Text(
                              AppText.txtAssignSurvey.text.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth:
                                        Resizable.size(context, 100), minHeight: Resizable.size(context, 20)),
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
                                      int millisecondsSinceEpoch =
                                          DateTime.now()
                                              .millisecondsSinceEpoch;
                                    } else {
                                      debugPrint('Form is invalid');
                                    }
                                  }, false)
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                )));
      });
}