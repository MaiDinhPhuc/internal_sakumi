import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/master/teacher_survey_answer/detail_answer_teacher_survey_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'doing_teacher_survey_cubit.dart';

class TeacherSurveyAnswerDoingView extends StatelessWidget {
  const TeacherSurveyAnswerDoingView({Key? key, required this.cubit})
      : super(key: key);
  final DoingTeacherSurveyCubit cubit;
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController(text: cubit.getTextType3(cubit.surveyModel!.detail[cubit.index]['type']));
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
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 1 ||
                  cubit.surveyModel!.detail[cubit.index]['type'] == 2)
                Column(children: [
                  ...cubit.surveyModel!.detail[cubit.index]['answer'].map((e) =>
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.size(context, 10),
                              vertical: Resizable.size(context, 5)),
                          child: InkWell(
                            onTap: (){
                              cubit.chooseAnswerType12(cubit.surveyModel!.detail[cubit.index]['type'], e);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Icon(
                                        cubit.surveyModel!.detail[cubit.index]
                                        ['type'] ==
                                            1
                                            ? cubit.checkChooseType12(e)
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off
                                            : cubit.checkChooseType12(e)
                                            ? Icons.check_box_rounded
                                            : Icons.check_box_outline_blank,
                                        color: primaryColor,
                                        size: Resizable.size(context, 20))),
                                Expanded(
                                    flex: 14,
                                    child: Container(
                                      padding:
                                      EdgeInsets.all(Resizable.size(context, 5)),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: Resizable.size(context, 0.5),
                                          color: const Color(0xffE0E0E0),
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e, style: TextStyle(fontSize: Resizable.size(context, 20),fontWeight: FontWeight.w600),),
                                    ))
                              ],
                            ),
                          )))
                ]),
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 3)
                Padding(padding: EdgeInsets.symmetric(horizontal:Resizable.padding(context, 10)),child: InputItem(
                    title: AppText.txtAnswer.text,
                    controller: textController,
                    isExpand: true, onChange: (value){
                  cubit.inputAnswerType3(value);
                })),
              if (cubit.surveyModel!.detail[cubit.index]['type'] == 4)
                Row(
                    children: [
                      ...cubit.listVote
                          .map((e) => InkWell(
                        onTap: (){
                          cubit.chooseAnswerType4(e);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(
                                Resizable.size(context, 5)),
                            child: Icon(
                               Icons.star,
                                color: cubit.checkVote(e)? orangeColor.shade900 : darkPrimaryColor,
                                size: Resizable.size(context, 50))),
                      ))
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

class TeacherSurveyAnswerDoneView extends StatelessWidget {
  const TeacherSurveyAnswerDoneView({Key? key, required this.cubit})
      : super(key: key);
  final DetailAnswerTeacherSurveyCubit cubit;
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController(text: cubit.getTextType3(cubit.surveyModel!.detail[cubit.index]['type']));
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
                  if (cubit.surveyModel!.detail[cubit.index]['type'] == 1 ||
                      cubit.surveyModel!.detail[cubit.index]['type'] == 2)
                    Column(children: [
                      ...cubit.surveyModel!.detail[cubit.index]['answer'].map((e) =>
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.size(context, 10),
                                  vertical: Resizable.size(context, 5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Icon(
                                          cubit.surveyModel!.detail[cubit.index]
                                          ['type'] ==
                                              1
                                              ? cubit.checkChooseType12(e)
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off
                                              : cubit.checkChooseType12(e)
                                              ? Icons.check_box_rounded
                                              : Icons.check_box_outline_blank,
                                          color: primaryColor,
                                          size: Resizable.size(context, 20))),
                                  Expanded(
                                      flex: 14,
                                      child: Container(
                                        padding:
                                        EdgeInsets.all(Resizable.size(context, 5)),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: Resizable.size(context, 0.5),
                                            color: const Color(0xffE0E0E0),
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(e, style: TextStyle(fontSize: Resizable.size(context, 20),fontWeight: FontWeight.w600),),
                                      ))
                                ],
                              )))
                    ]),
                  if (cubit.surveyModel!.detail[cubit.index]['type'] == 3)
                    Padding(padding: EdgeInsets.symmetric(horizontal:Resizable.padding(context, 10)),child: InputItem(
                        title: AppText.txtAnswer.text,
                        controller: textController,
                        isExpand: true,enabled: false,)),
                  if (cubit.surveyModel!.detail[cubit.index]['type'] == 4)
                    Row(
                        children: [
                          ...cubit.listVote
                              .map((e) => Padding(
                              padding: EdgeInsets.all(
                                  Resizable.size(context, 5)),
                              child: Icon(
                                  Icons.star,
                                  color: cubit.checkVote(e)? orangeColor.shade900 : darkPrimaryColor,
                                  size: Resizable.size(context, 50))))
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
