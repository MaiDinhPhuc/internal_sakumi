import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/attendance_item.dart';
import 'package:internal_sakumi/features/teacher/lecture_v2/session_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

import 'lesson_tab_cubit.dart';

void alertEditAttendance(BuildContext context, LessonTabCubit lessonCubit,
    SessionCubit sessionCubit, DataCubit dataCubit, int lessonId) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocBuilder<SessionCubit, int>(
            bloc: sessionCubit
              ..loadEdit(
                  lessonCubit.students, lessonCubit.listStdLesson, lessonId),
            builder: (cc, s) {
              return sessionCubit.listStudent == null ||
                      sessionCubit.listStudentLesson == null
                  ? Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 30),
                          horizontal: Resizable.padding(context, 100)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Resizable.padding(context, 20)),
                      ),
                      child: Scaffold(
                        body: Column(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: Resizable.padding(context, 20),
                                      left: Resizable.padding(context, 40)),
                                  child: Text(
                                    AppText.txtEditAttendance.text
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 25)),
                                  ),
                                )),
                            Expanded(
                                flex: 10,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...sessionCubit.listStudent!.map((e) =>
                                          AttendanceItem(
                                            e,
                                            sessionCubit
                                                .listStudentLesson!.where((ee) => ee.studentId == e.userId).toList().isEmpty
                                                ? 0
                                                : sessionCubit
                                                .listStudentLesson!.where((ee) => ee.studentId == e.userId).toList().first
                                                .timekeeping,
                                            items: [
                                              AppText.txtNotTimeKeeping.text,
                                              AppText.txtPresent.text,
                                              AppText.txtInLate.text,
                                              AppText.txtOutSoon.text,
                                              '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
                                              AppText.txtPermitted.text,
                                              AppText.txtAbsent.text,
                                            ],
                                            dataCubit: dataCubit,
                                            sessionCubit: sessionCubit,
                                            paddingLeft: 50,
                                            paddingRight: 50,
                                            classId:
                                                int.parse(TextUtils.getName()),
                                            lessonId: lessonId,
                                            time: sessionCubit.listStudent!
                                                .indexOf(e) >
                                                sessionCubit
                                                    .listStudentLesson!
                                                    .length -
                                                    1
                                                ? {}
                                                : sessionCubit
                                                .listStudentLesson![sessionCubit
                                                    .listStudent!
                                                    .indexOf(
                                                        e)] //cubit.listStudent!.indexOf(e)
                                                .time,
                                            hw: sessionCubit.listStudent!
                                                .indexOf(e) >
                                                sessionCubit
                                                    .listStudentLesson!
                                                    .length -
                                                    1
                                                ? -2
                                                :sessionCubit
                                                .listStudentLesson![sessionCubit
                                                    .listStudent!
                                                    .indexOf(
                                                        e)] //cubit.listStudent!.indexOf(e)
                                                .hw,
                                            supportNote:sessionCubit.listStudent!
                                                .indexOf(e) >
                                                sessionCubit
                                                    .listStudentLesson!
                                                    .length -
                                                    1
                                                ? ""
                                                : sessionCubit
                                                .listStudentLesson![sessionCubit
                                                    .listStudent!
                                                    .indexOf(
                                                        e)] //cubit.listStudent!.indexOf(e)
                                                .supportNote,
                                            teacherNote:sessionCubit.listStudent!
                                                .indexOf(e) >
                                                sessionCubit
                                                    .listStudentLesson!
                                                    .length -
                                                    1
                                                ? ""
                                                : sessionCubit
                                                .listStudentLesson![sessionCubit
                                                    .listStudent!
                                                    .indexOf(
                                                        e)] //cubit.listStudent!.indexOf(e)
                                                .teacherNote,
                                          )),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      margin: EdgeInsets.only(
                                          right:
                                              Resizable.padding(context, 20)),
                                      child: DialogButton(
                                          AppText.textCancel.text.toUpperCase(),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            dataCubit.updateSession();
                                          }),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
            });
      });
}
