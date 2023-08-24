import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/sound_view.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'image_view.dart';
import 'only_text_view.dart';

class StudentAnswerView extends StatelessWidget {
  const StudentAnswerView(
      {super.key,
      required this.answerModel,
      required this.cubit,
      required this.soundCubit, required this.checkActiveCubit});
  final AnswerModel answerModel;
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;
  final CheckActiveCubit checkActiveCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        answerModel.answer.isEmpty
            ? Expanded(
                flex: 7,
                child: Text(
                  AppText.textStudentNotDo.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ))
            : Expanded(
                flex: 7,
                child: (answerModel.questionType == 1 ||
                        answerModel.questionType == 5 ||
                        answerModel.questionType == 6 ||
                        answerModel.questionType == 7 ||
                        answerModel.questionType == 8)
                    ? OnlyTextView(
                        answer: answerModel,
                      )
                    : (answerModel.questionType == 4 ||
                            answerModel.questionType == 2 ||
                            answerModel.questionType == 11)
                        ? ImageView(answer: answerModel)
                        : SoundView(
                            answer: answerModel, soundCubit: soundCubit)),
        Expanded(
            key: Key("${answerModel.questionId}_${answerModel.studentId}"),
            flex: 2,
            child: BlocProvider(
              create: (context) => DropdownGradingCubit(cubit
                          .listAnswer![cubit.listAnswer!.indexOf(answerModel)]
                          .newScore ==
                      -1
                  ? AppText.textGradingScale.text
                  : cubit.listAnswer![cubit.listAnswer!.indexOf(answerModel)]
                      .newScore
                      .toString()),
              child: BlocBuilder<DropdownGradingCubit, String>(
                builder: (c, s) {
                  return DropDownGrading(
                      items: [
                        AppText.textGradingScale.text,
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                      ],
                      onChanged: (item) {
                        if (item != AppText.textGradingScale.text) {
                          BlocProvider.of<DropdownGradingCubit>(c)
                              .change(item!);
                          cubit
                              .listAnswer![
                                  cubit.listAnswer!.indexOf(answerModel)]
                              .newScore = int.parse(item);
                        } else {
                          BlocProvider.of<DropdownGradingCubit>(c)
                              .change(item!);
                          cubit
                              .listAnswer![
                                  cubit.listAnswer!.indexOf(answerModel)]
                              .newScore = -1;
                        }
                        if(cubit.answers.every((element) => element.newScore != element.score) || (cubit.answers.every((element) => element.score != -1) && cubit.answers.any((element) => element.newScore != element.score))){
                          checkActiveCubit.changeActive(true);
                        }else{
                          checkActiveCubit.changeActive(false);
                        }
                      },
                      value: s);
                },
              ),
            ))
      ],
    );
  }
}
