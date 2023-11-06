import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/classification_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class LessonCompleteView extends StatelessWidget {
  final DetailLessonCubit detailCubit;
  const LessonCompleteView(this.detailCubit, this.dataCubit, this.sessionCubit,
      {Key? key})
      : super(key: key);
  final DataCubit dataCubit;
  final SessionCubit sessionCubit;

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> listController = List.generate(
        sessionCubit.listStudent == null ? 0 : sessionCubit.listStudent!.length,
        (index) => TextEditingController()).toList();
    return Column(
      children: [
        SizedBox(height: Resizable.padding(context, 10)),
        ...sessionCubit.listStudent!
            .map((e) => ClassificationItem(
                    e,
                    sessionCubit
                        .listStudentClass![sessionCubit.listStudent!.indexOf(e)]
                        .activeStatus,
                    listController[sessionCubit.listStudent!.indexOf(e)],
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
        BlocBuilder<SessionCubit, int>(
            bloc: sessionCubit
              ..load(
                  dataCubit.classes!.firstWhere((e) =>
                      e.classModel.classId ==
                      int.parse(TextUtils.getName(position: 1))),
                  dataCubit),
            builder: (c, s) {
              return Column(
                children: [
                  NoteForTeamCard(
                    sessionCubit.isNoteSupport,
                    hintText: AppText.txtHintNoteForSupport.text,
                    noNote: AppText.txtNoNoteForSupport.text,
                    onChanged: (v) {
                      sessionCubit.isNoteSupport = v.isNotEmpty ? null : true;
                      sessionCubit.inputSupport(v);
                      sessionCubit.checkNoteSupport();
                    },
                    onPressed: () {
                      sessionCubit.checkNoteSupport();
                    },
                    sessionCubit: sessionCubit,
                  ),
                  NoteForTeamCard(
                    sessionCubit.isNoteSensei,
                    hintText: AppText.txtHintNoteForTeacher.text,
                    noNote: AppText.txtNoNoteForTeacher.text,
                    onChanged: (v) {
                      sessionCubit.isNoteSensei = v.isNotEmpty ? null : true;
                      sessionCubit.inputSensei(v);
                      sessionCubit.checkNoteSensei();
                    },
                    onPressed: () {
                      sessionCubit.checkNoteSensei();
                    },
                    sessionCubit: sessionCubit,
                  ),
                  SizedBox(height: Resizable.size(context, 40)),
                  SubmitButton(
                    onPressed: () async {
                      waitingDialog(context);
                      await detailCubit.noteForSupport(
                          sessionCubit.noteSupport.isNotEmpty
                              ? sessionCubit.noteSupport
                              : '',
                          dataCubit);
                      if (context.mounted) {
                        await detailCubit.noteForAnotherSensei(
                            sessionCubit.noteSupport.isNotEmpty
                                ? sessionCubit.noteSensei
                                : '',
                            dataCubit);
                      }
                      if (context.mounted) {
                        for (var std in sessionCubit.listStudent!) {
                          await updateTeacherNote(
                              std.userId,
                              listController[
                                      sessionCubit.listStudent!.indexOf(std)]
                                  .text);
                        }
                        if (context.mounted) {
                          Navigator.pushNamed(context,
                              "${Routes.teacher}/lesson/class=${int.parse(TextUtils.getName(position: 1))}");
                        }
                      }
                    },
                    isActive: sessionCubit.isNoteSupport != false &&
                        sessionCubit.isNoteSensei != false,
                    title: AppText.txtCompleteLesson.text,
                  ),
                ],
              );
            }),
        SizedBox(height: Resizable.size(context, 100)),
      ],
    );
  }

  updateTeacherNote(int userId, String note) async {
    await FireBaseProvider.instance.updateTeacherNote(
        userId,
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)),
        note);
  }
}
