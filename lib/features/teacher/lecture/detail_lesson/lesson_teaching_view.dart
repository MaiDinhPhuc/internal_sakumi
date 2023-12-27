import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/alert_view.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/attendance_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class LessonTeachingView extends StatelessWidget {
  const LessonTeachingView(
      {Key? key, required this.dataCubit, required this.sessionCubit})
      : super(key: key);
  final DataCubit dataCubit;
  final SessionCubit sessionCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, int>(
        bloc: sessionCubit
          ..load(
              dataCubit.classes.firstWhere((e) =>
                  e.classModel.classId ==
                  int.parse(TextUtils.getName(position: 1))),
              dataCubit),
        builder: (cc, s) {
          return sessionCubit.listStudent == null ||
                  sessionCubit.listStudentLesson == null
              ? Transform.scale(
                  scale: 0.75,
                  child: const CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    ...sessionCubit.listStudent!.map((e) => AttendanceItem(
                          e,
                      sessionCubit
                          .listStudentLesson!.where((ee) => ee.studentId == e.userId).toList().isEmpty
                              ? 0
                              : sessionCubit
                          .listStudentLesson!.where((ee) => ee.studentId == e.userId).toList().first //cubit.listStudent!.indexOf(e)
                                  .timekeeping,
                          items: [
                            AppText.txtNotTimeKeeping.text,
                            AppText.txtPresent.text,
                            AppText.txtInLate.text,
                            AppText.txtOutSoon.text,
                            '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
                            AppText.txtPermitted.text,
                            AppText.txtAbsent.text,
                          ],
                          dataCubit: dataCubit,
                          sessionCubit: sessionCubit,
                          classId: int.parse(TextUtils.getName(position: 1)),
                          lessonId: int.parse(TextUtils.getName()), time: const {},
                        )),
                    NoteForTeamCard(
                      sessionCubit.isNoteStudent,
                      hintText: AppText.txtHintNoteForStudentSendToHV.text,
                      noNote: AppText.txtNoNoteForStudent.text,
                      onChanged: (v) {
                        sessionCubit.inputStudent(v);
                        //debugPrint('============= controller ${controller.text}');
                        sessionCubit.isNoteStudent = v.isNotEmpty ? null : true;
                        sessionCubit.checkNoteStudent();
                      },
                      onPressed: () {
                        sessionCubit.checkNoteStudent();
                        debugPrint(
                            '============= totalAttendance ${sessionCubit.totalAttendance}');
                      },
                      sessionCubit: sessionCubit,
                    ),
                    SizedBox(height: Resizable.size(context, 40)),
                    SubmitButton(
                        onPressed: () => alertView(
                            context,
                            sessionCubit.noteStudent.isNotEmpty
                                ? sessionCubit.noteStudent
                                : '',
                            dataCubit),
                        title: AppText.txtFinishLesson.text,
                        isActive: sessionCubit.totalAttendance ==
                                sessionCubit.listStudent!.length &&
                            sessionCubit.isNoteStudent != false),
                    SizedBox(height: Resizable.size(context, 100)),
                  ],
                );
        });
  }
}
