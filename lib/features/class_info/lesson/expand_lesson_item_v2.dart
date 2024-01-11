import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/session_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/input_sp_note_for_ss.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_edit_attendance_v2.dart';
import 'lesson_item_cubit_v2.dart';
import 'list_lesson_cubit_v2.dart';

class ExpandLessonItemV2 extends StatelessWidget {
  ExpandLessonItemV2(
      {super.key,
      required this.detailCubit,
      required this.role,
      required this.cubit})
      : sessionCubit = SessionCubit();
  final LessonItemCubitV2 detailCubit;
  final ListLessonCubitV2 cubit;
  final String role;
  final SessionCubit sessionCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detailCubit.lessonResult!.noteForSupport != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteTeacherForSp.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                NoteWidget(detailCubit.lessonResult!.noteForSupport!)
              ],
            ),
          if (detailCubit.lessonResult!.noteForTeacher != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteTeacherForAnotherSs.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                NoteWidget(detailCubit.lessonResult!.noteForTeacher!),
              ],
            ),
          if (role == "admin")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.txtNoteSpForTeacher.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 19))),
                InputSpNoteForSS(
                    sendNote: () async {
                      waitingDialog(context);

                      List<LessonResultModel> list = [];

                      for (var i in cubit.lessonResults!) {
                        if (i.lessonId != detailCubit.lesson.lessonId) {
                          list.add(i);
                        } else {
                          list.add(detailCubit.lessonResult!);
                        }
                      }
                      DataProvider.updateLessonResult(cubit.classId, list);
                      await FireBaseProvider.instance.updateLessonResult(
                          detailCubit.lesson.lessonId,
                          cubit.classId,
                          detailCubit.lessonResult!.supportNoteForTeacher!);
                      await Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    },
                    value: detailCubit.lessonResult!.supportNoteForTeacher!,
                    onChange: (value) {
                      detailCubit.updateNote(value!);
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
              if (role == "admin")
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
                                color: Colors
                                    .black, // Set the desired border color here
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Resizable.size(context, 5)),
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  alertEditAttendanceV2(context, detailCubit,
                                      cubit, sessionCubit);
                                  //alertEditAttendanceV2(context,detailCubit ,cubit,sessionCubit );
                                  //waitingDialog(context);
                                },
                                padding: EdgeInsets.zero,
                                child: Center(
                                    child: Text(AppText.txtEditAttendance.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 20),
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
            child: detailCubit.getStudents().isEmpty
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...detailCubit.getStudents().map((e) =>
                          TrackStudentItemRowLayout(
                              name: Text(
                                e.name,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 20),
                                    fontWeight: FontWeight.w500),
                              ),
                              attendance: TrackingItem(
                                  detailCubit.getStudentLesson(e.userId).isEmpty
                                      ? null
                                      : detailCubit
                                          .getStudentLesson(e.userId)
                                          .first
                                          .timekeeping),
                              submit: TrackingItem(
                                  detailCubit.lesson.btvn == 0
                                      ? null
                                      : detailCubit
                                              .getStudentLesson(e.userId)
                                              .isEmpty
                                          ? -2
                                          : detailCubit
                                              .getStudentLesson(e.userId)
                                              .first
                                              .hw,
                                  isSubmit: true),
                              note: NoteWidget(
                                  detailCubit.getStudentLesson(e.userId).isEmpty
                                      ? ""
                                      : detailCubit
                                          .getStudentLesson(e.userId)
                                          .first
                                          .teacherNote)))
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
