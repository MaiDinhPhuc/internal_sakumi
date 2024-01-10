import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/note_pending_view_card.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

import 'detail_lesson_cubit_v2.dart';

class LessonPendingViewV2 extends StatelessWidget {
  final DetailLessonCubitV2 cubit;
  const LessonPendingViewV2(this.cubit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 150)),
        child: Column(
          children: [
            NoteInPendingCard(cubit.check1, "", onPressed: () {
              cubit.updateCheck1();
            }, title: AppText.titleNoteBeforeTeaching.text, isHardCode: true),
            if (cubit.supportNote != "")
              NoteInPendingCard(
                  cubit.check2, cubit.supportNote!,
                  onPressed: () {
                    cubit.updateCheck2();
              }, title: AppText.titleNoteFromSupport.text, isHardCode: false),
            if (cubit.teacherNote != "")
              NoteInPendingCard(
                  cubit.check3, cubit.teacherNote!,
                  onPressed: () {
                    cubit.updateCheck3();
              },
                  title: AppText.titleNoteFromAnotherTeacher.text,
                  isHardCode: false),
            SizedBox(height: Resizable.size(context, 20)),
            SubmitButton(
                isActive: (cubit.check1 &&
                    cubit.check2 &&
                    cubit.check3)
                    ? true
                    : false,
                onPressed: () async {
                  waitingDialog(context);
                  await cubit.addLessonResult(LessonResultModel(
                      id: 1000,
                      classId: cubit.classId,
                      lessonId: cubit.lessonId,
                      teacherId: cubit.teacherId!,
                      status: 'Teaching',
                      date: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now()),
                      noteForStudent: '',
                      noteForSupport: '',
                      noteForTeacher: '',
                      supportNoteForTeacher: ""));

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                title: AppText.txtStartLesson.text),
            SizedBox(height: Resizable.size(context, 20))
          ],
        ));
  }
}
