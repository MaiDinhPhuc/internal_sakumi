import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'answer_view/answer_info_view.dart';
import 'answer_view/input_form/teacher_note_view.dart';
import 'answer_view/pick_image_cubit.dart';
import 'detail_grading_cubit.dart';

class DetailGradingView extends StatelessWidget {
  DetailGradingView(this.cubit, this.soundCubit,
      {super.key, required this.checkActiveCubit})
      : imageCubit = ImagePickerCubit();
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;
  final ImagePickerCubit imageCubit;
  final CheckActiveCubit checkActiveCubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    return cubit.listAnswer == null || cubit.state == -2
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : BlocBuilder<CheckActiveCubit, bool>(
            bloc: checkActiveCubit,
            builder: (c, s) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ...cubit.answers.map((e) => AnswerInfoView(
                          answerModel: e,
                          soundCubit: soundCubit,
                          cubit: cubit, checkActiveCubit: checkActiveCubit,
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
                                await imageCubit.pickImageForAll(cubit.answers);
                              },
                              onOpenMic: () {},
                              type: 'all',
                            ),
                          ],
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: Resizable.padding(context, 15)),
                        child: SubmitButton(
                            isActive: s,
                            onPressed: () async {
                              await submit(cubit);
                            },
                            title: AppText.btnUpdate.text.toUpperCase()))
                  ],
                ),
              );
            });
  }
}

class CheckActiveCubit extends Cubit<bool> {
  CheckActiveCubit() : super(false);

  changeActive(bool value) {
    emit(value);
  }
}

Future<void> submit(DetailGradingCubit cubit) async {

  for(var i in cubit.answers){
    if(i.listImagePicker.isNotEmpty){

    }
  }

  for (var i in cubit.answers) {
    FirebaseFirestore.instance
        .collection('answer')
        .doc(
            'student_${i.studentId}_homework_question_${i.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 2)}')
        .update({
      'score': cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newScore,
      'teacher_note':
          cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newTeacherNote,
    });
  }
  bool isDone = true;
  for (var i in cubit.answers) {
    if (i.newScore == -1) {
      isDone = false;
    }
  }
  if (isDone) {
    cubit.listState![cubit.listQuestions!.indexOf(cubit.listQuestions!
        .firstWhere((element) => element.id == cubit.state))] = isDone;
  }
  cubit.updateAfterGrading(cubit.state);

  cubit.isGeneralComment = false;
  if (cubit.checkDone(false)) {
    for (var i in cubit.listStudent!) {
      int temp = 0;
      for (var j in cubit.listAnswer!) {
        if (i.userId == j.studentId) {
          if (j.newScore == -1) {
            temp = temp;
          } else {
            temp = temp + j.newScore;
          }
        }
      }
      int submitScore = (temp / cubit.listQuestions!.length).round();
      FirebaseFirestore.instance
          .collection('student_lesson')
          .doc(
              'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 2)}')
          .update({
        'hw': temp == 0 ? -1 : submitScore,
      });
    }
  }
}

class DropdownGradingCubit extends Cubit<String> {
  DropdownGradingCubit(this.value) : super(value);

  final String value;
  change(String value) {
    emit(value);
  }
}
