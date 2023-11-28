import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/sensei_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_lesson_item.dart';
import 'expand_lesson_item.dart';
import 'lesson_item_row_layout.dart';
import 'lesson_tab_cubit.dart';

class ListLessonItem extends StatelessWidget {
  const ListLessonItem({super.key, required this.cubit, required this.role, required this.dataCubit});
  final LessonTabCubit cubit;
  final String role;
  final DataCubit dataCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Resizable.padding(context, 10)),
        ...cubit.listLessonInfo!.map((e) => Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 150),
                  vertical: Resizable.padding(context, 5)),
              child: BlocProvider(
                  create: (context) => DropdownCubit(),
                  child: BlocBuilder<DropdownCubit, int>(
                    builder: (c, state) => Stack(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 15),
                                vertical: Resizable.padding(context, 8)),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: Resizable.size(context, 1),
                                    color: state % 2 == 0
                                        ? greyColor.shade100
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 5))),
                            child: AnimatedCrossFade(
                                firstChild: CollapseLessonItem(
                                    cubit.listLessonInfo!.indexOf(e),
                                    e['title'],
                                    cubit: cubit),
                                secondChild: Column(
                                  children: [
                                    CollapseLessonItem(
                                        cubit.listLessonInfo!.indexOf(e),
                                        e['title'],
                                        cubit: cubit),
                                    if (cubit.listStatus![
                                            cubit.listLessonInfo!.indexOf(e)] !=
                                        "Pending")
                                      ExpandLessonItem(
                                          cubit.listLessonInfo!.indexOf(e),
                                          cubit: cubit, dataCubit: dataCubit, lessonId: e["id"],)
                                  ],
                                ),
                                crossFadeState: state % 2 == 1
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 100))),
                        if (role == "teacher")
                          Positioned.fill(
                              child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onDoubleTap: () {},
                                onTap: () async {
                                  if (cubit.listStatus![
                                          cubit.listLessonInfo!.indexOf(e)] ==
                                      "Pending") {
                                    await Navigator.pushNamed(c,
                                        "/teacher/lesson/class=${cubit.classModel!.classId}/lesson=${cubit.listLessonInfo![cubit.listLessonInfo!.indexOf(e)]['id']}");
                                  } else if (cubit.listStatus![
                                          cubit.listLessonInfo!.indexOf(e)] !=
                                      'Complete') {
                                    await Navigator.pushNamed(c,
                                        "/teacher/lesson/class=${cubit.classModel!.classId}/lesson=${cubit.listLessonInfo![cubit.listLessonInfo!.indexOf(e)]['id']}");
                                  } else {
                                    if (role == "teacher") {
                                      await Navigator.pushNamed(c,
                                          "/teacher/grading/class=${cubit.classModel!.classId}/type=btvn/lesson=${cubit.listLessonInfo![cubit.listLessonInfo!.indexOf(e)]['id']}");
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                    Resizable.size(context, 5))),
                          )),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 15),
                              vertical: Resizable.padding(context, 8)),
                          child: LessonItemRowLayout(
                              lesson: Container(),
                              name: Container(),
                              attend: Container(),
                              submit: Container(),
                              sensei: cubit.listTeacher![
                                          cubit.listLessonInfo!.indexOf(e)] ==
                                      null
                                  ? Container()
                                  : SenseiItem(e, cubit: cubit),
                              mark: Container(),
                              dropdown: cubit.listTeacher![
                                          cubit.listLessonInfo!.indexOf(e)] ==
                                      null
                                  ? Container()
                                  : IconButton(
                                      onPressed: () {
                                        BlocProvider.of<DropdownCubit>(c)
                                            .update();
                                      },
                                      splashRadius: Resizable.size(context, 15),
                                      icon: Icon(
                                        state % 2 == 0
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_up,
                                      ))),
                        )
                      ],
                    ),
                  )),
            ))
      ],
    );
  }
}
