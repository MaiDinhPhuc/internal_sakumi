import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class ExpandLessonItem extends StatelessWidget {
  final int index;
  const ExpandLessonItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LessonTabCubit>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.titleNoteFromSupport.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
        NoteWidget(cubit.lessonResults![index] == null ? '' : cubit.lessonResults![index]!.noteForSupport.toString()),
          Text(AppText.titleNoteFromAnotherTeacher.text,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 19))),
          NoteWidget(cubit.lessonResults![index] == null ? '' :cubit.lessonResults![index]!.noteForTeacher.toString()),
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
          cubit.students == null
              ? Center(
                  child: Transform.scale(
                    scale: 0.75,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...cubit.students!
                          .map((e) => TrackStudentItemRowLayout(
                              name: Text(
                                e.name,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 20),
                                    fontWeight: FontWeight.w500),
                              ),
                              attendance: cubit.listAttendance == null ? Transform.scale(
                                scale: 0.5,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ): TrackingItem(
                                  cubit.listAttendance![index]
                                      [cubit.students!.indexOf(e)]),
                              submit: cubit.listSubmit == null ? Transform.scale(
                      scale: 0.5,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ) : TrackingItem(
                                  cubit.listSubmit![index]
                                      [cubit.students!.indexOf(e)],
                                  isSubmit: true),
                              note: cubit.listNote == null ? Transform.scale(
                                scale: 0.5,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ) : NoteWidget(cubit.listNote![index]
                                  [cubit.students!.indexOf(e)])))
                          .toList(),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
