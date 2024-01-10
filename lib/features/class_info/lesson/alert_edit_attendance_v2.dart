import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';

import 'attendance_item_v2.dart';
import 'lesson_item_cubit_v2.dart';
import 'list_lesson_cubit_v2.dart';

void alertEditAttendanceV2(BuildContext context, LessonItemCubitV2 detailCubit,
    ListLessonCubitV2 cubit, SessionCubit sessionCubit) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocBuilder<SessionCubit, int>(
            bloc: sessionCubit
              ..loadEdit(
                  detailCubit.getStudents(), detailCubit.stdLessons, detailCubit.lesson.lessonId),
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
                                      ...sessionCubit.listStudent!
                                          .map((e) => AttendanceItemV2(
                                                e,
                                                sessionCubit.listStudentLesson!
                                                        .where((ee) =>
                                                            ee.studentId ==
                                                            e.userId)
                                                        .toList()
                                                        .isEmpty
                                                    ? 0
                                                    : sessionCubit
                                                        .listStudentLesson!
                                                        .where((ee) =>
                                                            ee.studentId ==
                                                            e.userId)
                                                        .toList()
                                                        .first
                                                        .timekeeping,
                                                items: [
                                                  AppText
                                                      .txtNotTimeKeeping.text,
                                                  AppText.txtPresent.text,
                                                  AppText.txtInLate.text,
                                                  AppText.txtOutSoon.text,
                                                  '${AppText.txtInLate.text} + ${AppText.txtOutSoon.text}',
                                                  AppText.txtPermitted.text,
                                                  AppText.txtAbsent.text,
                                                ],
                                                sessionCubit: sessionCubit,
                                                paddingLeft: 50,
                                                paddingRight: 50,
                                                stdLesson: sessionCubit
                                                            .listStudent!
                                                            .indexOf(e) >
                                                        sessionCubit
                                                                .listStudentLesson!
                                                                .length -
                                                            1
                                                    ? StudentLessonModel(
                                                        grammar: -2,
                                                        hw: -2,
                                                        id: 10000,
                                                        classId: cubit.classId,
                                                        kanji: -2,
                                                        lessonId: detailCubit
                                                            .lesson.lessonId,
                                                        listening: -2,
                                                        studentId: e.userId,
                                                        timekeeping: 0,
                                                        vocabulary: -2,
                                                        teacherNote: '',
                                                        supportNote: '',
                                                        time: {})
                                                    : detailCubit.stdLessons!
                                                        .firstWhere((ee) =>
                                                            ee.studentId ==
                                                            e.userId),
                                                detailCubit: detailCubit,
                                                cubit: cubit,
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
