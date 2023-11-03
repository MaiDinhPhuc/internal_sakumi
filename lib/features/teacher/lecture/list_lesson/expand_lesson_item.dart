import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class ExpandLessonItem extends StatelessWidget {
  final int index;
  final LessonTabCubit cubit;
  const ExpandLessonItem(this.index, {Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.titleNoteFromSupport.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
        NoteWidget(cubit.listSpNote![index]!.toString()),
          Text(AppText.titleNoteFromAnotherTeacher.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
          NoteWidget(cubit.listTeacherNote![index]!.toString()),
          Container(
            height: Resizable.size(context, 1),
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
            color: const Color(0xffD9D9D9),
          ),
          TrackStudentItemRowLayout(
              name: Text(
                AppText.txtName.text,
                style: TextStyle(
                    color: const Color(0xff757575),
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17)),
              ),
              attendance: Text(
                AppText.txtAttendance.text,
                style: TextStyle(
                    color: const Color(0xff757575),
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17)),
              ),
              submit: Text(
                AppText.txtDoHomeworks.text,
                style: TextStyle(
                    color: const Color(0xff757575),
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17)),
              ),
              note: Text(
                AppText.titleNoteFromAnotherTeacher.text,
                style: TextStyle(
                    color: const Color(0xff757575),
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17)),
              )),
          Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(int i = 0; i<cubit.listDetailLesson![index]!['names'].length; i++ )
                       TrackStudentItemRowLayout(
                              name: Text(
                                cubit.listDetailLesson![index]!['names'][i],
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 20),
                                    fontWeight: FontWeight.w500),
                              ),
                              attendance: TrackingItem(
                                  cubit.listDetailLesson![index]!['attendance'][i]),
                              submit:  TrackingItem(
                                  cubit.listDetailLesson![index]!['hw'][i],
                                  isSubmit: true),
                              note:  NoteWidget(cubit.listDetailLesson![index]!['note'][i]))
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
