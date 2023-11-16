import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/header_grading.dart';
import 'package:internal_sakumi/features/teacher/grading/list_question_item.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailGradingScreen extends StatelessWidget {
  final String type;
  DetailGradingScreen(this.type, {super.key})
      : questionSoundCubit = SoundCubit(),
        checkActiveCubit = CheckActiveCubit();
  final SoundCubit questionSoundCubit;
  final CheckActiveCubit checkActiveCubit;
  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    return BlocProvider(
        create: (context) => DetailGradingCubit()..init(type),
        child: Scaffold(
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
                                              HeaderGrading(cubit: cubit),
                                              Expanded(
                                                  child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: Resizable.padding(
                                                        context, 5),
                                                    right: Resizable.padding(
                                                        context, 10)),
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
                                                  dataCubit: dataController,
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
