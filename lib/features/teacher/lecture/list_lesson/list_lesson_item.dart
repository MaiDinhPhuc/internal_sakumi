import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/user_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_lesson_item.dart';
import 'expand_lesson_item.dart';
import 'lesson_item_row_layout.dart';
import 'lesson_tab_cubit.dart';

class ListLessonItem extends StatelessWidget {
  const ListLessonItem({super.key, required this.cubit, required this.role});
  final LessonTabCubit cubit;
  final String role;
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
                                          cubit: cubit)
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
                                  : Tooltip(
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 10)),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                              color: Colors.black,
                                              width:
                                                  Resizable.size(context, 1)),
                                          borderRadius: BorderRadius.circular(
                                              Resizable.padding(context, 5))),
                                      richMessage: WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      "${AppText.txtName.text}: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: Colors.white70
                                                          .withOpacity(0.5)),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: cubit
                                                            .listTeacher![cubit
                                                                .listLessonInfo!
                                                                .indexOf(e)]!
                                                            .name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                Resizable.font(
                                                                    context,
                                                                    18),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: Resizable.size(
                                                      context, 5)),
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      '${AppText.txtPhone.text}: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: Resizable.font(
                                                          context, 18),
                                                      color: Colors.white70
                                                          .withOpacity(0.5)),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: cubit
                                                            .listTeacher![cubit
                                                                .listLessonInfo!
                                                                .indexOf(e)]!
                                                            .phone,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                Resizable.font(
                                                                    context,
                                                                    18),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      child: SmallAvatar(cubit
                                          .listTeacher![
                                              cubit.listLessonInfo!.indexOf(e)]!
                                          .url),
                                    ),
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
