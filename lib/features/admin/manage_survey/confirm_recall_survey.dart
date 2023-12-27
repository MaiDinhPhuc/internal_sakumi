import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import 'manage_survey_admin_cubit.dart';

class ConfirmRecallSurvey extends StatelessWidget {
  const ConfirmRecallSurvey(
      {super.key, required this.result, required this.cubit});
  final SurveyResultModel result;
  final ManageSurveyAdminCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmRecallSurvey.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      titlePadding:
      EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset(
        'assets/images/ic_delete.png',
        height: Resizable.size(context, 120),
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
              Navigator.pop(context);
              await FireBaseProvider.instance
                  .assignSurveyResult(SurveyResultModel(
                  status: "recall",
                  classId: result.classId,
                  surveyId: result.surveyId,
                  id: result.id,
                  title: result.title,
                  surveyCode: result.surveyCode,
                  dateAssign: 0))
                  .whenComplete(() {
                cubit.updateSurvey(
                  SurveyResultModel(
                      status: "recall",
                      classId: result.classId,
                      surveyId: result.surveyId,
                      id: result.id,
                      title: result.title,
                      surveyCode: result.surveyCode,
                      dateAssign: 0),
                );
              });
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}