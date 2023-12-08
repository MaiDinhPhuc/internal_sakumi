import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_edit_attendance.dart';
import 'input_sp_note_for_ss.dart';

class ExpandLessonItem extends StatelessWidget {
  final int index;
  final LessonTabCubit cubit;
  final DataCubit dataCubit;
  final int lessonId;
  final SessionCubit sessionCubit;
  ExpandLessonItem(this.index, {Key? key, required this.cubit, required this.dataCubit, required this.lessonId})
      : sessionCubit = SessionCubit(), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cubit.listSpNote![index]! != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteTeacherForSp.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                NoteWidget(cubit.listSpNote![index]!)
              ],
            ),
          if (cubit.listTeacherNote![index]! != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteTeacherForAnotherSs.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                NoteWidget(cubit.listTeacherNote![index]!),
              ],
            ),
          if (cubit.role == "admin")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteSpForTeacher.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                InputSpNoteForSS(
                    sendNote: ()async {
                      waitingDialog(context);
                      dataCubit.updateNoteInLessonResultsToFb(cubit.classId!, lessonId);
                      await Future.delayed(const Duration(seconds: 1), (){
                        Navigator.pop(context);
                      });
                    },
                    value: cubit.listSpNoteForTeacher![index]!,
                    onChange: (value) {
                      dataCubit.updateNoteInLessonResults(cubit.classId!, lessonId, value!);
                    })
              ],
            ),
          Container(
            height: Resizable.size(context, 1),
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
            color: const Color(0xffD9D9D9),
          ),
          Stack(
            children: [
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
              TrackStudentItemRowLayout(
                  name: Container(),
                  attendance: Container(),
                  submit: Container(),
                  note: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: Resizable.size(context, 15),
                        child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          splashRadius: Resizable.size(context, 15),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black, // Set the desired border color here
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Resizable.size(context, 5)),
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                alertEditAttendance(context,cubit ,sessionCubit, dataCubit, lessonId);
                                //waitingDialog(context);
                              },
                              padding: EdgeInsets.zero,
                              child: Center(
                                  child: Text(AppText.txtEditAttendance.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Resizable.font(context, 20),
                                          color: const Color(0xffB71C1C)))),
                            )
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      )
                    ],
                  )),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0;
                    i < cubit.listDetailLesson![index]!['names'].length;
                    i++)
                  TrackStudentItemRowLayout(
                      name: Text(
                        cubit.listDetailLesson![index]!['names'][i],
                        style: TextStyle(
                            fontSize: Resizable.font(context, 20),
                            fontWeight: FontWeight.w500),
                      ),
                      attendance: TrackingItem(
                          cubit.listDetailLesson![index]!['attendance'][i]),
                      submit: TrackingItem(
                          cubit.listDetailLesson![index]!['hw'][i],
                          isSubmit: true),
                      note: NoteWidget(
                          cubit.listDetailLesson![index]!['note'][i]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
