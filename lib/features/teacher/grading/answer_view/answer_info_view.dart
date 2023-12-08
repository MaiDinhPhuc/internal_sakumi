import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/pick_image_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_dialog.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_services.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/student_answer_view.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/voice_record_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/collapse_teacher_note.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:microphone/microphone.dart';

import 'input_form/teacher_note_view.dart';

class AnswerInfoView extends StatelessWidget {
  AnswerInfoView(
      {super.key,
      required this.answerModel,
      required this.soundCubit,
      required this.cubit,
      required this.checkActiveCubit})
      : imageCubit = ImagePickerCubit(),
        voiceRecordCubit = VoiceRecordCubit();
  final AnswerModel answerModel;
  final SoundCubit soundCubit;
  final DetailGradingCubit cubit;
  final ImagePickerCubit imageCubit;
  final CheckActiveCubit checkActiveCubit;
  final VoiceRecordCubit voiceRecordCubit;
  @override
  Widget build(BuildContext context) {
    TextEditingController noteController =
        TextEditingController(text: answerModel.newTeacherNote);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cubit.isShowName)
            Container(
              margin: EdgeInsets.only(bottom: Resizable.padding(context, 1)),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 4),
                  horizontal: Resizable.padding(context, 40)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Resizable.size(context, 5)),
                      topRight: Radius.circular(Resizable.size(context, 5))),
                  color: Colors.white),
              child: Text(
                cubit.getStudentName(answerModel),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: Resizable.font(context, 18)),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Resizable.padding(context, 10),
                horizontal: Resizable.padding(context, 10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Resizable.size(context, 5)),
                  bottomRight: Radius.circular(Resizable.size(context, 5)),
                  bottomLeft: Radius.circular(Resizable.size(context, 5)),
                ),
                color: Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              StudentAnswerView(
                answerModel: answerModel,
                cubit: cubit,
                soundCubit: soundCubit,
                checkActiveCubit: checkActiveCubit,
              ),
              if (!cubit.isGeneralComment)
                BlocProvider(
                    create: (context) => DropdownCubit(),
                    child: BlocBuilder<DropdownCubit, int>(
                      builder: (c, state) => Container(
                          alignment: Alignment.centerLeft,
                          child: AnimatedCrossFade(
                              firstChild: CollapseTeacherNote(
                                onPress: () {
                                  BlocProvider.of<DropdownCubit>(c).update();
                                },
                                state: state,
                              ),
                              secondChild: Column(
                                children: [
                                  CollapseTeacherNote(
                                    onPress: () {
                                      BlocProvider.of<DropdownCubit>(c)
                                          .update();
                                    },
                                    state: state,
                                  ),
                                  TeacherNoteView(
                                    imagePickerCubit: imageCubit,
                                    answerModel: answerModel,
                                    cubit: cubit,
                                    noteController: noteController,
                                    onChange: (String? text) {
                                      if (text != null) {
                                        cubit
                                            .listAnswer![cubit.listAnswer!
                                                .indexOf(answerModel)]
                                            .newTeacherNote = text;
                                      }
                                    },
                                    onOpenFile: () async {
                                      await imageCubit.pickImage(
                                          answerModel, checkActiveCubit, cubit);
                                    },
                                    onOpenMic: () async {
                                      await voiceRecordCubit.record(context,
                                          answerModel, checkActiveCubit, cubit);
                                    },
                                    type: 'single',
                                    checkActiveCubit: checkActiveCubit,
                                    voiceRecordCubit: voiceRecordCubit,
                                    soundCubit: soundCubit,
                                  )
                                ],
                              ),
                              crossFadeState: state % 2 == 1
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100))),
                    ))
            ]),
          )
        ],
      ),
    );
  }
}
