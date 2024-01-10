import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'alert_confirm_complete_lesson.dart';
import 'attendance_item_teacher.dart';
import 'detail_lesson_cubit_v2.dart';
import 'note_for_team_card_v2.dart';

class LessonTeachingViewV2 extends StatelessWidget {
  const LessonTeachingViewV2(this.cubit, {super.key});
  final DetailLessonCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...cubit.students.map((e) => AttendanceItemTeacher(
            e,
            cubit.getStdLesson(e.userId) == null
                ? 0
                : cubit.getStdLesson(e.userId)!.timekeeping,
            items: [
              AppText.txtNotTimeKeeping.text,
              AppText.txtPresent.text,
              AppText.txtInLate.text,
              AppText.txtOutSoon.text,
              '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
              AppText.txtPermitted.text,
              AppText.txtAbsent.text,
            ],
            cubit: cubit)),
        NoteForTeamCardV2(
          cubit.isNoteStudent,
          cubit: cubit,
          hintText: AppText.txtHintNoteForStudentSendToHV.text,
          noNote: AppText.txtNoNoteForStudent.text,
          onChanged: (v) {
            cubit.inputStudent(v);
            cubit.isNoteStudent = v.isNotEmpty ? null : true;
            cubit.checkNoteStudent();
          },
          onPressed: () {
            cubit.checkNoteStudent();
            debugPrint(
                '============= totalAttendance ${cubit.totalAttendance}');
          },
        ),
        SizedBox(height: Resizable.size(context, 40)),
        SubmitButton(
            onPressed: ()
            => alertConfirmCompleteLessonView(
                context,
                cubit.noteStudent.isNotEmpty
                    ? cubit.noteStudent
                    : '',cubit),
            title: AppText.txtFinishLesson.text,
            isActive: cubit.totalAttendance ==
                cubit.students.length &&
                cubit.isNoteStudent != false),
        SizedBox(height: Resizable.size(context, 100)),
      ],
    );
  }
}
