import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'class_detail_cubit.dart';

class ClassOverViewV2 extends StatelessWidget {
  const ClassOverViewV2({super.key, required this.classModel, required this.cubit});
  final ClassModel classModel;
  final ClassDetailCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassDetailCubit, int>(
        bloc: cubit,
        builder: (c,s){
      return ClassItemRowLayout(
          widgetClassCode: AutoSizeText(classModel.classCode.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 20))),
          widgetCourse: Text(cubit.title ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 16))),
          widgetLessons: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left:Resizable.padding(context, 5)),
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        animation: true,
                        lineHeight: Resizable.size(context, 6),
                        animationDuration: 2000,
                        percent: cubit.lessonResults == null ? 0 : cubit.lessonResults!.length/cubit.lessonCount!,
                        center: const SizedBox(),
                        barRadius: const Radius.circular(10000),
                        backgroundColor: greyColor.shade100,
                        progressColor: primaryColor,
                      ))),
              Container(
                alignment: Alignment.centerRight,
                constraints:
                BoxConstraints(minWidth: Resizable.size(context, 50)),
                child: Text(
                    '${cubit.lessonCountTitle} ${AppText.txtLesson.text.toLowerCase()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 16))),
              )
            ],
          ),
          widgetAttendance: CircleProgress(
            title: '${((cubit.attendancePercent == null ? 0 : cubit.attendancePercent!)*100).toStringAsFixed(0)}%',
            lineWidth: Resizable.size(context, 3),
            percent: cubit.attendancePercent == null ? 0 : cubit.attendancePercent!,
            radius: Resizable.size(context, 15),
            fontSize: Resizable.font(context, 14),
          ),
          widgetSubmit: CircleProgress(
            title: '${((cubit.hwPercent == null ? 0 : cubit.hwPercent!)*100).toStringAsFixed(0)}%',
            lineWidth: Resizable.size(context, 3),
            percent: cubit.hwPercent == null ? 0 : cubit.hwPercent!,
            radius: Resizable.size(context, 15),
            fontSize: Resizable.font(context, 14),
          ),
          widgetEvaluate: Container(
            width: Resizable.size(context, 20),
            height: Resizable.size(context, 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
            child: Text('A',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: Resizable.font(context, 30))),
          ),
          widgetStatus: Container());
    });
  }
}
