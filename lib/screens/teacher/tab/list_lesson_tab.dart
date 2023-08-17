import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/collapse_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/expand_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';

class ListLessonTab extends StatelessWidget {
  final String name;
  final String classId;

  const ListLessonTab(this.name, this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('================> ListLessonTab');
    return BlocProvider(
        create: (context) => ListLessonCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                  index: 1,
                  classId: TextUtils.getName(position: 2),
                  name: name),
              BlocBuilder<ListLessonCubit, int>(
                  //bloc: ListLessonCubit()..init(context),
                  builder: (c, s) {
                var cubit = BlocProvider.of<ListLessonCubit>(c);
                return cubit.classModel == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        key: Key('aa ${cubit.listLessonResult?.first.status}'),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 20)),
                                child: Text(
                                    '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 30))),
                              ),
                              cubit.lessons == null
                                  ? Transform.scale(
                                      scale: 0.75,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        // TextButton(
                                        //     onPressed: () async {
                                        //       // debugPrint('==============>>>>>>>>>>> ${cubit
                                        //       //     .listStudentLessons!
                                        //       //     .length +
                                        //       // 1}');
                                        //       for (var i in cubit.lessons!) {
                                        //         await addStudentLesson(
                                        //             context,
                                        //             StudentLessonModel(
                                        //                 grammar: -2,
                                        //                 hw: -2,
                                        //                 id: cubit
                                        //                     .lessons!
                                        //                     .indexOf(i)+4,
                                        //                 classId: 2,
                                        //                 kanji: -2,
                                        //                 lessonId: cubit
                                        //                     .lessons![cubit
                                        //                         .lessons!
                                        //                         .indexOf(i)]
                                        //                     .lessonId,
                                        //                 listening: -2,
                                        //                 studentId: 5,
                                        //                 timekeeping: 0,
                                        //                 vocabulary: -2,
                                        //                 teacherNote:
                                        //                     'teacherNote'));
                                        //         if(context.mounted) {
                                        //           await addLessonResult(
                                        //               context, LessonResultModel(id: 1000-2+cubit
                                        //               .lessons!
                                        //               .indexOf(i)+1, classId: 2, lessonId: cubit
                                        //               .lessons![cubit
                                        //               .lessons!
                                        //               .indexOf(i)]
                                        //               .lessonId, teacherId: 4, status: 'Teaching', date: DateFormat(
                                        //               'dd/MM/yyyy')
                                        //               .format(DateTime
                                        //               .now()), noteForStudent: 'noteForStudent', noteForSupport: 'noteForSupport', noteForTeacher: 'noteForTeacher'));
                                        //         }
                                        //       }
                                        //     },
                                        //     child: Text('ADD')),
                                        ...cubit.lessons!.map((e) => Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: Resizable.padding(
                                                      context, 150),
                                                  vertical: Resizable.padding(
                                                      context, 5)),
                                              child: BlocProvider(
                                                  create: (context) =>
                                                      DropdownCubit(),
                                                  child: BlocBuilder<
                                                      DropdownCubit, int>(
                                                    builder: (c, state) =>
                                                        Stack(
                                                      children: [
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Resizable.padding(
                                                                        context, 20),
                                                                vertical:
                                                                    Resizable.padding(
                                                                        context, 8)),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: Resizable.size(
                                                                        context, 1),
                                                                    color: state % 2 == 0
                                                                        ? greyColor
                                                                            .shade100
                                                                        : Colors
                                                                            .black),
                                                                borderRadius:
                                                                    BorderRadius.circular(Resizable.size(context, 5))),
                                                            child: cubit.lessons == null || cubit.lessons!.isEmpty
                                                                ? Transform.scale(
                                                                    scale: 0.75,
                                                                    child:
                                                                        const CircularProgressIndicator(),
                                                                  )
                                                                : AnimatedCrossFade(
                                                                    firstChild: CollapseLessonItem(cubit.lessons!.indexOf(e), e.title),
                                                                    secondChild: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CollapseLessonItem(
                                                                            cubit.lessons!.indexOf(e),
                                                                            e.title),
                                                                        ExpandLessonItem(cubit
                                                                            .lessons!
                                                                            .indexOf(e)),
                                                                      ],
                                                                    ),
                                                                    crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                    duration: const Duration(milliseconds: 100))),
                                                        Positioned.fill(
                                                            child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                              onTap: cubit.lessons!
                                                                          .indexOf(
                                                                              e) >
                                                                      cubit.listLessonResult!
                                                                              .length -
                                                                          1
                                                                  ? () async {
                                                                      debugPrint(
                                                                          '================> ooooooo ${cubit.classModel!.classId} == ${e.lessonId}');
                                                                      await Navigator
                                                                          .pushNamed(
                                                                              c,
                                                                              "/teacher?name=$name/lesson/class?id=${cubit.classModel!.classId}/lesson?id=${e.lessonId}");
                                                                      if (c
                                                                          .mounted) {
                                                                        await cubit
                                                                            .loadLessonResult(c);
                                                                      }
                                                                    }
                                                                  : (cubit.listLessonResult![cubit.lessons!.indexOf(e)].status !=
                                                                          'Complete')
                                                                      ? () async {
                                                                          debugPrint(
                                                                              '================> ooooooo ${cubit.classModel!.classId} == ${e.lessonId}');
                                                                          await Navigator.pushNamed(
                                                                              c,
                                                                              "/teacher?name=$name/lesson/class?id=${cubit.classModel!.classId}/lesson?id=${e.lessonId}");
                                                                          if (c
                                                                              .mounted) {
                                                                            await cubit.init(c);
                                                                          }
                                                                        }
                                                                      : () {
                                                                          //TODO navigate to detail grading
                                                                        },
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Resizable.size(
                                                                          context,
                                                                          5))),
                                                        )),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              right: Resizable
                                                                  .padding(
                                                                      context,
                                                                      10),
                                                              top: Resizable
                                                                  .padding(
                                                                      context,
                                                                      8)),
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                // cubit
                                                                //     .loadStudent(
                                                                //         c);
                                                                BlocProvider.of<
                                                                        DropdownCubit>(c)
                                                                    .update();
                                                              },
                                                              splashRadius:
                                                                  Resizable.size(
                                                                      context,
                                                                      15),
                                                              icon: Icon(
                                                                state % 2 == 0
                                                                    ? Icons
                                                                        .keyboard_arrow_down
                                                                    : Icons
                                                                        .keyboard_arrow_up,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            )),
                                        SizedBox(
                                            height: Resizable.size(context, 50))
                                      ],
                                    )
                            ],
                          ),
                        ));
              }),
            ],
          ),
        ));
  }
}
