import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/master/teacher_survey_answer/detail_answer_teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_survey/doing_teacher_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class QuestionTeacherSurveyView extends StatelessWidget {
  const QuestionTeacherSurveyView(
      {super.key,
        required this.index,
        required this.number,
        required this.cubit, required this.done});
  final int index, number;
  final bool done;
  final DoingTeacherSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: number == cubit.selector
              ? primaryColor
              : Colors.transparent,
          width: Resizable.size(context, 4),
          margin: EdgeInsets.only(
              right: Resizable.padding(context, 5),
              bottom: Resizable.padding(context, 10)),
        ),
        Expanded(
            child: Card(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5)),
                    side: BorderSide(
                        color: number == cubit.selector
                            ? Colors.black
                            : const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1))),
                elevation: number == cubit.selector
                    ? Resizable.size(context, 2)
                    : 0,
                child: InkWell(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5)),
                    onTap: () {
                      cubit.select(number);
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10),
                            horizontal: Resizable.padding(context, 15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Câu số ${index + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 17)),
                            ),
                            Icon(done?Icons.check_circle:Icons.check_circle_outline, color: done?primaryColor:darkPrimaryColor)
                          ],
                        )))))
      ],
    );
  }
}

class QuestionTeacherSurveyViewV2 extends StatelessWidget {
  const QuestionTeacherSurveyViewV2(
      {super.key,
        required this.index,
        required this.number,
        required this.cubit, required this.done});
  final int index, number;
  final bool done;
  final DetailAnswerTeacherSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: number == cubit.selector
              ? primaryColor
              : Colors.transparent,
          width: Resizable.size(context, 4),
          margin: EdgeInsets.only(
              right: Resizable.padding(context, 5),
              bottom: Resizable.padding(context, 10)),
        ),
        Expanded(
            child: Card(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5)),
                    side: BorderSide(
                        color: number == cubit.selector
                            ? Colors.black
                            : const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1))),
                elevation: number == cubit.selector
                    ? Resizable.size(context, 2)
                    : 0,
                child: InkWell(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5)),
                    onTap: () {
                      cubit.select(number);
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10),
                            horizontal: Resizable.padding(context, 15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Câu số ${index + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 17)),
                            ),
                            Icon(done?Icons.check_circle:Icons.check_circle_outline, color: done?primaryColor:darkPrimaryColor)
                          ],
                        )))))
      ],
    );
  }
}