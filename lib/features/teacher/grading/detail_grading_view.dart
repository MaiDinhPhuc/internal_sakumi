import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'alert_grading_done.dart';
import 'answer_view/answer_info_view.dart';
import 'detail_grading_cubit.dart';


class DetailGradingView extends StatelessWidget {
  const DetailGradingView(this.cubit, this.soundCubit, {super.key});
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
                ...cubit.answers.map((e) => AnswerInfoView(
                      answerModel: e,
                      soundCubit: soundCubit,
                      cubit: cubit,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: Resizable.padding(context, 15)),
                  child: ElevatedButton(
                    onPressed: () {
                      for (var i in cubit.answers) {
                        FirebaseFirestore.instance
                            .collection('answer')
                            .doc(
                                'student_${i.studentId}_homework_question_${i.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 2)}')
                            .update({
                          'score': cubit
                              .listAnswer![cubit.listAnswer!.indexOf(i)]
                              .newScore,
                          'teacher_note':cubit
                              .listAnswer![cubit.listAnswer!.indexOf(i)]
                              .newTeacherNote,
                        });
                      }
                      if (cubit.listChecked.contains(cubit.state) == false) {
                        cubit.listChecked.add(cubit.state);
                        cubit.count++;
                      }
                      if (cubit.count == cubit.listAnswer!.length) {
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
                          int submitScore =
                              (temp / cubit.listQuestions!.length).round();
                          FirebaseFirestore.instance
                              .collection('student_lesson')
                              .doc(
                                  'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 2)}')
                              .update({
                            'hw': temp == 0 ? -1 : submitScore,
                          });
                        }
                        alertGradingDone(context, () async {
                          Navigator.of(context).pop();
                          await Navigator.pushNamed(context,
                              "${Routes.teacher}?name=${TextUtils.getName(position: 1)}/grading/class?id=${TextUtils.getName(position: 2)}");
                        });
                      }
                    },
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(primaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 1000)))),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 30)))),
                    child: Text(AppText.btnUpdate.text.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 16),
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          );
  }
}

class DropdownGradingCubit extends Cubit<String> {
  DropdownGradingCubit(this.value) : super(value);

  final String value;
  change(String value) {
    emit(value);
  }
}
