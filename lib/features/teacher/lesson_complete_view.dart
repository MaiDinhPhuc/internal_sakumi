import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/classification_item.dart';
import 'package:internal_sakumi/features/teacher/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lesson_teaching_view.dart';
import 'package:internal_sakumi/features/teacher/note_for_team_card.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class LessonCompleteView extends StatelessWidget {
  final TextEditingController controllerSupport, controllerTeacher;
  final CheckBoxCubit sp, ss;
  LessonCompleteView({Key? key})
      : controllerSupport = TextEditingController(),
        controllerTeacher = TextEditingController(),
        sp = CheckBoxCubit(),
        ss = CheckBoxCubit(),
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
        : Column(
            children: [
              ...attendanceCubit.listStudent!
                  .map((e) => ClassificationItem(
                          e,
                          attendanceCubit
                              .listStudentClass![
                                  attendanceCubit.listStudent!.indexOf(e)]
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
              BlocProvider(
                  create: (context) => sp,
                  child: BlocBuilder<CheckBoxCubit, bool?>(
                      builder: (c, s) => NoteForTeamCard(
                          hintText: AppText.txtHintNoteForSupport.text,
                          noNote: AppText.txtNoNoteForSupport.text,
                          controller: controllerSupport))),
              BlocProvider(
                  create: (context) => ss,
                  child: BlocBuilder<CheckBoxCubit, bool?>(
                      builder: (c, s) => NoteForTeamCard(
                          hintText: AppText.txtHintNoteForTeacher.text,
                          noNote: AppText.txtNoNoteForTeacher.text,
                          controller: controllerTeacher))),
              SizedBox(height: Resizable.size(context, 40)),
              SubmitButton(
                onPressed: () {
                  debugPrint(
                      '============><============ ${sp.state} ==== ${ss.state}');
                },
                title: AppText.txtCompleteLesson.text,
              ),
              SizedBox(height: Resizable.size(context, 100)),
            ],
          );
  }
}

class ActiveCubit extends Cubit<List<bool?>> {
  ActiveCubit() : super([]);

  update() {}
}
