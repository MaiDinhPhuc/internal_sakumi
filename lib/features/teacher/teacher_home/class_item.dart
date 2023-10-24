import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/chart_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_over_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_status_item.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/teacher/teacher_screen2.dart';
import 'package:internal_sakumi/widget/card_item.dart';

class ClassItem extends StatelessWidget {
  final ClassModel2 classModel;
  final OverViewCubit overviewCubit;
  ClassItem({super.key, required this.classModel})
      : overviewCubit = OverViewCubit(classModel.courseId, classModel.classId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: overviewCubit),
          BlocProvider(create: (context) => DropdownCubit())
        ],
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => BlocBuilder<OverViewCubit, int>(
              builder: (cc, s) => AnimatedCrossFade(
                  firstChild: CardItem(
                      widget: ClassOverview(
                        classModel: classModel,
                        courseTitle: overviewCubit.courseModel == null
                            ? ""
                            : "${overviewCubit.courseModel!.name} ${overviewCubit.courseModel!.level} ${overviewCubit.courseModel!.termName}",
                        lessonPercent: overviewCubit.lessonPercent,
                        lessonCountTitle: overviewCubit.courseModel == null
                            ? ""
                            : "${overviewCubit.lessonCount}/${overviewCubit.courseModel!.lessonCount}",
                        attendancePercent: overviewCubit.classStatistic ==
                            null
                            ? null
                            : overviewCubit.classStatistic!.attendancePercent,
                        hwPercent: overviewCubit.classStatistic == null
                            ? null
                            : overviewCubit.classStatistic!.hwPercent,
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.teacher}/overview/class=${classModel.classId}");
                      },
                      onPressed: () {
                        BlocProvider.of<DropdownCubit>(c).update();
                      },
                      widgetStatus: StatusClassItem(
                          status: classModel.status,
                          color: classModel.getColor(),
                          icon: classModel.getIcon())),
                  secondChild: CardItem(
                    isExpand: true,
                    widget: Column(
                      children: [
                        ClassOverview(
                          classModel: classModel,
                          courseTitle: overviewCubit.courseModel == null
                              ? ""
                              : "${overviewCubit.courseModel!.name} ${overviewCubit.courseModel!.level} ${overviewCubit.courseModel!.termName}",
                          lessonPercent: overviewCubit.lessonPercent,
                          lessonCountTitle: overviewCubit.courseModel == null
                              ? ""
                              : "${overviewCubit.lessonCount}/${overviewCubit.courseModel!.lessonCount}",
                          attendancePercent: overviewCubit.classStatistic ==
                                  null
                              ? null
                              : overviewCubit.classStatistic!.attendancePercent,
                          hwPercent: overviewCubit.classStatistic == null
                              ? null
                              : overviewCubit.classStatistic!.hwPercent,
                        ),
                        ChartView(
                          attendances: overviewCubit.classStatistic ==
                              null
                              ? []
                              : overviewCubit.classStatistic!.attChart,
                          hws: overviewCubit.classStatistic ==
                              null
                              ? []
                              : overviewCubit.classStatistic!.hwChart,
                          stds: overviewCubit.classStatistic ==
                              null
                              ? [1,0,0,0,0]
                              : overviewCubit.classStatistic!.stds,
                        )
                      ],
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(context,
                          "${Routes.teacher}/overview/class=${classModel.classId}");
                    },
                    onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                    widgetStatus: StatusClassItem(
                      status: classModel.status,
                      color: classModel.getColor(),
                      icon: classModel.getIcon(),
                    ),
                  ),
                  crossFadeState: state % 2 == 1
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 100))),
        ));
  }
}
