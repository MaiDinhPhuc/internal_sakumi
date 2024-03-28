import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_cubit.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_sub_course_item.dart';
import 'detail_sub_course_item_cubit.dart';
import 'expand_sub_course_item.dart';

class SubCourseItemView extends StatelessWidget {
  SubCourseItemView(
      {super.key,
      required this.lesson,
      required this.cubit,
      required this.index, required this.role})
      : detailCubit = DetailSubCourseItemCubit(lesson, cubit), dropDownCubit = DropdownCubit();

  final int index;
  final LessonModel lesson;
  final SubCourseCubit cubit;
  final DetailSubCourseItemCubit detailCubit;
  final DropdownCubit dropDownCubit;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailSubCourseItemCubit, int>(
        bloc: detailCubit,
        builder: (cc, s) {
          return Column(
            children: [
              SizedBox(height: Resizable.padding(context, 10)),
              BlocBuilder<DropdownCubit, int>(
                bloc: dropDownCubit,
                builder: (c, state) => Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      //horizontal: Resizable.padding(context, 15),
                        vertical: Resizable.padding(context, 5)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(context, 1),
                            color: state % 2 == 0
                                ? greyColor.shade100
                                : Colors.black),
                        borderRadius: BorderRadius.circular(
                            Resizable.size(context, 5))),
                    child: AnimatedCrossFade(
                        firstChild: CollapseSubCourseItem(
                          lesson: lesson,
                          index: index, dropDown: IconButton(
                            onPressed: () {
                              dropDownCubit.update();
                            },
                            splashRadius: Resizable.size(context, 15),
                            icon: Icon(
                              state % 2 == 0
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                            )),
                        ),
                        secondChild: Column(
                          children: [
                            CollapseSubCourseItem(
                              lesson: lesson,
                              index: index, dropDown: IconButton(
                                onPressed: () {
                                  dropDownCubit.update();
                                },
                                splashRadius: Resizable.size(context, 15),
                                icon: Icon(
                                  state % 2 == 0
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                )),
                            ),
                            ExpandSubCourseItem(
                                detailCubit: detailCubit,
                                lesson: lesson, role: role)
                          ],
                        ),
                        crossFadeState: state % 2 == 1
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 100))),
              )
            ],
          );
        });
  }
}
