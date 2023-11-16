import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/classification_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
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
    return Column(
      children: [
        SizedBox(height: Resizable.padding(context, 10)),
        ...sessionCubit.listStudent!
            .map((e) => ClassificationItem(
                  e,
                  sessionCubit
                      .listStudentClass![sessionCubit.listStudent!.indexOf(e)]
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
                  ],
                  onChanged: (String v) {
                    sessionCubit.inputNoteForEachStudent(v, e.userId);
                  },
                ))
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
                          var tempStd = sessionCubit.listStudent!
                              .firstWhere((e) => e.userId == std.userId);
                          var index =
                              sessionCubit.listStudent!.indexOf(tempStd);

                          await updateTeacherNote(std.userId,
                              sessionCubit.listNoteForEachStudent[index]);

                          var stdLesson = sessionCubit.listStudentLesson!.firstWhere((e) => e.studentId == tempStd.userId);

                          dataCubit.updateStudentLesson(
                              int.parse(TextUtils.getName(position: 1)),
                              StudentLessonModel(
                                  grammar: stdLesson.grammar,
                                  hw: stdLesson.hw,
                                  id: stdLesson.id,
                                  classId: stdLesson.classId,
                                  kanji: stdLesson.kanji,
                                  lessonId: stdLesson.lessonId,
                                  listening: stdLesson.listening,
                                  studentId: stdLesson.studentId,
                                  timekeeping: stdLesson.timekeeping,
                                  vocabulary: stdLesson.vocabulary,
                                  teacherNote: sessionCubit.listNoteForEachStudent[index],
                                  supportNote: stdLesson.supportNote, doingTime: stdLesson.doingTime));
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
