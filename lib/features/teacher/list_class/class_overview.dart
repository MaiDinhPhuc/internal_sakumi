import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ClassOverview extends StatelessWidget {
  final int index;
  const ClassOverview(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return
        ClassItemRowLayout(
            widgetClassCode: AutoSizeText(cubit.listClassCodes![index].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 20))),
            widgetCourse: Text(cubit.listBigTitle![index].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Resizable.font(context, 16))),
            widgetLessons: Row(
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  animation: true,
                  lineHeight: Resizable.size(context, 6),
                  animationDuration: 2000,
                  percent: cubit.listLessonAvailable![index] <= 0
                      ? 0
                      : cubit.listLessonAvailable![index] /
                          cubit.listLessonCount![index],
                  center: const SizedBox(),
                  barRadius: const Radius.circular(10000),
                  backgroundColor: greyColor.shade100,
                  progressColor: primaryColor,
                )),
                Container(
                  alignment: Alignment.centerRight,
                  constraints:
                      BoxConstraints(minWidth: Resizable.size(context, 50)),
                  child: Text(
                      '${cubit.listLessonAvailable![index]}/${cubit.listLessonCount![index]} ${AppText.txtLesson.text.toLowerCase()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 16))),
                )
              ],
            ),
            widgetAttendance:
                cubit.rateAttendance == null || cubit.rateAttendance!.isEmpty
                    ? Center(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : CircleProgress(
                        title:
                            '${(cubit.rateAttendance![index] * 100).toStringAsFixed(0)} %',
                        lineWidth: Resizable.size(context, 3),
                        percent: cubit.rateAttendance![index],
                        radius: Resizable.size(context, 15),
                        fontSize: Resizable.font(context, 14),
                      ),
            widgetSubmit:
                cubit.rateSubmit == null || cubit.rateAttendance!.isEmpty
                    ? Center(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : CircleProgress(
                        title:
                            '${(cubit.rateSubmit![index] * 100).toStringAsFixed(0)} %',
                        lineWidth: Resizable.size(context, 3),
                        percent: cubit.rateSubmit![index],
                        radius: Resizable.size(context, 15),
                        fontSize: Resizable.font(context, 14),
                      ),
            widgetEvaluate: Container(
              width: Resizable.size(context, 20),
              height: Resizable.size(context, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Text('A', //TODO ADD ALGORITHM
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: Resizable.font(context, 30))),
            ));
  }
}

class ClassOverviewInAdmin extends StatelessWidget {
  final int index;
  const ClassOverviewInAdmin(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoadListClassCubit>(context);
    return ClassItemRowLayout(
            widgetClassCode:AutoSizeText(cubit.listClassCodes![index].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 20))),
            widgetCourse: Text(
                cubit.listBigTitle![index].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Resizable.font(context, 16))),
            widgetLessons: Row(
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  animation: true,
                  lineHeight: Resizable.size(context, 6),
                  animationDuration: 2000,
                  percent: cubit.listLessonAvailable![index] <= 0
                      ? 0
                      : cubit.listLessonAvailable![index] /
                      cubit.listLessonCount![index],
                  center: const SizedBox(),
                  barRadius: const Radius.circular(10000),
                  backgroundColor: greyColor.shade100,
                  progressColor: primaryColor,
                )),
                Container(
                  alignment: Alignment.centerRight,
                  constraints:
                      BoxConstraints(minWidth: Resizable.size(context, 50)),
                  child: Text(
                      '${cubit.listLessonAvailable![index]}/${cubit.listLessonCount![index]} ${AppText.txtLesson.text.toLowerCase()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 16))),
                )
              ],
            ),
            widgetAttendance:
                cubit.rateAttendance == null || cubit.rateAttendance!.isEmpty
                    ? Center(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : CircleProgress(
                        title:
                            '${(cubit.rateAttendance![index] * 100).toStringAsFixed(0)} %',
                        lineWidth: Resizable.size(context, 3),
                        percent: cubit.rateAttendance![index],
                        radius: Resizable.size(context, 15),
                        fontSize: Resizable.font(context, 14),
                      ),
            widgetSubmit:
                cubit.rateSubmit == null || cubit.rateAttendance!.isEmpty
                    ? Center(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : CircleProgress(
                        title:
                            '${(cubit.rateSubmit![index] * 100).toStringAsFixed(0)} %',
                        lineWidth: Resizable.size(context, 3),
                        percent: cubit.rateSubmit![index],
                        radius: Resizable.size(context, 15),
                        fontSize: Resizable.font(context, 14),
                      ),
            widgetEvaluate: Container(
              width: Resizable.size(context, 20),
              height: Resizable.size(context, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Text('A', //TODO ADD ALGORITHM
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: Resizable.font(context, 30))),
            ));
  }
}
