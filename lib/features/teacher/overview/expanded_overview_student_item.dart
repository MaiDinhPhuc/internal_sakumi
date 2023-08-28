import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandedOverviewStudentItem extends StatelessWidget {
  final int index;
  const ExpandedOverviewStudentItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ClassOverviewCubit>(context);
    return cubit.listStdLesson == null
        ? Transform.scale(
            scale: 0.75,
            child: const Center(child: CircularProgressIndicator()))
        : Column(
            children: [
              Container(
                height: Resizable.size(context, 0.5),
                width: double.maxFinite,
                color: const Color(0xffE0E0E0),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              ...cubit.listStdLesson![index]
                  .map((e) =>
              cubit.listStdLesson![index]
                              [cubit.listStdLesson![index].indexOf(e)] ==
                          null
                      ? Container()
                      : BlocProvider(
                          create: (context) => DropdownCubit(),
                          child: BlocBuilder<DropdownCubit, int>(
                            builder: (c, state) => Container(
                                margin: EdgeInsets.only(
                                    left: Resizable.padding(context, 25),
                                    right: Resizable.padding(context, 25),
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
                                    borderRadius: BorderRadius.circular(
                                        Resizable.size(context, 5))),
                                child: AnimatedCrossFade(
                                    firstChild: CollapseLearnedLesson(cubit.listStdLesson![index].indexOf(e)+1, cubit.listStdLesson![index]
                                    [cubit.listStdLesson![index].indexOf(e)]!.attendColor, cubit.listStdLesson![index]
                                    [cubit.listStdLesson![index].indexOf(e)]!
                                        .attendTitle),
                                    secondChild: Column(
                                      children: [
                                        CollapseLearnedLesson(cubit.listStdLesson![index].indexOf(e)+1, cubit.listStdLesson![index]
                                        [cubit.listStdLesson![index].indexOf(e)]!.attendColor, cubit.listStdLesson![index]
                                        [cubit.listStdLesson![index].indexOf(e)]!
                                            .attendTitle),
                                        ExpandLearnedLesson(cubit.listStdLesson![index]
                                        [cubit.listStdLesson![index].indexOf(e)]!)
                                      ],
                                    ),
                                    crossFadeState: state % 2 == 1
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration:
                                        const Duration(milliseconds: 100))),
                          )))
                  .toList()
            ],
          );
  }
}

class CollapseLearnedLesson extends StatelessWidget {
  final int numberOfLesson;
  final String title;
  final Color color;
  const CollapseLearnedLesson(this.numberOfLesson, this.color, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
            '${AppText.txtLesson.text} $numberOfLesson',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(
                    context, 18))),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minWidth: Resizable.size(context, 100)
              ),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                  BorderRadius.circular(
                      1000)),
              margin: EdgeInsets.only(
                  right: Resizable.padding(
                      context, 20)),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(
                      context, 3)),
              child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: Resizable.font(
                          context, 16))),
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<
                      DropdownCubit>(context)
                      .update();
                },
                splashRadius:
                Resizable.size(context, 15),
                icon: Icon(
                  BlocProvider.of<
                      DropdownCubit>(context).state % 2 == 0
                      ? Icons
                      .keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ))
          ],
        )
      ],
    );
  }
}

class ExpandLearnedLesson extends StatelessWidget {
  final StudentLessonModel model;
  const ExpandLearnedLesson(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
        margin: EdgeInsets.only(
          top: Resizable.padding(context, 5),
            bottom: Resizable.padding(context, 15)),
        height: Resizable.size(context, 0.5),
        width: double.maxFinite,
        color: const Color(0xffE0E0E0),
      ),
        Text(AppText.titleNoteFromAnotherTeacher.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
          margin:
          EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
          padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
          constraints: BoxConstraints(
            minHeight: Resizable.size(context, 30)
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: greyColor.shade50,
              borderRadius:
              BorderRadius.circular(Resizable.padding(context, 5))),
          child: Text(
            model.teacherNote, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Resizable.font(context, 19))
          )
        ),
        Text(AppText.titleNoteFromSupport.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 19))),
        Container(
            margin:
            EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
            constraints: BoxConstraints(
                minHeight: Resizable.size(context, 30)
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: greyColor.shade50,
                borderRadius:
                BorderRadius.circular(Resizable.padding(context, 5))),
            child: Text(
                model.supportNote, style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Resizable.font(context, 19))
            )
        ),
      ],
    );
  }
}
