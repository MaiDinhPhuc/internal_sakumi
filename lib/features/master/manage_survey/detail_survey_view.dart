import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/master/manage_survey/question_survey_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/title_widget.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'confirm_active_survey.dart';
import 'detail_survey_cubit.dart';
import 'edit_survey_question_view.dart';
import 'manage_survey_cubit.dart';

class DetailSurveyView extends StatelessWidget {
  const DetailSurveyView(
      {super.key, required this.cubit, required this.detailSurveyCubit});
  final ManageSurveyCubit cubit;
  final DetailSurveyCubit detailSurveyCubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(
              children: [
                TitleWidget(AppText.titleQuestion.text.toUpperCase()),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (detailSurveyCubit.surveyModel!.detail.isNotEmpty)
                        SizedBox(height: Resizable.padding(context, 10)),
                      ...detailSurveyCubit.surveyModel!.detail
                          .map((e) => IntrinsicHeight(
                                child: QuestionSurveyView(
                                  number: e["id"],
                                  index: detailSurveyCubit.surveyModel!.detail
                                      .indexOf(e),
                                  detailSurveyCubit: detailSurveyCubit,
                                  active: detailSurveyCubit.surveyModel!.active,
                                ),
                              ))
                          .toList(),
                      if (detailSurveyCubit.surveyModel!.active == false)
                        Padding(
                            padding:
                                EdgeInsets.all(Resizable.padding(context, 10)),
                            child: DottedBorderButton(
                                AppText.btnAddNewSurveyQuestion.text
                                    .toUpperCase(),
                                isManageGeneral: true, onPressed: () {
                              detailSurveyCubit.addNewQuestion();
                              cubit
                                  .updateSurvey(detailSurveyCubit.surveyModel!);
                            }))
                    ],
                  ),
                )),
                if (detailSurveyCubit.surveyModel!.active == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Resizable.size(context, 20)),
                            constraints: BoxConstraints(
                                minHeight: Resizable.size(context, 30)),
                            child: SubmitButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ConfirmActiveSurvey(
                                            onActive: (){
                                              detailSurveyCubit.changeActive();
                                              cubit.updateSurvey(
                                                  detailSurveyCubit.surveyModel!);
                                              Navigator.of(context).pop();
                                              notificationDialog(
                                                  context, AppText.txtActiveSuccess.text);
                                            }));

                                },
                                title: AppText.txtActive.text),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Resizable.size(context, 20)),
                            constraints: BoxConstraints(
                                minHeight: Resizable.size(context, 30)),
                            child: SubmitButton(
                                onPressed: () {
                                  detailSurveyCubit.save();
                                  cubit.updateSurvey(
                                      detailSurveyCubit.surveyModel!);
                                  notificationDialog(
                                      context, AppText.txtSaveSuccess.text);
                                },
                                title: AppText.txtSave.text),
                          ))
                    ],
                  )
              ],
            )),
        Expanded(
            flex: 2,
            child: Column(
              children: [
                TitleWidget(AppText.txtContent.text.toUpperCase()),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                      top: Resizable.padding(context, 10),
                      bottom: Resizable.padding(context, 10),
                      left: Resizable.padding(context, 30),
                      right: Resizable.padding(context, 15)),
                  padding: EdgeInsets.all(Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: const Color(0xffE0E0E0)),
                      borderRadius: BorderRadius.all(
                          Radius.circular(Resizable.size(context, 5))),
                      color: Colors.white),
                  child: EditSurveyQuestionView(
                      detailSurveyCubit: detailSurveyCubit),
                ))
              ],
            ))
      ],
    );
  }
}
