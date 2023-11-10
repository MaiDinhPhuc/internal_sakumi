import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/question_option.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_services.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

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
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: Resizable.padding(
                                                    context, 20)),
                                            child: cubit.listAnswer == null
                                                ? Transform.scale(
                                                    scale: 0.75,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  )
                                                : Column(
                                                    children: [
                                                      TitleWidget(AppText
                                                          .titleQuestion.text
                                                          .toUpperCase()),
                                                      Expanded(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: Resizable
                                                                .padding(
                                                                    context,
                                                                    5)),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              ...(cubit
                                                                      .listQuestions!)
                                                                  .map((e) =>
                                                                      IntrinsicHeight(
                                                                        child:
                                                                            QuestionOptionItem(
                                                                          s,
                                                                          cubit
                                                                              .listQuestions!
                                                                              .indexOf(e),
                                                                          cubit
                                                                              .now,
                                                                          questionModel:
                                                                              e,
                                                                          onTap:
                                                                              () {
                                                                            cubit.change(e.id,
                                                                                c);
                                                                            checkActiveCubit.changeActive(false);
                                                                            SoundService.instance.dispose();
                                                                          },
                                                                          soundCubit:
                                                                              questionSoundCubit,
                                                                          isDone: cubit.listState![cubit
                                                                              .listQuestions!
                                                                              .indexOf(e)],
                                                                          token:
                                                                              cubit.token,
                                                                          type:
                                                                              cubit.gradingType,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                      flex: 6,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: Resizable
                                                                .padding(
                                                                    context,
                                                                    10),
                                                          ),
                                                          child: Text(
                                                              AppText
                                                                  .titleGrading
                                                                  .text
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  fontSize: Resizable
                                                                      .font(
                                                                          context,
                                                                          20),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: greyColor
                                                                      .shade500)))),
                                                  Expanded(
                                                      flex: 1,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) =>
                                                                          [
                                                                            ...cubit.listStudent!.map((e) => PopupMenuItem(
                                                                                padding: EdgeInsets.zero,
                                                                                child: BlocProvider(
                                                                                    create: (c) => CheckBoxFilterCubit(cubit.listStudentId!.contains(e.userId)),
                                                                                    child: BlocBuilder<CheckBoxFilterCubit, bool>(builder: (cc, state) {
                                                                                      return CheckboxListTile(
                                                                                        controlAffinity: ListTileControlAffinity.leading,
                                                                                        title: Text(e.name),
                                                                                        value: state,
                                                                                        onChanged: (newValue) {
                                                                                          if (state && cubit.listStudentId!.length == 1) {
                                                                                          } else if (state && cubit.listStudentId!.length != 1) {
                                                                                            cubit.listStudentId!.remove(e.userId);
                                                                                            BlocProvider.of<CheckBoxFilterCubit>(cc).update();
                                                                                          } else {
                                                                                            cubit.listStudentId!.add(e.userId);
                                                                                            BlocProvider.of<CheckBoxFilterCubit>(cc).update();
                                                                                          }
                                                                                          cubit.updateAnswerView(cubit.state);
                                                                                        },
                                                                                      );
                                                                                    }))))
                                                                          ],
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(Resizable.size(
                                                                          context,
                                                                          10)),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              blurRadius: Resizable.size(context, 2),
                                                                              color: greyColor.shade100)
                                                                        ],
                                                                        border: Border.all(
                                                                            color: greyColor
                                                                                .shade100),
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(1000)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Center(child: Text(AppText.txtStudent.text, style: TextStyle(fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500)))),
                                                                        const Icon(
                                                                            Icons.keyboard_arrow_down)
                                                                      ],
                                                                    ),
                                                                  )),
                                                        ),
                                                      )),
                                                  BlocProvider(
                                                    create: (c) =>
                                                        PopUpOptionCubit(),
                                                    child: BlocBuilder<
                                                        PopUpOptionCubit,
                                                        List<bool>>(
                                                      builder: (cc, list) {
                                                        return PopupMenuButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  Resizable.size(
                                                                      context,
                                                                      10)),
                                                            ),
                                                          ),
                                                          itemBuilder:
                                                              (context) => [
                                                            PopupMenuItem(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              child:
                                                                  CheckboxListTile(
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                                title: Text(AppText
                                                                    .textShowName
                                                                    .text),
                                                                value: list[0],
                                                                onChanged:
                                                                    (newValue) {
                                                                  BlocProvider
                                                                          .of<PopUpOptionCubit>(
                                                                              cc)
                                                                      .change(
                                                                          newValue!,
                                                                          0);
                                                                  cubit.isShowName =
                                                                      !cubit
                                                                          .isShowName;
                                                                  cubit.updateAnswerView(
                                                                      cubit
                                                                          .state);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              child:
                                                                  CheckboxListTile(
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                                title: Text(AppText
                                                                    .textGeneralComment
                                                                    .text),
                                                                value: list[1],
                                                                onChanged:
                                                                    (newValue) {
                                                                  BlocProvider
                                                                          .of<PopUpOptionCubit>(
                                                                              cc)
                                                                      .change(
                                                                          newValue!,
                                                                          1);
                                                                  cubit.isGeneralComment =
                                                                      !cubit
                                                                          .isGeneralComment;
                                                                  if (newValue ==
                                                                      true) {
                                                                    for (var i
                                                                        in cubit
                                                                            .answers) {
                                                                      i.listImagePicker =
                                                                          [];
                                                                    }
                                                                  }
                                                                  cubit.updateAnswerView(
                                                                      cubit
                                                                          .state);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                          icon: const Icon(
                                                              Icons.more_vert),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
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
                                                  type: type,
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
