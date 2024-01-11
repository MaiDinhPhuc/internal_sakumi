import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import 'manage_survey_cubit.dart';

class ConfirmDeleteSurvey extends StatelessWidget {
  const ConfirmDeleteSurvey(
      {Key? key, required this.surveyModel, required this.cubit})
      : super(key: key);
  final SurveyModel surveyModel;
  final ManageSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmDeleteSurvey.text,
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
              await FireBaseProvider.instance.deleteSurvey(surveyModel.id).whenComplete(() {
                cubit.deleteSurvey(surveyModel.id);
                Navigator.pushNamed(context,
                    '${Routes.master}/manageSurvey');
              });
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}