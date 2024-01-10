import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/drop_down_widget.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_lesson_cubit_v2.dart';

class AttendanceItemTeacher extends StatelessWidget {
  final StudentModel studentModel;
  final int attendId;
  final List<String> items;
  const AttendanceItemTeacher(this.studentModel, this.attendId,
      {required this.items,
        this.paddingLeft = 150,
        this.paddingRight = 150,
        Key? key,
    required this.cubit})
      : super(key: key);
  final double paddingLeft;
  final double paddingRight;
  final DetailLessonCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownAttendanceCubit(attendId),
        child: BlocBuilder<DropdownAttendanceCubit, int>(
            builder: (c, s) => Container(
              margin: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, paddingRight),
                  left: Resizable.padding(context, paddingLeft)),
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
                                  var check = await addStudentLesson(
                                      StudentLessonModel(
                                          grammar: -2,
                                          hw: -2,
                                          id: 10000,
                                          classId: cubit.classId,
                                          kanji: -2,
                                          lessonId: cubit.lessonId,
                                          listening: -2,
                                          studentId: studentModel.userId,
                                          timekeeping: items
                                              .indexOf(v.toString()),
                                          vocabulary: -2,
                                          teacherNote: '',
                                          supportNote: '',
                                          time: {}));
                                  if (check == false) {
                                    if (c.mounted) {
                                      BlocProvider.of<
                                          DropdownAttendanceCubit>(c)
                                          .updateAttendance(
                                          items.indexOf(v.toString()),
                                          studentModel.userId,
                                          cubit.classId,
                                          cubit.lessonId,
                                          c);

                                      List<StudentLessonModel> list = [];

                                      for(var i in cubit.stdLessons!){
                                        if(i.lessonId == cubit.lessonId && i.studentId == studentModel.userId){
                                          list.add(StudentLessonModel(
                                              grammar: -2,
                                              hw: i.hw,
                                              id: 10000,
                                              classId: cubit.classId,
                                              kanji: -2,
                                              lessonId: cubit.lessonId,
                                              listening: -2,
                                              studentId:
                                              studentModel.userId,
                                              timekeeping: items
                                                  .indexOf(v.toString()),
                                              vocabulary: -2,
                                              teacherNote: i.teacherNote,
                                              supportNote: i.supportNote,
                                              time: i.time));
                                        }else{
                                          list.add(i);
                                        }
                                      }

                                      DataProvider.updateStdLesson(cubit.classId, list);
                                    }
                                  } else {
                                    DataProvider.addNewStdLesson(cubit.classId, StudentLessonModel(
                                        grammar: -2,
                                        hw: -2,
                                        id: 10000,
                                        classId: cubit.classId,
                                        kanji: -2,
                                        lessonId: cubit.lessonId,
                                        listening: -2,
                                        studentId: studentModel.userId,
                                        timekeeping: items.indexOf(v.toString()),
                                        vocabulary: -2,
                                        teacherNote: '',
                                        supportNote: '',
                                        time: {}));
                                  }
                                  if (items.length == 7 && c.mounted) {
                                    cubit.updateTimekeeping(items.indexOf(v.toString()));
                                  }
                                  cubit.updateDataAttendance();
                                  BlocProvider.of<
                                      DropdownAttendanceCubit>(c)
                                      .updateUI(items.indexOf(v.toString()));
                                },
                              ))
                        ],
                      )),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            )));
  }

  Future<bool> addStudentLesson(StudentLessonModel model) async {
    var check = await FireBaseProvider.instance.addStudentLesson(model);

    debugPrint('===================> check addStudentLesson $check');

    return check;
  }
}