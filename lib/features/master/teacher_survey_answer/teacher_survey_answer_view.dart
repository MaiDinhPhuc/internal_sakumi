import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/question_teacher_survey_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/teacher_survey_answer_doing_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'detail_answer_teacher_survey_cubit.dart';

class TeacherSurveyAnswerView extends StatelessWidget {
  const TeacherSurveyAnswerView({Key? key, required this.cubit}) : super(key: key);

  final DetailAnswerTeacherSurveyCubit cubit;

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
                            child: QuestionTeacherSurveyViewV2(
                              number: e["id"],
                              index: cubit.surveyModel!.detail.indexOf(e),
                              cubit: cubit,
                              done: cubit.checkDone(cubit.surveyModel!.detail.indexOf(e)),
                            ),
                          ))
                              .toList(),
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
                      child: TeacherSurveyAnswerDoneView(cubit: cubit),
                    ))
              ],
            ))
      ],
    );
  }
}
