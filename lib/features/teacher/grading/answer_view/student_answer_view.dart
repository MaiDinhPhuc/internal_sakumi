import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/sound_view.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'choose_score_answer.dart';
import 'image_view.dart';
import 'only_text_view.dart';

class StudentAnswerView extends StatelessWidget {
  const StudentAnswerView(
      {super.key,
      required this.answerModel,
      required this.cubit,
      required this.soundCubit,
      required this.checkActiveCubit});
  final AnswerModel answerModel;
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;
  final CheckActiveCubit checkActiveCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(answerModel.questionId.toString()),
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
                        ? ImageView(
                            answer: answerModel,
                            token: cubit.token,
                            type: cubit.gradingType)
                        : SoundView(
                            answer: answerModel, soundCubit: soundCubit)),
        Expanded(flex: 5, child: ChooseScoreAnswer(cubit: cubit, answerModel: answerModel, checkActiveCubit: checkActiveCubit,))
      ],
    );
  }
}

class StudentAnswerViewV2 extends StatelessWidget {
  const StudentAnswerViewV2(
      {super.key,
        required this.answerModel,
        required this.cubit,
        required this.soundCubit,
        required this.checkActiveCubit});
  final AnswerModel answerModel;
  final DetailGradingCubitV2 cubit;
  final SoundCubit soundCubit;
  final CheckActiveCubit checkActiveCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(answerModel.questionId.toString()),
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
                ? ImageView(
                answer: answerModel,
                token: cubit.token,
                type: cubit.gradingType)
                : SoundView(
                answer: answerModel, soundCubit: soundCubit)),
        Expanded(flex: 5, child: ChooseScoreAnswerV2(cubit: cubit, answerModel: answerModel, checkActiveCubit: checkActiveCubit,))
      ],
    );
  }
}