import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/over_view/student_item_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/collapse_learned_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/overview/expand_learned_lesson_item.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'class_overview_cubit_v2.dart';

class ExpandedOverViewStudentV2 extends StatelessWidget {
  const ExpandedOverViewStudentV2(
      {Key? key,
      required this.stdClass,
      required this.cubit,
      required this.studentCubit})
      : super(key: key);
  final StudentClassModel stdClass;
  final ClassOverViewCubitV2 cubit;
  final StudentItemOverViewCubit studentCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Resizable.size(context, 0.5),
          width: double.maxFinite,
          color: const Color(0xffE0E0E0),
        ),
        SizedBox(height: Resizable.size(context, 20)),
        if (studentCubit.stdLessons!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
                left: Resizable.padding(context, 50),
                right: Resizable.padding(context, 50),
                bottom: Resizable.padding(context, 10)),
            child: Row(
              children: [
                Expanded(flex: 6, child: Container()),
                Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Expanded(flex: 8, child: Container()),
                        Expanded(
                            flex: 3,
                            child: Text(AppText.txtDoingTime.text,
                                style: TextStyle(
                                    color: const Color(0xff757575),
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17)))),
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 2,
                            child: Text(AppText.txtIgnore.text,
                                style: TextStyle(
                                    color: const Color(0xff757575),
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17)))),
                        Expanded(flex: 1, child: Container())
                      ],
                    ))
              ],
            ),
          ),
        ...studentCubit.stdLessons!.map((e) => BlocProvider(
            create: (context) => DropdownCubit(),
            child: BlocBuilder<DropdownCubit, int>(
              builder: (c, state) => Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 25),
                      right: Resizable.padding(context, 32),
                      bottom: Resizable.padding(context, 10)),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 15),
                      vertical: Resizable.padding(context, 5)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: Resizable.size(context, 0.5),
                          color: state % 2 == 0
                              ? greyColor.shade100
                              : Colors.black),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  child: AnimatedCrossFade(
                      firstChild: CollapseLearnedLesson(
                          studentCubit.getTitle(e.lessonId),
                          studentCubit.getAttendance(e.lessonId),
                          studentCubit.getHw(e.lessonId),
                          studentCubit.getTime(e.lessonId, "time_btvn"),
                          studentCubit.getNumber(e.lessonId,"skip_btvn"),
                          studentCubit.checkCustom(e.lessonId)),
                      secondChild: Column(
                        children: [
                          CollapseLearnedLesson(
                              studentCubit.getTitle(e.lessonId),
                              studentCubit.getAttendance(e.lessonId),
                              studentCubit.getHw(e.lessonId),
                              studentCubit.getTime(e.lessonId,"time_btvn"),
                              studentCubit.getNumber(e.lessonId,"skip_btvn"),
                              studentCubit.checkCustom(e.lessonId)),
                          ExpandLearnedLesson(
                              studentCubit.getSpNote(e.lessonId),
                              studentCubit.getTeacherNote(e.lessonId),
                              studentCubit.getNumber(e.lessonId,"flip_flashcard"),
                              studentCubit.getTime(e.lessonId,"time_reading"),
                              studentCubit.getTime(e.lessonId,"time_listening"),
                              studentCubit.getTime(e.lessonId,"time_kanji"),
                              studentCubit.getTime(e.lessonId,"time_grammar"),
                              studentCubit.getTime(e.lessonId,"time_alphabet"),
                              studentCubit.getTime(e.lessonId,"time_vocabulary"),
                              studentCubit.getTime(e.lessonId,"time_flashcard"))
                        ],
                      ),
                      crossFadeState: state % 2 == 1
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 100))),
            )))
      ],
    );
  }
}
