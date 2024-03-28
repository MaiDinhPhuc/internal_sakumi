import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/class_info/lesson/sensei_item_v2.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'choose_custom_lesson.dart';
import 'collapse_lesson_item_v2.dart';
import 'lesson_item_cubit_v2.dart';
import 'expand_lesson_item_v2.dart';
import 'list_lesson_cubit_v2.dart';

class LessonItemV2 extends StatelessWidget {
  LessonItemV2(
      {Key? key, required this.cubit, required this.role, required this.lesson})
      : detailCubit = LessonItemCubitV2(cubit, lesson),
        super(key: key);
  final ListLessonCubitV2 cubit;
  final LessonItemCubitV2 detailCubit;
  final LessonModel lesson;
  final String role;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonItemCubitV2, int>(
        bloc: detailCubit,
        builder: (c, s) {
          return Column(
            children: [
              SizedBox(height: Resizable.padding(context, 10)),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 100),
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
                                  firstChild: CollapseLessonItemV2(
                                      cubit: detailCubit,
                                      index: cubit.lessons!.indexOf(lesson),
                                      role: role),
                                  secondChild: Column(
                                    children: [
                                      CollapseLessonItemV2(
                                          cubit: detailCubit,
                                          index: cubit.lessons!.indexOf(lesson),
                                          role: role),
                                      detailCubit.lessonResult == null
                                          ? const CircularProgressIndicator()
                                          : detailCubit.lessonResult!.status !=
                                                  "Pending"
                                              ? ExpandLessonItemV2(
                                                  detailCubit: detailCubit,
                                                  role: role,
                                                  cubit: cubit)
                                              : Container()
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
                                  onTap: () async {
                                    if (detailCubit.lessonResult == null ||
                                        detailCubit.lessonResult!.status !=
                                            "Complete") {
                                      await Navigator.pushNamed(c,
                                          "/teacher/lesson/class=${cubit.classId}/lesson=${lesson.lessonId}");
                                    } else {
                                      if (detailCubit.lesson.isCustom) {
                                        if (detailCubit.lesson.customLessonInfo
                                                .length ==
                                            1) {
                                          await Navigator.pushNamed(c,
                                              "/teacher/grading/class=${cubit.classId}/type=btvn/customLesson=${lesson.lessonId}/lesson=${detailCubit.lesson.customLessonInfo.first['lesson_id']}");
                                        } else {
                                          selectionCustomLessonDialog(
                                              c,
                                              detailCubit
                                                  .lesson.customLessonInfo,
                                              cubit.classId,
                                              lesson.lessonId);
                                        }
                                      } else {
                                        await Navigator.pushNamed(c,
                                            "/teacher/grading/class=${cubit.classId}/type=btvn/lesson=${lesson.lessonId}");
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
                                sensei: SizedBox(
                                    height: Resizable.size(context, 32),
                                    width: Resizable.size(context, 32),
                                    child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () async {
                                    if (role == "admin" && detailCubit.teacher != null) {
                                      await Navigator.pushNamed(context,
                                          "${Routes.admin}/teacherInfo/teacher=${detailCubit.teacher!.userId}");
                                    }
                                  },
                                  child: detailCubit.lessonResult == null
                                      ? Align(
                                      alignment: Alignment.center,
                                      child: Opacity(
                                          opacity: 0,
                                          child: CircleProgress(
                                              title: '0 %',
                                              lineWidth:
                                              Resizable.size(context, 3),
                                              percent: 0,
                                              radius:
                                              Resizable.size(context, 16),
                                              fontSize: Resizable.font(
                                                  context, 14))))
                                      : SenseiItemV2(cubit: detailCubit),
                                )),
                                mark: Container(),
                                dropdown: detailCubit.lessonResult == null
                                    ? Container()
                                    : IconButton(
                                        onPressed: () {
                                          BlocProvider.of<DropdownCubit>(c)
                                              .update();
                                        },
                                        splashRadius:
                                            Resizable.size(context, 15),
                                        icon: Icon(
                                          state % 2 == 0
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_up,
                                        ))),
                          )
                        ],
                      ),
                    )),
              )
            ],
          );
        });
  }
}
