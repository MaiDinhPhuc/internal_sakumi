import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/question_view.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'answer_view/answer_info_view.dart';
import 'answer_view/input_form/teacher_note_view.dart';
import 'answer_view/pick_image_cubit.dart';
import 'collapse_question.dart';
import 'detail_grading_cubit.dart';

class DetailGradingView extends StatelessWidget {
  DetailGradingView(this.cubit, this.soundCubit,
      {super.key, required this.checkActiveCubit, required this.dataCubit})
      : imageCubit = ImagePickerCubit();
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;
  final ImagePickerCubit imageCubit;
  final CheckActiveCubit checkActiveCubit;
  final DataCubit dataCubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    return cubit.listAnswer == null || cubit.state == -2
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: BlocProvider(
                            create: (context) => DropdownCubit(),
                            child: BlocBuilder<DropdownCubit, int>(
                              builder: (c, state) => Stack(
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 10)),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                Resizable.size(context, 5)),
                                            bottomRight: Radius.circular(
                                                Resizable.size(context, 5)),
                                            bottomLeft: Radius.circular(
                                                Resizable.size(context, 5)),
                                          ),
                                          color: Colors.white),
                                      child: AnimatedCrossFade(
                                          firstChild: CollapseQuestion(
                                            onPress: () {
                                              BlocProvider.of<DropdownCubit>(c).update();
                                            },
                                            state: state,
                                          ),
                                          secondChild: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CollapseQuestion(
                                                onPress: () {
                                                  BlocProvider.of<DropdownCubit>(c)
                                                      .update();
                                                },
                                                state: state,
                                              ),
                                              Container(
                                                height: Resizable.size(context, 1),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: Resizable.padding(context, 5)),
                                                color: const Color(0xffD9D9D9),
                                              ),
                                              SizedBox(height: Resizable.padding(context, 10)),
                                              QuestionView(
                                                  questionModel:
                                                      cubit.getQuestion(),
                                                  soundCubit: soundCubit,
                                                  cubit: cubit),
                                              SizedBox(height: Resizable.padding(context, 10)),
                                            ],
                                          ),
                                          crossFadeState: state % 2 == 1
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration: const Duration(
                                              milliseconds: 100))),
                                ],
                              ),
                            )))
                  ],
                ),
                ...cubit.answers.map((e) => AnswerInfoView(
                      answerModel: e,
                      soundCubit: soundCubit,
                      cubit: cubit,
                      checkActiveCubit: checkActiveCubit,
                    )),
                if (cubit.isGeneralComment)
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10),
                        horizontal: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 5))),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.textGeneralComment.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w700)),
                        TeacherNoteView(
                          imagePickerCubit: imageCubit,
                          answerModel: cubit.listAnswer!.first,
                          cubit: cubit,
                          noteController: noteController,
                          onChange: (String? text) {
                            if (text != null) {
                              for (var i in cubit.answers) {
                                i.newTeacherNote = text;
                              }
                            }
                          },
                          onOpenFile: () async {
                            await imageCubit.pickImageForAll(
                                checkActiveCubit, cubit);
                          },
                          onOpenMic: () {},
                          type: 'all',
                          checkActiveCubit: checkActiveCubit,
                        ),
                      ],
                    ),
                  ),
                BlocBuilder<CheckActiveCubit, bool>(
                    bloc: checkActiveCubit,
                    builder: (c, s) {
                      return Padding(
                          padding: EdgeInsets.only(
                              top: Resizable.padding(context, 15)),
                          child: SubmitButton(
                              isActive: s,
                              onPressed: () async {
                                await cubit.submit(
                                    cubit,
                                    context,
                                    checkActiveCubit,
                                    cubit.gradingType,
                                    dataCubit);
                              },
                              title: AppText.btnUpdate.text.toUpperCase()));
                    })
              ],
            ),
          );
  }
}

class CheckActiveCubit extends Cubit<bool> {
  CheckActiveCubit() : super(false);

  changeActive(bool value) {
    emit(value);
  }
}

class DropdownGradingCubit extends Cubit<String> {
  DropdownGradingCubit(this.value) : super(value);

  final String value;
  change(String value) {
    emit(value);
  }
}
