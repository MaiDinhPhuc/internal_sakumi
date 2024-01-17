import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ChooseScoreAnswer extends StatelessWidget {
  ChooseScoreAnswer({super.key, required this.cubit, required this.answerModel, required this.checkActiveCubit})
      : scoreCubit = ChooseScoreCubit();
  final DetailGradingCubit cubit;
  final AnswerModel answerModel;
  final ChooseScoreCubit scoreCubit;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: scoreCubit
          ..loadScore(cubit
              .listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore),
        builder: (c, s) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...listScore.map((e) => GestureDetector(
                    onTap: () {
                      var temp = e;
                      cubit
                          .listAnswer![cubit.listAnswer!.indexOf(answerModel)]
                          .newScore = e;
                      if (cubit.answers
                          .every((element) => element.score != -1)) {
                        if (temp !=
                            cubit
                                .listAnswer![
                                    cubit.listAnswer!.indexOf(answerModel)]
                                .score) {
                          checkActiveCubit.changeActive(true);
                        }
                      } else {
                        if (cubit.answers
                            .every((element) => element.newScore != -1)) {
                          checkActiveCubit.changeActive(true);
                        } else {
                          checkActiveCubit.changeActive(false);
                        }
                      }
                      scoreCubit.update(e);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Resizable.size(context, 5)),
                      padding: EdgeInsets.all(Resizable.size(context, 5)),
                      height: Resizable.size(context, 30),
                      width: Resizable.size(context, 30),
                      decoration: ShapeDecoration(
                        color: s == e ? primaryColor : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Resizable.size(context, 5)),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4.71,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                          child: Text(e.toString(),
                              style: TextStyle(
                                color: s == e ? Colors.white : Colors.black,
                                fontSize: Resizable.size(context, 13),
                                fontWeight: FontWeight.w600,
                              ))),
                    ),
                  ))
            ],
          );
        });
  }
}

class ChooseScoreAnswerV2 extends StatelessWidget {
  ChooseScoreAnswerV2({super.key, required this.cubit, required this.answerModel, required this.checkActiveCubit})
      : scoreCubit = ChooseScoreCubit();
  final DetailGradingCubitV2 cubit;
  final AnswerModel answerModel;
  final ChooseScoreCubit scoreCubit;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: scoreCubit
          ..loadScore(cubit
              .listAnswer![cubit.listAnswer!.indexOf(answerModel)].newScore),
        builder: (c, s) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...listScore.map((e) => GestureDetector(
                onTap: () {
                  var temp = e;
                  cubit
                      .listAnswer![cubit.listAnswer!.indexOf(answerModel)]
                      .newScore = e;
                  if (cubit.answers
                      .every((element) => element.score != -1)) {
                    if (temp !=
                        cubit
                            .listAnswer![
                        cubit.listAnswer!.indexOf(answerModel)]
                            .score) {
                      checkActiveCubit.changeActive(true);
                    }
                  } else {
                    if (cubit.answers
                        .every((element) => element.newScore != -1)) {
                      checkActiveCubit.changeActive(true);
                    } else {
                      checkActiveCubit.changeActive(false);
                    }
                  }
                  scoreCubit.update(e);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 5)),
                  padding: EdgeInsets.all(Resizable.size(context, 5)),
                  height: Resizable.size(context, 30),
                  width: Resizable.size(context, 30),
                  decoration: ShapeDecoration(
                    color: s == e ? primaryColor : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4.71,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Center(
                      child: Text(e.toString(),
                          style: TextStyle(
                            color: s == e ? Colors.white : Colors.black,
                            fontSize: Resizable.size(context, 13),
                            fontWeight: FontWeight.w600,
                          ))),
                ),
              ))
            ],
          );
        });
  }
}

List<double> listScore = [0, 2.5, 5, 7.5, 10];

class ChooseScoreCubit extends Cubit<double> {
  ChooseScoreCubit() : super(-1);

  loadScore(double value) {

    if(value == -1){
      emit(-1);
    }
    if(value == 0){
      emit(0);
    }
    if (0 < value && value <= 2.5) {
      emit(2.5);
    }
    if (2.5 < value && value <= 5) {
      emit(5);
    }
    if (5 < value && value <= 7.5) {
      emit(7.5);
    }
    if (7.5 < value && value <= 10) {
      emit(10);
    }
  }

  update(double value){
    emit(-1);
    emit(value);
  }
}
