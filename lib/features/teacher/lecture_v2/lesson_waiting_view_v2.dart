import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/classification_item.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_confirm_complete_waiting_view.dart';
import 'detail_lesson_cubit_v2.dart';
import 'note_for_team_card_v2.dart';

class LessonWaitingViewV2 extends StatelessWidget {
  final DetailLessonCubitV2 cubit;
  const LessonWaitingViewV2(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Resizable.padding(context, 10)),
        ...cubit.students
            .map((e) => ClassificationItem(
                  e,
                  cubit.stdClasses![cubit.students.indexOf(e)].activeStatus,
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
                    cubit.inputNoteForEachStudent(v, e.userId);
                  },
                ))
            .toList(),
        Column(
          children: [
            NoteForTeamCardV2(
              cubit.isNoteSupport,
              hintText: AppText.txtHintNoteForSupport.text,
              noNote: AppText.txtNoNoteForSupport.text,
              onChanged: (v) {
                cubit.isNoteSupport = v.isNotEmpty ? null : true;
                cubit.inputSupport(v);
                cubit.checkNoteSupport();
              },
              onPressed: () {
                cubit.checkNoteSupport();
              },
              cubit: cubit,
            ),
            NoteForTeamCardV2(
              cubit.isNoteSensei,
              hintText: AppText.txtHintNoteForTeacher.text,
              noNote: AppText.txtNoNoteForTeacher.text,
              onChanged: (v) {
                cubit.isNoteSensei = v.isNotEmpty ? null : true;
                cubit.inputSensei(v);
                cubit.checkNoteSensei();
              },
              onPressed: () {
                cubit.checkNoteSensei();
              },
              cubit: cubit,
            ),
            SizedBox(height: Resizable.size(context, 40)),
            SubmitButton(
              onPressed: () => alertCompleteWaitingView(context, () async {
                Navigator.pop(context);
                waitingDialog(context);
                await cubit.noteForSupport(
                    cubit.noteSupport.isNotEmpty
                        ? cubit.noteSupport
                        : '');
                if (context.mounted) {
                  await cubit.noteForAnotherSensei(
                      cubit.noteSupport.isNotEmpty
                          ? cubit.noteSensei
                          : '');
                }
                if (context.mounted) {
                  for (var std in cubit.students) {
                    var index = cubit.students.indexOf(std);

                    updateTeacherNote(
                        std.userId, cubit.listNoteForEachStudent[index]);

                    var stdLesson = cubit.stdLessons!
                        .firstWhere((e) => e.studentId == std.userId && e.lessonId == cubit.lessonId);

                    cubit.updateStudentLesson(
                        std.userId,
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
                            teacherNote:
                                cubit.listNoteForEachStudent[index],
                            supportNote: stdLesson.supportNote,
                            time: {}));
                  }
                  cubit.updateStatus('Complete');
                  if (context.mounted) {
                    Navigator.pushNamed(context,
                        "${Routes.teacher}/lesson/class=${cubit.classId}");
                  }
                }
              }),
              isActive:
                  cubit.isNoteSupport != false && cubit.isNoteSensei != false,
              title: AppText.txtCompleteLesson.text,
            ),
          ],
        ),
        SizedBox(height: Resizable.size(context, 100)),
      ],
    );
  }

  updateTeacherNote(int userId, String note) async {
    await FireBaseProvider.instance
        .updateTeacherNote(userId, cubit.lessonId, cubit.classId, note);
  }
}
