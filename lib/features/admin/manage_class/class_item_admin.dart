import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_class/class_status_item_admin.dart';
import 'package:internal_sakumi/features/teacher/cubit/class_item_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/chart_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_over_view.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/card_item.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class ClassItemAdmin extends StatelessWidget {
  
  const ClassItemAdmin({super.key, required this.classItemCubit, required this.dataCubit});
  final ClassItemCubit classItemCubit;
  final DataCubit dataCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: classItemCubit),
          BlocProvider(create: (context) => DropdownCubit())
        ],
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => BlocBuilder<ClassItemCubit, int>(
              builder: (cc, s){
                return AnimatedCrossFade(
                    firstChild: CardItem(
                        widget: ClassOverview(
                          model: classItemCubit.classModel,
                          courseTitle:classItemCubit.classModel.course == null ? "" : classItemCubit.classModel.course!.bigTitle,
                          lessonPercent: classItemCubit.lessonPercent == null ? 0 : classItemCubit.lessonPercent!,
                          lessonCountTitle:classItemCubit.classModel.course == null ? "" : "${classItemCubit.classModel.lessonCount ?? 0}/${classItemCubit.classModel.course!.lessonCount}",
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
                              "${Routes.admin}/overview/class=${classItemCubit.classModel.classModel.classId}");
                        },
                        onPressed: () {
                          BlocProvider.of<DropdownCubit>(c).update();
                        },
                        widgetStatus: StatusClassItemAdmin(
                            classModel: classItemCubit.classModel.classModel,
                            color: classItemCubit.classModel.getColor(),
                            icon: classItemCubit.classModel.getIcon(), dataCubit: dataCubit,)),
                    secondChild: CardItem(
                      isExpand: true,
                      widget: Column(
                        children: [
                          ClassOverview(
                            model: classItemCubit.classModel,
                            courseTitle:classItemCubit.classModel.course == null ? "" : classItemCubit.classModel.course!.bigTitle,
                            lessonPercent: classItemCubit.lessonPercent == null ? 0 : classItemCubit.lessonPercent!,
                            lessonCountTitle:classItemCubit.classModel.course == null ? "" : "${classItemCubit.classModel.lessonCount ?? 0}/${classItemCubit.classModel.course!.lessonCount}",
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
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: Resizable.size(context, 1),
                                  margin: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 15)),
                                  color: const Color(0xffD9D9D9),
                                ),
                                Row(
                                  children: [
                                    Text(AppText.txtLastLesson.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: Resizable.font(context, 19))),
                                    SizedBox(width: Resizable.padding(context, 10)),
                                    Text(classItemCubit.lastLesson,
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: Resizable.font(context, 19))),
                                  ],
                                ),
                                Container(
                                  height: Resizable.size(context, 1),
                                  margin: EdgeInsets.symmetric(
                                      vertical: Resizable.padding(context, 15)),
                                  color: const Color(0xffD9D9D9),
                                ),
                                Text(AppText.titleClassDes.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))),
                                NoteWidget(classItemCubit.classModel.classModel.description),
                                Text(AppText.titleClassNote.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))),
                                NoteWidget(classItemCubit.classModel.classModel.note)
                              ],
                            ),
                          )
                        ],
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.admin}/overview/class=${classItemCubit.classModel.classModel.classId}");
                      },
                      onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                      widgetStatus: StatusClassItemAdmin(
                        classModel: classItemCubit.classModel.classModel,
                        color: classItemCubit.classModel.getColor(),
                        icon: classItemCubit.classModel.getIcon(), dataCubit: dataCubit,
                      ),
                    ),
                    crossFadeState: state % 2 == 1
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 100));
              }),
        ));
  }
}