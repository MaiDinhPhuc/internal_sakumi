import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/pending_view_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

import 'note_pending_view_card.dart';

class LessonPendingView extends StatelessWidget {
  final DetailLessonCubit cubit;
  const LessonPendingView(this.cubit, this.dataCubit, this.pendingViewCubit,
      {Key? key})
      : super(key: key);
  final DataCubit dataCubit;
  final PendingViewCubit pendingViewCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingViewCubit, int>(
        bloc: pendingViewCubit
          ..load(dataCubit.classes!.firstWhere((e) =>
              e.classModel.classId ==
              int.parse(TextUtils.getName(position: 1)))),
        builder: (c, s) {
          return Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 150)),child: Column(
            children: [
              NoteInPendingCard(pendingViewCubit.check1,"",onPressed: () {
                pendingViewCubit.updateCheck1();
              }, title: AppText.titleNoteBeforeTeaching.text, isHardCode: true),
              if(pendingViewCubit.supportNote != "")
                NoteInPendingCard(pendingViewCubit.check2,pendingViewCubit.supportNote! ,onPressed: () {
                  pendingViewCubit.updateCheck2();
                }, title: AppText.titleNoteFromSupport.text, isHardCode: false),
              if(pendingViewCubit.teacherNote != "")
                NoteInPendingCard(pendingViewCubit.check3 ,pendingViewCubit.teacherNote!,onPressed: () {
                  pendingViewCubit.updateCheck3();
                }, title: AppText.titleNoteFromAnotherTeacher.text, isHardCode: false),
              SizedBox(height: Resizable.size(context, 20)),
              SubmitButton(
                isActive: (pendingViewCubit.check1 && pendingViewCubit.check2 && pendingViewCubit.check3) ? true : false,
                  onPressed: () async {
                    waitingDialog(context);
                    await cubit.addLessonResult(LessonResultModel(
                        id: 1000,
                        classId: int.parse(TextUtils.getName(position: 1)),
                        lessonId: int.parse(TextUtils.getName()),
                        teacherId: cubit.teacherId!,
                        status: 'Teaching',
                        date: DateFormat('dd/MM/yyyy HH:mm:ss')
                            .format(DateTime.now()),
                        noteForStudent: '',
                        noteForSupport: '',
                        noteForTeacher: '', supportNoteForTeacher: ""));
                    dataCubit.updateLessonResults(
                        int.parse(TextUtils.getName(position: 1)),
                        LessonResultModel(
                            id: 1000,
                            classId: int.parse(TextUtils.getName(position: 1)),
                            lessonId: int.parse(TextUtils.getName()),
                            teacherId: cubit.teacherId!,
                            status: 'Teaching',
                            date: DateFormat('dd/MM/yyyy HH:mm:ss')
                                .format(DateTime.now()),
                            noteForStudent: '',
                            noteForSupport: '',
                            noteForTeacher: '',supportNoteForTeacher: ""));
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  title: AppText.txtStartLesson.text)
            ],
          ));
        });
  }
}
