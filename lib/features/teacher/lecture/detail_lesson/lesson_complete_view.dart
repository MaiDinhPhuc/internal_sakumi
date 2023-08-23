import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/classification_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class LessonCompleteView extends StatelessWidget {
  final DetailLessonCubit detailCubit;
  const LessonCompleteView(this.detailCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<SessionCubit>(context);
    return cubit.listStudent == null || cubit.listStudentLesson == null
        ? Transform.scale(
            scale: 0.75,
            child: const CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(height: Resizable.padding(context, 10)),
              ...cubit.listStudent!
                  .map((e) => ClassificationItem(
                          e,
                          cubit.listStudentClass![cubit.listStudent!.indexOf(e)]
                              .activeStatus,
                          firstItems: [
                            AppText.txtActiveStatus.text.toUpperCase(),
                            'A',
                            'B',
                            'C',
                            'D',
                            'E'
                          ],
                          secondItems: [
                            AppText.txtLearningStatus.text.toUpperCase(),
                            'A',
                            'B',
                            'C',
                            'D',
                            'E'
                          ]))
                  .toList(),
              NoteForTeamCard(cubit.isNoteSupport,
                  hintText: AppText.txtHintNoteForSupport.text,
                  noNote: AppText.txtNoNoteForSupport.text, onChanged: (v) {
                cubit.isNoteSupport = v.isNotEmpty ? null : true;
                cubit.inputSupport(v);
                cubit.checkNoteSupport();
              }, onPressed: () {
                cubit.checkNoteSupport();
              }),
              NoteForTeamCard(cubit.isNoteSensei,
                  hintText: AppText.txtHintNoteForTeacher.text,
                  noNote: AppText.txtNoNoteForTeacher.text, onChanged: (v) {
                cubit.isNoteSensei = v.isNotEmpty ? null : true;
                cubit.inputSensei(v);
                cubit.checkNoteSensei();
              }, onPressed: () {
                cubit.checkNoteSensei();
              }),
              SizedBox(height: Resizable.size(context, 40)),
              SubmitButton(
                onPressed: ()async{
                  waitingDialog(context);
                  await detailCubit
                      .noteForSupport(context, cubit.noteSupport.isNotEmpty
                      ? cubit.noteSupport
                      : AppText.txtNoNoteForSupport.text);
                  if(context.mounted) {
                    await detailCubit
                      .noteForAnotherSensei(context, cubit.noteSupport.isNotEmpty
                      ? cubit.noteSensei
                      : AppText.txtNoNoteForTeacher.text);
                  }
                  if(context.mounted){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                isActive:
                    cubit.isNoteSensei != false && cubit.isNoteSupport != false,
                title: AppText.txtCompleteLesson.text,
              ),
              SizedBox(height: Resizable.size(context, 100)),
            ],
          );
  }
}
