import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/alert_view.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/attendance_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_for_team_card.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class LessonTeachingView extends StatelessWidget {
  final TextEditingController controller;
  LessonTeachingView({Key? key})
      : controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    var cubit = BlocProvider.of<SessionCubit>(context);
    debugPrint('===============> LessonTeachingView 1${cubit.listStudent == null }');
    debugPrint('===============> LessonTeachingView 2${ cubit.listStudentLesson == null}');
    return cubit.listStudent == null || cubit.listStudentLesson == null
        ? Transform.scale(
            scale: 0.75,
            child: const CircularProgressIndicator(),
          )
        : Column(
            children: [
              ...cubit.listStudent!.map((e) => AttendanceItem(
                      e,
                      cubit.listStudent!.indexOf(e) > cubit.listStudentLesson!.length - 1 ? 0 :cubit.listStudentLesson![cubit.listStudent!.indexOf(e)]//cubit.listStudent!.indexOf(e)
                          .timekeeping,
                      items: [
                        AppText.txtNotTimeKeeping.text,
                        AppText.txtPresent.text,
                        AppText.txtInLate.text,
                        AppText.txtOutSoon.text,
                        '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
                        AppText.txtPermitted.text,
                        AppText.txtAbsent.text,
                      ])),
              NoteForTeamCard(cubit.isNoteStudent,
                  hintText: AppText.txtHintNoteForStudent.text,
                  noNote: AppText.txtNoNoteForStudent.text, onChanged: (v) {
                cubit.isNoteStudent = v.isNotEmpty ? null : true;
                cubit.checkNoteStudent();
              }, onPressed: () {
                cubit.checkNoteStudent();
                debugPrint('============= totalAttendance ${cubit.totalAttendance}');
              }),
              SizedBox(height: Resizable.size(context, 40)),
              SubmitButton(
                  onPressed: () => alertView(
                      context,
                      controller.text.isNotEmpty
                          ? controller.text
                          : AppText.txtNoNoteForStudent.text),
                  title: AppText.txtFinishLesson.text,
                  isActive:
                      cubit.totalAttendance == cubit.listStudent!.length &&
                          cubit.isNoteStudent != false),
              SizedBox(height: Resizable.size(context, 100)),
            ],
          );
  }
}
