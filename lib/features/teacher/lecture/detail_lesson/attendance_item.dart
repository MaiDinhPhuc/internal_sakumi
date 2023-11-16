import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/session_cubit.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'drop_down_widget.dart';

class AttendanceItem extends StatelessWidget {
  final StudentModel studentModel;
  final int attendId;
  final List<String> items;
  const AttendanceItem(this.studentModel, this.attendId,
      {required this.items, Key? key, required this.dataCubit, required this.sessionCubit})
      : super(key: key);
  final DataCubit dataCubit;
  final SessionCubit sessionCubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownAttendanceCubit(attendId),
        child: BlocBuilder<DropdownAttendanceCubit, int>(
            builder: (c, s) => Container(
                  margin: EdgeInsets.only(
                      bottom: Resizable.padding(context, 10),
                      right: Resizable.padding(context, 150),
                      left: Resizable.padding(context, 150)),
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20),
                      vertical: Resizable.padding(context, 8)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: Resizable.size(context, 1),
                          color: greyColor.shade100),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 3,
                          child: Text(
                            studentModel.name,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20)),
                          )),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                  flex: 2,
                                  child: DropDownWidget(
                                      studentModel.userId,
                                      selectorId: s,
                                      items: items,
                                    onPressed: (v) async {
                                      await addStudentLesson(
                                          StudentLessonModel(
                                              grammar: -2,
                                              hw: -2,
                                              id: 10000,
                                              classId:
                                              int.parse(TextUtils.getName(position: 1)),
                                              kanji: -2,
                                              lessonId: int.parse(TextUtils.getName()),
                                              listening: -2,
                                              studentId: studentModel.userId,
                                              timekeeping: 0,
                                              vocabulary: -2,
                                              teacherNote: '', supportNote: '', doingTime: ''));
                                      dataCubit.updateStudentLesson(int.parse(TextUtils.getName(position: 1)),StudentLessonModel(
                                          grammar: -2,
                                          hw: -2,
                                          id: 10000,
                                          classId:
                                          int.parse(TextUtils.getName(position: 1)),
                                          kanji: -2,
                                          lessonId: int.parse(TextUtils.getName()),
                                          listening: -2,
                                          studentId: studentModel.userId,
                                          timekeeping: 0,
                                          vocabulary: -2,
                                          teacherNote: '', supportNote: '', doingTime: ''));
                                      s = items.indexOf(v.toString());
                                      if (c.mounted) {
                                        BlocProvider.of<DropdownAttendanceCubit>(c)
                                            .updateAttendance(items.indexOf(v.toString()), studentModel.userId, c);
                                        dataCubit.updateStudentLesson(int.parse(TextUtils.getName(position: 1)),StudentLessonModel(
                                            grammar: -2,
                                            hw: -2,
                                            id: 10000,
                                            classId:
                                            int.parse(TextUtils.getName(position: 1)),
                                            kanji: -2,
                                            lessonId: int.parse(TextUtils.getName()),
                                            listening: -2,
                                            studentId: studentModel.userId,
                                            timekeeping: items.indexOf(v.toString()),
                                            vocabulary: -2,
                                            teacherNote: '', supportNote: '', doingTime: ''));
                                      }
                                      if (items.length == 7 && c.mounted) {
                                        sessionCubit.updateTimekeeping(s);
                                      }
                                    },
                                  ))
                            ],
                          )),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                )));
  }
  addStudentLesson(StudentLessonModel model) async {
    var check = await FireBaseProvider.instance.addStudentLesson(model);

    debugPrint('===================> check addStudentLesson $check');
  }
}

