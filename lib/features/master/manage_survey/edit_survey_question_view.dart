import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'another_setting_view.dart';
import 'detail_survey_cubit.dart';
import 'dropdown_type_survey.dart';
import 'edit_survey_cubit.dart';
import 'input_answer_view.dart';

class EditSurveyQuestionView extends StatelessWidget {
  EditSurveyQuestionView({super.key, required this.detailSurveyCubit})
      : editSurveyCubit = EditSurveyCubit(detailSurveyCubit);
  final DetailSurveyCubit detailSurveyCubit;
  final EditSurveyCubit editSurveyCubit;
  @override
  Widget build(BuildContext context) {
    return detailSurveyCubit.selector == -1
        ? Container()
        : BlocBuilder<EditSurveyCubit, int>(
        bloc: editSurveyCubit,
        builder: (c,s){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !detailSurveyCubit.surveyModel!.active
                    ? DropDownSurveyType(
                    items: [
                      AppText.txtSurveyType1.text,
                      AppText.txtSurveyType2.text,
                      AppText.txtSurveyType3.text,
                      AppText.txtSurveyType4.text
                    ],
                    onChanged: (value) {
                      if (!detailSurveyCubit.surveyModel!.active) {
                        editSurveyCubit.changeQuestionType(value!);
                      }
                    },
                    value: editSurveyCubit.convertType(detailSurveyCubit
                        .surveyModel!
                        .detail[detailSurveyCubit.index]["type"] ??
                        1))
                    : DropdownDisable(
                    value: editSurveyCubit.convertType(detailSurveyCubit
                        .surveyModel!
                        .detail[detailSurveyCubit.index]["type"] ??
                        1)),
                InputItem(
                  enabled: !detailSurveyCubit.surveyModel!.active,
                  autoFocus: false,
                  onChange: (String? value) {
                    editSurveyCubit.changeQuestion();
                  },
                  controller: editSurveyCubit.quesCon,
                  hintText: AppText.txtLetInputSurveyQuestion.text,
                  isExpand: true,
                  title: '',
                ),
                ...editSurveyCubit.answerCon
                    .map((e) => InputAnswerView(
                  editSurveyCubit: editSurveyCubit,
                  type: detailSurveyCubit.surveyModel!
                      .detail[detailSurveyCubit.index]["type"] ??
                      1,
                  isExpand: true,
                  autoFocus: false,
                  enabled: !detailSurveyCubit.surveyModel!.active,
                  controller: e,
                  onChange: (value) {
                    editSurveyCubit.changeAnswer();
                  },
                  hintText: AppText.txtLetInputSurveyAnswer.text,
                  index: editSurveyCubit.answerCon.indexOf(e),
                ))
                    .toList(),
                if (!detailSurveyCubit.surveyModel!.active &&
                    detailSurveyCubit.surveyModel!
                        .detail[detailSurveyCubit.index]["type"] <
                        3)
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10)),
                      child: DottedBorderButton(
                          AppText.btnAddNewSurveyAnswer.text.toUpperCase(),
                          isManageGeneral: true, onPressed: () {
                        editSurveyCubit.addNewAnswer();
                      })),
                AnotherSettingView(
                    detailSurveyCubit: detailSurveyCubit,
                    editSurveyCubit: editSurveyCubit)
              ],
            ),
          );
    });
  }
}
