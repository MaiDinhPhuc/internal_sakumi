import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'answer_view/answer_info_view.dart';
import 'answer_view/input_form/teacher_note_view.dart';
import 'answer_view/pick_image_cubit.dart';
import 'detail_grading_cubit.dart';

class DetailGradingView extends StatelessWidget {
  DetailGradingView(this.cubit, this.soundCubit,
      {super.key, required this.checkActiveCubit, required this.type, required this.dataCubit})
      : imageCubit = ImagePickerCubit();
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;
  final ImagePickerCubit imageCubit;
  final CheckActiveCubit checkActiveCubit;
  final String type;
  final DataCubit dataCubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    return cubit.listAnswer == null || cubit.state == -2
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :SingleChildScrollView(
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
                      await imageCubit.pickImageForAll(checkActiveCubit,cubit);
                    },
                    onOpenMic: () {},
                    type: 'all', checkActiveCubit: checkActiveCubit,
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
                          await submit(cubit, context, checkActiveCubit, type, dataCubit);
                        },
                        title: AppText.btnUpdate.text.toUpperCase()));
              })

        ],
      ),
    ) ;
  }
}

class CheckActiveCubit extends Cubit<bool> {
  CheckActiveCubit() : super(false);

  changeActive(bool value) {
    emit(value);
  }
}

Future<void> submit(DetailGradingCubit cubit, context, CheckActiveCubit checkCubit, String type, DataCubit dataCubit) async {
  cubit.loadingState();
  for(var i in cubit.answers){
    if(i.listImagePicker.isNotEmpty){
      List<String> list = [];
      for(var j in i.listImagePicker){
        if(i.checkIsUrl(j)){
          list.add(j);
        }else{
          final url = await FireBaseProvider.instance.uploadImageAndGetUrl(j, 'teacher_note_for_student');
          list.add(url);
        }
      }
      i.listImageUrl = list;
    }
  }

  for (var i in cubit.answers) {
    FirebaseFirestore.instance
        .collection('answer')
        .doc(
            type == "test"? 'student_${i.studentId}_test_question_${i.questionId}_class_${TextUtils.getName(position: 1)}' :'student_${i.studentId}_homework_question_${i.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
        .update({
      'score': cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newScore,
      'teacher_note':
          cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newTeacherNote,
      'teacher_images_note': cubit.listAnswer![cubit.listAnswer!.indexOf(i)].listImageUrl
    });
  }
  bool isDone = true;
  for (var i in cubit.answers) {
    if (i.newScore == -1) {
      isDone = false;
    }
  }
  if (isDone == true) {
    cubit.listState![cubit.listQuestions!.indexOf(cubit.listQuestions!
        .firstWhere((element) => element.id == cubit.now))] = true;
  }else{
    cubit.listState![cubit.listQuestions!.indexOf(cubit.listQuestions!
        .firstWhere((element) => element.id == cubit.now))] = false;
  }
  cubit.updateAfterGrading(cubit.now);
  cubit.isGeneralComment = false;
  checkCubit.changeActive(false);
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
      if(type == "test"){
        FirebaseFirestore.instance
            .collection('student_test')
            .doc(
            'student_${i.userId}_test_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
            .update({
          'score': temp == 0 ? -1 : submitScore,
        });
      }else{
        FirebaseFirestore.instance
            .collection('student_lesson')
            .doc(
            'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
            .update({
          'hw': temp == 0 ? -1 : submitScore,
        });
      }

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
