import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_survey_cubit.dart';
import 'dropdown_type_survey.dart';
import 'input_answer_view.dart';

class EditSurveyQuestionView extends StatelessWidget {
  const EditSurveyQuestionView({super.key, required this.detailSurveyCubit});
  final DetailSurveyCubit detailSurveyCubit;
  @override
  Widget build(BuildContext context) {
    return detailSurveyCubit.selector == -1
        ? Container()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !detailSurveyCubit.surveyModel!.active
                    ? DropDownSurveyType(
                        items: [
                            AppText.txtSurveyType1.text,
                            AppText.txtSurveyType2.text,
                            AppText.txtSurveyType3.text
                          ],
                        onChanged: (value) {
                          if (!detailSurveyCubit.surveyModel!.active) {
                            detailSurveyCubit.changeQuestionType(value!);
                          }
                        },
                        value: detailSurveyCubit.convertType(detailSurveyCubit
                                .surveyModel!
                                .detail[detailSurveyCubit.index]["type"] ??
                            1))
                    : DropdownDisable(
                        value: detailSurveyCubit.convertType(detailSurveyCubit
                                .surveyModel!
                                .detail[detailSurveyCubit.index]["type"] ??
                            1)),
                InputItem(
                  enabled: !detailSurveyCubit.surveyModel!.active,
                  autoFocus: false,
                  onChange: (String? value) {
                    detailSurveyCubit.changeQuestion();
                  },
                  controller:
                      detailSurveyCubit.quesCon[detailSurveyCubit.index],
                  hintText: AppText.txtLetInputSurveyQuestion.text,
                  isExpand: true,
                  title: '',
                ),
                ...detailSurveyCubit.answerCon[detailSurveyCubit.index]
                    .map((e) => InputAnswerView(
                          detailSurveyCubit: detailSurveyCubit,
                          type: detailSurveyCubit.surveyModel!
                                  .detail[detailSurveyCubit.index]["type"] ??
                              1,
                          isExpand: true,
                          autoFocus: false,
                          enabled: !detailSurveyCubit.surveyModel!.active,
                          controller: e,
                          onChange: (value) {
                            detailSurveyCubit.changeAnswer();
                          },
                          hintText: AppText.txtLetInputSurveyAnswer.text,
                          index: detailSurveyCubit
                              .answerCon[detailSurveyCubit.index]
                              .indexOf(e),
                        ))
                    .toList(),
                if (!detailSurveyCubit.surveyModel!.active &&
                    detailSurveyCubit.surveyModel!
                            .detail[detailSurveyCubit.index]["type"] !=
                        3)
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10)),
                      child: DottedBorderButton(
                          AppText.btnAddNewSurveyAnswer.text.toUpperCase(),
                          isManageGeneral: true, onPressed: () {
                        detailSurveyCubit.addNewAnswer();
                      })),
                Text(AppText.txtAnotherSetting.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w600,
                        color: primaryColor)),
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    child: Row(
                      children: [
                        Container(
                          height: Resizable.size(context, 35),
                          width: Resizable.size(context, 120),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: const Color(0xffE0E0E0)),
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5)),
                          ),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(AppText.txtForce.text,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w600,
                                    color: greyColor.shade600)),
                            value: detailSurveyCubit.surveyModel!
                                .detail[detailSurveyCubit.index]["force"],
                            onChanged: (newValue) {
                              if (!detailSurveyCubit.surveyModel!.active) {
                                detailSurveyCubit.changeForce(newValue!);
                              }
                            },
                          ),
                        ),
                        if (detailSurveyCubit.surveyModel!
                                .detail[detailSurveyCubit.index]["type"] !=
                            3)
                          Container(
                            margin: EdgeInsets.only(
                                left: Resizable.padding(context, 15)),
                            height: Resizable.size(context, 35),
                            width: Resizable.size(context, 135),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: const Color(0xffE0E0E0)),
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 5)),
                            ),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(AppText.txtAnother.text,
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 18),
                                      fontWeight: FontWeight.w600,
                                      color: greyColor.shade600)),
                              value: detailSurveyCubit.surveyModel!
                                  .detail[detailSurveyCubit.index]["another"],
                              onChanged: (newValue) {
                                if (!detailSurveyCubit.surveyModel!.active) {
                                  detailSurveyCubit.changeAnother(newValue!);
                                }
                              },
                            ),
                          )
                      ],
                    ))
              ],
            ),
          );
  }
}
