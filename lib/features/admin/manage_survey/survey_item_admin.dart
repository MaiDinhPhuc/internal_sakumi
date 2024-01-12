import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_survey/confirm_delete_survey.dart';
import 'package:internal_sakumi/features/master/manage_survey/survey_layout.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../widget/waiting_dialog.dart';
import 'confirm_assign_survey.dart';
import 'confirm_recall_survey.dart';
import 'manage_survey_admin_cubit.dart';

class SurveyItemAdmin extends StatelessWidget {
  const SurveyItemAdmin({super.key, required this.result, required this.cubit});
  final SurveyResultModel result;
  final ManageSurveyAdminCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: Resizable.padding(context, 10)),
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border.all(
                width: Resizable.size(context, 1), color: greyColor.shade100),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: SurveyLayout(
          surveyCode: Text(result.surveyCode,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17))),
          title: Text(result.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17))),
          number:result.dateAssign == 0
              ? Container()
              : Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left:Resizable.padding(context, 15)),
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        animation: true,
                        lineHeight: Resizable.size(context, 6),
                        animationDuration: 2000,
                        percent: cubit.getNumber(result.surveyId)/cubit.stdClasses!.length,
                        center: const SizedBox(),
                        barRadius: const Radius.circular(10000),
                        backgroundColor: greyColor.shade100,
                        progressColor: primaryColor,
                      ))),
              Container(
                alignment: Alignment.centerRight,
                constraints:
                BoxConstraints(minWidth: Resizable.size(context, 50)),
                child: Text(
                    '${cubit.getNumber(result.surveyId)} / ${cubit.stdClasses!.length} bài',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 16))),
              )
            ],
          ),
          date: result.dateAssign == 0
              ? Container()
              : Text(convertDate(result.dateAssign),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 17))),
          moreButton: SizedBox(
            height: Resizable.size(context, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  splashRadius: Resizable.size(context, 15),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black, // Set the desired border color here
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Resizable.size(context, 5)),
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        if (result.status == 'assign') {
                          await Navigator.pushNamed(context,
                              "/admin/survey/class=${result.classId}/surveyId=${result.surveyId}");
                          // await Navigator.pushNamed(context,
                          //     "/admin/survey/class=${result.classId}/surveyId=${result.surveyId}");
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmAssignSurvey(
                                    result: result, cubit: cubit,
                                  ));
                          //waitingDialog(context);
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Text(
                              result.status == "assign"
                                  ? AppText.txtSeeResult.text
                                  : AppText.txtAssignTest.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 20),
                                  color: Colors.black))),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        if (result.status == 'assign') {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmRecallSurvey(
                                result: result, cubit: cubit,
                              ));
                          //waitingDialog(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => ConfirmDeleteSurvey(
                                result: result, cubit: cubit,
                              ));
                          //waitingDialog(context);
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Text(
                              result.status == "assign"
                                  ? AppText.txtRecall.text
                                  : AppText.txtDeleteSurvey.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Resizable.font(context, 20),
                                  color: const Color(0xffB71C1C)))),
                    )
                  ],
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
        ));
  }
}

String convertDate(int date) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
  String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  return formattedDate;
}
