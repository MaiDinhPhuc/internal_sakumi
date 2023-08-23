import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/user_item.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/collapse_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/expand_lesson_item.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ListLessonTab extends StatelessWidget {
  final String name;
  final String classId;

  const ListLessonTab(this.name, this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LessonTabCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                  index: 1,
                  classId: TextUtils.getName(position: 2),
                  name: name),
              BlocBuilder<LessonTabCubit, int>(builder: (c, s) {
                var cubit = BlocProvider.of<LessonTabCubit>(c);
                return cubit.classModel == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        key: Key('aa'),
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
                              cubit.lessons == null ||
                                      cubit.listLessonResult == null
                                  ? Transform.scale(
                                      scale: 0.75,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 20)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 150)),
                                            child: LessonItemRowLayout(
                                                lesson: Text(
                                                    AppText.subjectLesson.text,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff757575),
                                                        fontSize: Resizable.font(
                                                            context, 17))),
                                                name:
                                                    Text(AppText.titleSubject.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                sensei: Text(AppText.txtSensei.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                attend: Text(AppText.txtRateOfAttendance.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                submit: Text(AppText.txtRateOfSubmitHomework.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                mark: Text(AppText.titleStatus.text, style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0xff757575), fontSize: Resizable.font(context, 17))),
                                                dropdown: Container())),
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
                                                                        context, 15),
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
                                                                      children: [
                                                                        CollapseLessonItem(
                                                                            cubit.lessons!.indexOf(e),
                                                                            e.title),
                                                                        ExpandLessonItem(cubit
                                                                            .lessons!
                                                                            .indexOf(e))
                                                                      ],
                                                                    ),
                                                                    crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                    duration: const Duration(milliseconds: 100))),
                                                        Positioned.fill(
                                                            child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                              onDoubleTap:
                                                                  () {},
                                                              onTap: () async {
                                                                debugPrint(
                                                                    '===========> 000000 ${cubit.lessons!.indexOf(e)} == ${cubit.listLessonResult!.length - 1}');
                                                                if (cubit
                                                                        .lessons!
                                                                        .indexOf(
                                                                            e) >
                                                                    cubit.listLessonResult!
                                                                            .length -
                                                                        1) {
                                                                  Navigator
                                                                      .pushNamed(
                                                                          c,
                                                                          "/teacher?name=$name/lesson/class?id=${cubit.classModel!.classId}/lesson?id=${e.lessonId}");
                                                                } else if (cubit
                                                                        .listLessonResult![cubit
                                                                            .lessons!
                                                                            .indexOf(e)]!
                                                                        .status !=
                                                                    'Complete') {
                                                                Navigator
                                                                      .pushNamed(
                                                                          c,
                                                                          "/teacher?name=$name/lesson/class?id=${cubit.classModel!.classId}/lesson?id=${e.lessonId}");
                                                                } else {
                                                                  Navigator
                                                                      .pushNamed(
                                                                      c,
                                                                      "/teacher?name=$name/grading/class?id=${cubit.classModel!.classId}/lesson?id=${e.lessonId}");
                                                                }
                                                                await cubit
                                                                    .loadLessonResult(
                                                                    context);
                                                                if (c
                                                                    .mounted) {
                                                                  await cubit
                                                                      .loadStatistic(
                                                                      c);
                                                                }
                                                              },
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Resizable.size(
                                                                          context,
                                                                          5))),
                                                        )),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                              Resizable.padding(
                                                                  context, 15),
                                                              vertical:
                                                              Resizable.padding(
                                                                  context, 8)),
                                                          child: LessonItemRowLayout(
                                                              lesson: Container(),
                                                              name: Container(),
                                                              attend: Container(),
                                                              submit: Container(),
                                                              sensei: cubit
                                                                  .infoTeachers ==
                                                                  null
                                                                  ? Transform
                                                                  .scale(
                                                                scale: 0.75,
                                                                child:
                                                                const Center(
                                                                  child:
                                                                  CircularProgressIndicator(),
                                                                ),
                                                              )
                                                                  : cubit.infoTeachers![cubit.lessons!.indexOf(e)] ==
                                                                  null
                                                                  ? Container()
                                                                  : Tooltip(
                                                                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black,
                                                                  border: Border.all(color: Colors.black, width: Resizable.size(context, 1)),
                                                                  borderRadius: BorderRadius.circular(Resizable.padding(context, 5))
                                                                ),
                                                                richMessage: WidgetSpan(
                                                                    alignment: PlaceholderAlignment.baseline,
                                                                    baseline: TextBaseline.alphabetic,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        RichText(
                                                                          text: TextSpan(
                                                                            text: "${AppText.txtName.text}: ",
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.w600,
                                                                                fontSize:
                                                                                Resizable.font(
                                                                                    context, 18),
                                                                                color: Colors.white70.withOpacity(0.5)),
                                                                            children: <TextSpan>[
                                                                              TextSpan(text: cubit
                                                                                  .infoTeachers![cubit
                                                                                  .lessons!
                                                                                  .indexOf(
                                                                                  e)]!.name, style: TextStyle(color: Colors.white,
                                                                                  fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: Resizable.size(context, 5)),
                                                                        RichText(
                                                                          text: TextSpan(
                                                                            text: '${AppText.txtPhone.text}: ',
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.w600,
                                                                                fontSize:
                                                                                Resizable.font(
                                                                                    context, 18),
                                                                                color: Colors.white70.withOpacity(0.5)),
                                                                            children: <TextSpan>[
                                                                              TextSpan(text: cubit
                                                                                  .infoTeachers![cubit
                                                                                  .lessons!
                                                                                  .indexOf(
                                                                                  e)]!.phone, style: TextStyle(color: Colors.white,
                                                                                  fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                ),
                                                                child: SmallAvatar(cubit
                                                                    .infoTeachers![cubit
                                                                    .lessons!
                                                                    .indexOf(
                                                                    e)]!
                                                                    .url),
                                                              ),
                                                              mark: Container(),
                                                              dropdown:
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    BlocProvider.of<DropdownCubit>(
                                                                        c)
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
                                                                  ))),
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
