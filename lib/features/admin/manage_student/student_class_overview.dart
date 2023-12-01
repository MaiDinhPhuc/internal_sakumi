import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StudentClassOverview extends StatelessWidget {
  final ClassModel model;
  final String courseTitle;
  final double lessonPercent;
  final String lessonCountTitle;
  final double? attendancePercent, hwPercent;

  const StudentClassOverview(
      {super.key,
      required this.model,
      required this.courseTitle,
      required this.lessonPercent,
      required this.lessonCountTitle,
      required this.attendancePercent,
      required this.hwPercent});

  @override
  Widget build(BuildContext context) {
    return ClassItemRowLayout(
        widgetClassCode: AutoSizeText(model.classCode.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 20))),
        widgetCourse: Text(courseTitle,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 18))),
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
              percent: lessonPercent,
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
                  '$lessonCountTitle ${AppText.txtLesson.text.toLowerCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 16))),
            )
          ],
        ),
        widgetAttendance: CircleProgress(
          title:
              '${((attendancePercent == null ? 0 : attendancePercent!) * 100).toStringAsFixed(0)} %',
          lineWidth: Resizable.size(context, 3),
          percent: attendancePercent == null ? 0 : attendancePercent!,
          radius: Resizable.size(context, 15),
          fontSize: Resizable.font(context, 14),
        ),
        widgetSubmit: CircleProgress(
          title:
              '${((hwPercent == null ? 0 : hwPercent!) * 100).toStringAsFixed(0)} %',
          lineWidth: Resizable.size(context, 3),
          percent: hwPercent == null ? 0 : hwPercent!,
          radius: Resizable.size(context, 15),
          fontSize: Resizable.font(context, 14),
        ),
        widgetEvaluate: Container(),
        widgetStatus: Container());
  }
}
