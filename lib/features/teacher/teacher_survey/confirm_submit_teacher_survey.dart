import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'doing_teacher_survey_cubit.dart';

class ConfirmSubmitTeacherSurvey extends StatelessWidget {
  const ConfirmSubmitTeacherSurvey({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final DoingTeacherSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmSubmitTeacherSurvey.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      titlePadding:
          EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset(
        'assets/images/ic_check.png',
        height: Resizable.size(context, 120),
        color: primaryColor,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            onPress: () {
              Navigator.pop(context);
            },
            bgColor: Colors.white,
            foreColor: Colors.black,
            text: AppText.txtBack.text),
        CustomButton(
            onPress: () async {
              waitingDialog(context);
              await Create.submitTeacherSurvey(cubit.surveyAnswer!);
              await Update.updateTeacherSurvey(cubit.teacherSurveyModel!.copyWith(status: 'done'));
              if (context.mounted) {
                Dialog(
                    elevation: 0,
                    alignment: Alignment.center,
                    child: Container(
                      width: Resizable.size(context, 200),
                      padding: EdgeInsets.all(Resizable.padding(context, 20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 20)),
                              child: Text(AppText.txtSubmitSuccess.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 20)))),
                          Align(
                            alignment: Alignment.bottomRight,
                            child:
                                DialogButton(AppText.txtOK.text, onPressed: () {
                              Navigator.pop(context);
                            }),
                          )
                        ],
                      ),
                    ));
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, Routes.teacher);
              }
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}
