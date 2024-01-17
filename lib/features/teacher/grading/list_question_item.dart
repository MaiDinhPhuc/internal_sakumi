import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/question_option.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'detail_grading_cubit.dart';
import 'detail_grading_cubit_v2.dart';
import 'detail_grading_view.dart';

class ListQuestionItem extends StatelessWidget {
  const ListQuestionItem({super.key, required this.cubit, required this.s, required this.checkActiveCubit});
  final DetailGradingCubit cubit;
  final int s;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Resizable.padding(context, 20)),
      child: cubit.listAnswer == null
          ? Transform.scale(
        scale: 0.75,
        child: const CircularProgressIndicator(),
      )
          : Column(
        children: [
          TitleWidget(AppText.titleQuestion.text.toUpperCase()),
          Expanded(
              child: Container(
                margin:
                EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...(cubit.listQuestions!)
                          .map((e) => IntrinsicHeight(
                        child: QuestionOptionItem(
                          s,
                          cubit.listQuestions!.indexOf(e),
                          cubit.now,
                          questionModel: e,
                          onTap: () {
                            cubit.change(e.id);
                            checkActiveCubit.changeActive(false);
                          },
                          isDone: cubit.listState![
                          cubit.listQuestions!.indexOf(e)],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class ListQuestionItemV2 extends StatelessWidget {
  const ListQuestionItemV2({super.key, required this.cubit, required this.s, required this.checkActiveCubit});
  final DetailGradingCubitV2 cubit;
  final int s;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Resizable.padding(context, 20)),
      child: cubit.listAnswer == null
          ? Transform.scale(
        scale: 0.75,
        child: const CircularProgressIndicator(),
      )
          : Column(
        children: [
          TitleWidget(AppText.titleQuestion.text.toUpperCase()),
          Expanded(
              child: Container(
                margin:
                EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...(cubit.listQuestions!)
                          .map((e) => IntrinsicHeight(
                        child: QuestionOptionItem(
                          s,
                          cubit.listQuestions!.indexOf(e),
                          cubit.now,
                          questionModel: e,
                          onTap: () {
                            cubit.change(e.id);
                            checkActiveCubit.changeActive(false);
                          },
                          isDone: cubit.listState![
                          cubit.listQuestions!.indexOf(e)],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
