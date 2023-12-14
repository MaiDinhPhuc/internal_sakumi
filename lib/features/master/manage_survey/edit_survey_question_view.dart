import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';

import 'detail_survey_cubit.dart';
import 'dropdown_type_survey.dart';

class EditSurveyQuestionView extends StatelessWidget {
  const EditSurveyQuestionView({super.key, required this.detailSurveyCubit});
  final DetailSurveyCubit detailSurveyCubit;
  @override
  Widget build(BuildContext context) {
    return detailSurveyCubit.selector == -1
        ? Container()
        : SingleChildScrollView(
            child: Column(
              children: [
                DropDownSurveyType(
                    items: [
                      AppText.txtSurveyType1.text,
                      AppText.txtSurveyType2.text,
                      AppText.txtSurveyType3.text
                    ],
                    onChanged: (value) {
                      detailSurveyCubit.changeQuestionType(value!);
                    },
                    value: detailSurveyCubit.convertType(
                        detailSurveyCubit.surveyModel!.detail.firstWhere((e) =>
                                e["id"] ==
                                detailSurveyCubit.selector)["type"] ??
                            1)),
                InputItem(
                  autoFocus: false,
                  onChange: (String? value) {
                    detailSurveyCubit.changeQuestion(value!);
                  },
                  controller: detailSurveyCubit.quesCon[detailSurveyCubit
                      .surveyModel!.detail
                      .indexOf(detailSurveyCubit.surveyModel!.detail.firstWhere(
                          (e) => e["id"] == detailSurveyCubit.selector))],
                  hintText: AppText.txtLetInputSurveyQuestion.text,
                  isExpand: true,
                  title: '',
                ),
              ],
            ),
          );
  }
}
