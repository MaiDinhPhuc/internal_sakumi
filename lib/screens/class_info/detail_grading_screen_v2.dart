import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/collapse_question.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/header_grading.dart';
import 'package:internal_sakumi/features/teacher/grading/list_question_item.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/radar_test_chart.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class DetailGradingScreen extends StatelessWidget {
  final String type;
  DetailGradingScreen(this.type, {super.key})
      : questionSoundCubit = SoundCubit(),
        checkActiveCubit = CheckActiveCubit();
  final SoundCubit questionSoundCubit;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailGradingCubit()..init(type),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              HeaderTeacher(
                index: 3,
                classId: TextUtils.getName(position: 1),
                role: 'teacher',
              ),
              Expanded(
                child: BlocBuilder<DetailGradingCubit, int>(builder: (c, s) {
                  var cubit = BlocProvider.of<DetailGradingCubit>(c);
                  return s == -1
                      ? Transform.scale(
                          scale: 0.75,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : cubit.listAnswer!.isEmpty
                          ? Center(
                              child: Text(AppText.textStudentNotSubmit.text),
                            )
                          : cubit.listQuestions!.isEmpty
                              ? Center(
                                  child: Text(AppText.textContactIT.text),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Resizable.padding(context, 50)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: ListQuestionItem(
                                              cubit: cubit,
                                              s: s,
                                              checkActiveCubit:
                                                  checkActiveCubit)),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              HeaderGrading(
                                                  cubit: cubit, type: type),
                                              Expanded(child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                bottom:Resizable.padding(
                                                    context, 5)),
                                                      padding: EdgeInsets.all(
                                                          Resizable.padding(
                                                              context, 5)),
                                                      decoration: BoxDecoration(
                                                          color: lightGreyColor,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              Resizable.size(
                                                                  context, 5))),
                                                      child: BlocProvider(
                                                          create: (context) => DropdownCubit()..updateOne(),
                                                          child: BlocBuilder<DropdownCubit, int>(
                                                            builder: (c, state) => Container(

                                                                alignment: Alignment.centerLeft,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                    Resizable.padding(context, 10)),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width: 0.5, color: Colors.black),
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            Resizable.size(context, 5))),
                                                                    color: Colors.white),
                                                                child: AnimatedCrossFade(
                                                                    firstChild: CollapseOverViewTest(
                                                                      onPress: () {
                                                                        BlocProvider.of<DropdownCubit>(c)
                                                                            .update();
                                                                      },
                                                                      state: state,
                                                                    ),
                                                                    secondChild: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CollapseOverViewTest(
                                                                          onPress: () {
                                                                            BlocProvider.of<DropdownCubit>(
                                                                                c)
                                                                                .update();
                                                                          },
                                                                          state: state,
                                                                        ),
                                                                        SizedBox(
                                                                            height:  Resizable.size(
                                                                                context, cubit.analysis != 0 ? 230 : 150),
                                                                            child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: Resizable.size(context, 80),
                                                                                  child: CircleProgress(
                                                                                    title: '${(cubit.submitPercent*100).toStringAsFixed(0)}%',
                                                                                    lineWidth: Resizable.size(context, 5),
                                                                                    percent: cubit.submitPercent,
                                                                                    radius: Resizable.size(context, 30),
                                                                                    fontSize: Resizable.font(context, 20),
                                                                                  ),
                                                                                ),
                                                                                Text(AppText.txtRateOfSubmitTest.text,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Colors.black,
                                                                                        fontSize: Resizable.font(context, 24)))
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: Resizable.size(context, 80),
                                                                                  child: CircleProgress(
                                                                                    title: cubit.getAveragePoint().toStringAsFixed(2).toString(),
                                                                                    lineWidth: Resizable.size(context, 5),
                                                                                    percent: cubit.getAveragePoint()/10,
                                                                                    radius: Resizable.size(context, 30),
                                                                                    fontSize: Resizable.font(context, 20),
                                                                                  ),
                                                                                ),
                                                                                Text(AppText.txtAveragePoint.text,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Colors.black,
                                                                                        fontSize: Resizable.font(context, 24)))
                                                                              ],
                                                                            ),
                                                                            if(cubit.analysis != 0)
                                                                            SizedBox(
                                                                                height: Resizable.size(
                                                                                    context, 200),
                                                                                width: Resizable.size(
                                                                                    context, 200),
                                                                                child: AnalyticsTestChart(data: cubit.getDataChart())),
                                                                          ],
                                                                        )),
                                                                      ],
                                                                    ),
                                                                    crossFadeState: state % 2 == 1
                                                                        ? CrossFadeState.showFirst
                                                                        : CrossFadeState.showSecond,
                                                                    duration:
                                                                    const Duration(milliseconds: 100))),
                                                          )),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          Resizable.padding(
                                                              context, 5)),
                                                      decoration: BoxDecoration(
                                                          color: lightGreyColor,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              Resizable.size(
                                                                  context, 5))),
                                                      child: DetailGradingView(
                                                        cubit,
                                                        questionSoundCubit,
                                                        checkActiveCubit:
                                                        checkActiveCubit,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                }),
              )
            ],
          ),
        ));
  }
}

class PopUpOptionCubit extends Cubit<List<bool>> {
  PopUpOptionCubit() : super([true, false]);

  change(bool value, int index) {
    List<bool> listState = state;
    listState[index] = value;
    emit(listState);
  }
}

class CheckBoxFilterCubit extends Cubit<bool> {
  CheckBoxFilterCubit(bool state) : super(state);

  update() {
    emit(!state);
  }
}
