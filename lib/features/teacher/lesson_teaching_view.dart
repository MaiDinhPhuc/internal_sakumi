import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/alert_view.dart';
import 'package:internal_sakumi/features/teacher/attendance_item.dart';
import 'package:internal_sakumi/features/teacher/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/note_for_team_card.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class LessonTeachingView extends StatelessWidget {
  final TextEditingController controller;
  LessonTeachingView({Key? key})
      : controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    return attendanceCubit.listStudent == null ||
            attendanceCubit.listStudentLesson == null
        ? Transform.scale(
            scale: 0.75,
            child: const CircularProgressIndicator(),
          )
        : BlocProvider(
            create: (context) => CheckBoxCubit(),
            child: BlocBuilder<CheckBoxCubit, bool?>(
                builder: (c, s) => Column(
                      children: [
                        ...attendanceCubit.listStudent!.map((e) =>
                            AttendanceItem(
                                e,
                                attendanceCubit
                                    .listStudentLesson![
                                        attendanceCubit.listStudent!.indexOf(e)]
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
                        NoteForTeamCard(
                            hintText: AppText.txtHintNoteForStudent.text,
                            noNote: AppText.txtNoNoteForStudent.text,
                            controller: controller),
                        SizedBox(height: Resizable.size(context, 40)),
                        SubmitButton(
                            onPressed: () => alertView(
                                c,
                                controller.text.isNotEmpty
                                    ? controller.text
                                    : AppText.txtNoNoteForStudent.text),
                            title: AppText.txtFinishLesson.text,
                            isActive: s != false //&& attendanceCubit.isShow,
                            ),
                        SizedBox(height: Resizable.size(context, 100)),
                      ],
                    )));
  }
}

class CheckBoxCubit extends Cubit<bool?> {
  CheckBoxCubit() : super(false);

  check(bool? isShow) {
    emit(isShow);
  }
}
