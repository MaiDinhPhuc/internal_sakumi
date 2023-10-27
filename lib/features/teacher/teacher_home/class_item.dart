import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/cubit/class_item_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/chart_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_over_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_status_item.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/widget/card_item.dart';

class ClassItem extends StatelessWidget {
  final ClassModel2 model;
  final ClassItemCubit classItemCubit;
  const ClassItem({super.key, required this.model, required this.classItemCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: classItemCubit),
          BlocProvider(create: (context) => DropdownCubit())
        ],
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => BlocBuilder<ClassItemCubit, int>(
              builder: (cc, s) => AnimatedCrossFade(
                  firstChild: CardItem(
                      widget: ClassOverview(
                        model: model,
                        courseTitle: "${classItemCubit.classModel.course.name} ${classItemCubit.classModel.course.level} ${classItemCubit.classModel.course.termName}",
                        lessonPercent: classItemCubit.lessonPercent,
                        lessonCountTitle: "${classItemCubit.classModel.lessonCount}/${classItemCubit.classModel.course.lessonCount}",
                        attendancePercent: classItemCubit.classStatistic ==
                            null
                            ? null
                            : classItemCubit.classStatistic!.attendancePercent,
                        hwPercent: classItemCubit.classStatistic == null
                            ? null
                            : classItemCubit.classStatistic!.hwPercent,
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.teacher}/overview/class=${model.classModel.classId}");
                      },
                      onPressed: () {
                        BlocProvider.of<DropdownCubit>(c).update();
                      },
                      widgetStatus: StatusClassItem(
                          status: model.classModel.classStatus,
                          color: model.getColor(),
                          icon: model.getIcon())),
                  secondChild: CardItem(
                    isExpand: true,
                    widget: Column(
                      children: [
                        ClassOverview(
                          model: model,
                          courseTitle:  "${classItemCubit.classModel.course.name} ${classItemCubit.classModel.course.level} ${classItemCubit.classModel.course.termName}",
                          lessonPercent: classItemCubit.lessonPercent,
                          lessonCountTitle: "${classItemCubit.classModel.lessonCount}/${classItemCubit.classModel.course.lessonCount}",
                          attendancePercent: classItemCubit.classStatistic ==
                                  null
                              ? null
                              : classItemCubit.classStatistic!.attendancePercent,
                          hwPercent: classItemCubit.classStatistic == null
                              ? null
                              : classItemCubit.classStatistic!.hwPercent,
                        ),
                        ChartView(
                          attendances: classItemCubit.classStatistic ==
                              null
                              ? []
                              : classItemCubit.classStatistic!.attChart,
                          hws: classItemCubit.classStatistic ==
                              null
                              ? []
                              : classItemCubit.classStatistic!.hwChart,
                          stds: classItemCubit.classStatistic ==
                              null
                              ? [1,0,0,0,0]
                              : classItemCubit.classStatistic!.stds,
                        )
                      ],
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(context,
                          "${Routes.teacher}/overview/class=${model.classModel.classId}");
                    },
                    onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                    widgetStatus: StatusClassItem(
                      status: model.classModel.classStatus,
                      color: model.getColor(),
                      icon: model.getIcon(),
                    ),
                  ),
                  crossFadeState: state % 2 == 1
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 100))),
        ));
  }
}
