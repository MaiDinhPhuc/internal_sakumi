import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/question_option.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

import 'detail_grading_cubit.dart';
import 'detail_grading_cubit_v2.dart';
import 'detail_grading_view.dart';
import 'drop_down_grading_widget.dart';

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
          : Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 20)),child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: TitleWidget(AppText.titleQuestion.text.toUpperCase())),
              Expanded(
                  flex: 6,
                  child: Container()),
              Expanded(
                  flex: 6,
                  child: BlocProvider(
                    create: (context) =>
                        DropdownGradingCubit(AppText.txtAll.text),
                    child: BlocBuilder<DropdownGradingCubit, String>(
                      builder: (cc, state) {
                        return DropDownGrading(
                            items: [
                              AppText.txtAll.text,
                              AppText.textNotMarked.text,
                            ],
                            onChanged: (item) {
                              if (item == AppText.txtAll.text) {
                                cubit.isAll = true;
                              } else if (item == AppText.textNotMarked.text) {
                                cubit.isAll = false;
                              }
                              BlocProvider.of<DropdownGradingCubit>(cc)
                                  .change(item!);
                              cubit.update();
                            },
                            value: state);
                      },
                    ),
                  ))

            ],
          )),
          Expanded(
              child: Container(
                margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...(cubit.getListQuestion())
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
                          isDone: cubit.checkGrading(e.id),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ))
        ],
      )),
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
          : Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 20)),child: Column(
        children: [
          Padding(padding:EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)) ,child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: TitleWidget(AppText.titleQuestion.text.toUpperCase())),
              Expanded(
                  flex: 6,
                  child: Container()),
              Expanded(
                  flex: 6,
                  child: BlocProvider(
                    create: (context) =>
                        DropdownGradingCubit(AppText.txtAll.text),
                    child: BlocBuilder<DropdownGradingCubit, String>(
                      builder: (cc, state) {
                        return DropDownGrading(
                            items: [
                              AppText.txtAll.text,
                              AppText.textNotMarked.text,
                            ],
                            onChanged: (item) {
                              if (item == AppText.txtAll.text) {
                                cubit.isAll = true;
                              } else if (item == AppText.textNotMarked.text) {
                                cubit.isAll = false;
                              }
                              BlocProvider.of<DropdownGradingCubit>(cc)
                                  .change(item!);
                              cubit.update();
                            },
                            value: state);
                      },
                    ),
                  ))

            ],
          )),
          Expanded(
              child: Container(
                margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...(cubit.getListQuestion())
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
                          isDone: cubit.checkGrading(e.id),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ))
        ],
      )),
    );
  }
}
