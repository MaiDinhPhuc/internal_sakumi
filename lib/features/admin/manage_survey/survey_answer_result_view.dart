import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'detail_survey_admin_cubit.dart';
import 'info_student_answer_view.dart';

class SurveyAnswerResultView extends StatelessWidget {
  const SurveyAnswerResultView({Key? key, required this.cubit})
      : super(key: key);
  final DetailSurveyAdminCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 10),
                      vertical: Resizable.size(context, 5)),
                  child: Text(
                      cubit.surveyModel!.detail[cubit.index]['question'],
                      style: TextStyle(
                          fontSize: Resizable.size(context, 25),
                          fontWeight: FontWeight.w700))),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 10),
                      vertical: Resizable.size(context, 5)),
                  child: Text(
                      AppText.txtSubmitNumber.text
                          .replaceAll("@", cubit.getNumberAnswer().toString())
                          .replaceAll("#", cubit.stdClasses!.length.toString()),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: Resizable.size(context, 15),
                          fontWeight: FontWeight.w600))),
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 1 || cubit.surveyModel!.detail[cubit.index]['type'] == 2)
                Column(
                  children: [
                    ...cubit.surveyModel!.detail[cubit.index]['answer']
                        .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 10),
                            vertical: Resizable.size(context, 5)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Text(e,
                                        style: TextStyle(
                                            fontSize:
                                            Resizable.size(context, 20),
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () {
                                            if(cubit.getNumberAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e)!=0){
                                              alertStudentInfo(
                                                  context,
                                                  cubit,
                                                  cubit.surveyModel!
                                                      .detail[cubit.index]["id"],e);
                                            }
                                          },
                                          child: Text(
                                              "${cubit.getNumberAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e)} người chọn",
                                              style: TextStyle(
                                                  color: greyColor.shade600,
                                                  fontSize: Resizable.size(
                                                      context, 20),
                                                  fontWeight: FontWeight.w500)),
                                        ))),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          "${((cubit.getNumberAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e) / cubit.getNumberAnswer()) * 100).toStringAsFixed(0)}%",
                                          style: TextStyle(
                                              fontSize:
                                              Resizable.size(context, 20),
                                              fontWeight: FontWeight.w700)),
                                    ))
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 5)),
                                child: LinearPercentIndicator(
                                  padding: EdgeInsets.zero,
                                  animation: true,
                                  lineHeight: Resizable.size(context, 15),
                                  animationDuration: 2000,
                                  percent: (cubit.getNumberAnswerByAnswerId(
                                      cubit.surveyModel!.detail[cubit.index]
                                      ["id"],
                                      e) /
                                      cubit.getNumberAnswer()),
                                  center: const SizedBox(),
                                  barRadius: const Radius.circular(5),
                                  backgroundColor: greyColor.shade100,
                                  progressColor: primaryColor,
                                )),
                          ],
                        )))
                        .toList(),
                    if(cubit.surveyModel!.detail[cubit.index]['another'])
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.size(context, 10),
                              vertical: Resizable.size(context, 5)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Text("Ý kiến khác",
                                          style: TextStyle(
                                              fontSize:
                                              Resizable.size(context, 20),
                                              fontWeight: FontWeight.w500))),
                                  Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            onPressed: () {
                                              if(cubit.getNumberAnotherAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"])!=0){
                                                alertStudentInfoWithAnotherAnswer(
                                                    context,
                                                    cubit,
                                                    cubit.surveyModel!
                                                        .detail[cubit.index]["id"]);
                                              }
                                            },
                                            child: Text(
                                                "${cubit.getNumberAnotherAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"])} người chọn",
                                                style: TextStyle(
                                                    color: greyColor.shade600,
                                                    fontSize: Resizable.size(
                                                        context, 20),
                                                    fontWeight: FontWeight.w500)),
                                          ))),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                            "${((cubit.getNumberAnotherAnswerByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"]) / cubit.getNumberAnswer()) * 100).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                                fontSize:
                                                Resizable.size(context, 20),
                                                fontWeight: FontWeight.w700)),
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 5)),
                                  child: LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    animation: true,
                                    lineHeight: Resizable.size(context, 15),
                                    animationDuration: 2000,
                                    percent: (cubit.getNumberAnotherAnswerByAnswerId(
                                        cubit.surveyModel!.detail[cubit.index]
                                        ["id"]) /
                                        cubit.getNumberAnswer()),
                                    center: const SizedBox(),
                                    barRadius: const Radius.circular(5),
                                    backgroundColor: greyColor.shade100,
                                    progressColor: primaryColor,
                                  )),
                            ],
                          ))
                  ]
                ),
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 3)
                ...cubit.listSurveyAnswer!
                    .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 10),
                            vertical: Resizable.size(context, 5)),
                        child: Row(
                          children: [
                            cubit
                                    .getAnswerInput(cubit
                                        .surveyModel!.detail[cubit.index]["id"])
                                    .isEmpty
                                ? Container()
                                : Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(
                                            Resizable.padding(context, 10)),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: greyColor.shade600),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(cubit.getAnswerInput(cubit
                                            .surveyModel!
                                            .detail[cubit.index]["id"]))))
                          ],
                        )))
                    .toList(),
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 4)
                Column(
                    children: [
                      ...cubit.listVote
                          .map((e) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.size(context, 10),
                              vertical: Resizable.size(context, 5)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < int.parse(e); i++)
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: Resizable.padding(
                                                        context, 10)),
                                                child: Image.asset('assets/images/star.png',
                                                    height: Resizable.size(context, 30),
                                                    width: Resizable.size(context, 30))
                                            )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            onPressed: () {
                                              if(cubit.getNumberAnswerType4ByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e)!=0){
                                                alertStudentInfoType4(
                                                    context,
                                                    cubit,
                                                    cubit.surveyModel!
                                                        .detail[cubit.index]["id"],e);
                                              }
                                            },
                                            child: Text(
                                                "${cubit.getNumberAnswerType4ByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e)} người chọn",
                                                style: TextStyle(
                                                    color: greyColor.shade600,
                                                    fontSize: Resizable.size(
                                                        context, 20),
                                                    fontWeight: FontWeight.w500)),
                                          ))),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                            "${((cubit.getNumberAnswerType4ByAnswerId(cubit.surveyModel!.detail[cubit.index]["id"], e) / cubit.getNumberAnswer()) * 100).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                                fontSize:
                                                Resizable.size(context, 20),
                                                fontWeight: FontWeight.w700)),
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 5)),
                                  child: LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    animation: true,
                                    lineHeight: Resizable.size(context, 15),
                                    animationDuration: 2000,
                                    percent: (cubit.getNumberAnswerType4ByAnswerId(
                                        cubit.surveyModel!.detail[cubit.index]
                                        ["id"],
                                        e) /
                                        cubit.getNumberAnswer()),
                                    center: const SizedBox(),
                                    barRadius: const Radius.circular(5),
                                    backgroundColor: greyColor.shade100,
                                    progressColor: primaryColor,
                                  )),
                            ],
                          )))
                          .toList()
                    ]
                ),
            ],
          ),
        ))
      ],
    );
  }
}
