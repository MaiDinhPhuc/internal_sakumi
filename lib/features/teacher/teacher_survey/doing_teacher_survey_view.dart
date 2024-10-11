import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/doing_teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/question_teacher_survey_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/teacher_survey_answer_doing_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'confirm_submit_teacher_survey.dart';

class DoingTeacherSurveyView extends StatelessWidget {
  const DoingTeacherSurveyView({super.key, required this.cubit});
  final DoingTeacherSurveyCubit cubit;
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
                      if (cubit.surveyModel!.detail.isNotEmpty)
                        SizedBox(height: Resizable.padding(context, 10)),
                      ...cubit.surveyModel!.detail
                          .map((e) => IntrinsicHeight(
                                child: QuestionTeacherSurveyView(
                                  number: e["id"],
                                  index: cubit.surveyModel!.detail.indexOf(e),
                                  cubit: cubit,
                                  done: cubit.checkDone(cubit.surveyModel!.detail.indexOf(e)),
                                ),
                              ))
                          .toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Resizable.padding(context, 10)),
                                  constraints: BoxConstraints(
                                      minHeight: Resizable.size(context, 30)),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ConfirmSubmitTeacherSurvey(
                                                cubit: cubit,
                                              ));
                                    },
                                    style: ButtonStyle(
                                        shadowColor: MaterialStateProperty.all(
                                            primaryColor),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Resizable.padding(
                                                            context, 5)))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                primaryColor),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                    Resizable.padding(context, 30)))),
                                    child: Text(
                                        "Gửi khảo sát".toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                Resizable.font(context, 16),
                                            color: Colors.white)),
                                  )))
                        ],
                      )
                    ],
                  ),
                )),
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
                  child: TeacherSurveyAnswerDoingView(cubit: cubit),
                ))
              ],
            ))
      ],
    );
  }
}
