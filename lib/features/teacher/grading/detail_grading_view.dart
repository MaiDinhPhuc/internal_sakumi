import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'answer_view/only_text_view.dart';
import 'answer_view/sound_view.dart';
import 'detail_grading_cubit.dart';
import 'drop_down_grading_widget.dart';
import 'answer_view/image_view.dart';

class DetailGradingView extends StatelessWidget {
  const DetailGradingView(this.cubit,this.soundCubit, {super.key});
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    return cubit.listAnswer == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ...cubit.answers.map((e) => e.answer.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10),
                            horizontal: Resizable.padding(context, 10)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5)),
                            color: Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 7,
                                child: (e.questionType == 1 ||
                                        e.questionType == 5 ||
                                        e.questionType == 6 ||
                                        e.questionType == 7 ||
                                        e.questionType == 8)
                                    ? OnlyTextView(
                                        answer: e,
                                      )
                                    : (e.questionType == 4 ||
                                            e.questionType == 2 ||
                                            e.questionType == 11)
                                        ? ImageView(answer: e)
                                        : SoundView(answer: e,soundCubit: soundCubit,)),
                            Expanded(
                                flex: 2,
                                child: DropDownGrading(items: [
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
                                ]))
                          ],
                        ),
                      ))
              ],
            ),
          );
  }
}
