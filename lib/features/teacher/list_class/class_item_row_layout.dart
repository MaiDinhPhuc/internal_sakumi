import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class ClassItemRowLayout extends StatelessWidget {
  final Widget widgetClassCode,
      widgetCourse,
      widgetLessons,
      widgetAttendance,
      widgetSubmit,
      widgetEvaluate;
  const ClassItemRowLayout(
      {required this.widgetClassCode,
      required this.widgetCourse,
      required this.widgetLessons,
      required this.widgetAttendance,
      required this.widgetSubmit,
      required this.widgetEvaluate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: widgetClassCode,
            )),
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: widgetCourse)),
        Expanded(
            flex: 6,
            child:
                Container(alignment: Alignment.center, child: widgetLessons)),
        Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.center, child: widgetAttendance)),
        Expanded(
            flex: 3,
            child: Container(alignment: Alignment.center, child: widgetSubmit)),
        Expanded(
            flex: 1,
            child: Container(alignment: Alignment.center, child: Opacity(
              opacity: 0,
              child: CircleProgress(
                title:
                '%',
                lineWidth: Resizable.size(context, 3),
                percent: 0,
                radius: Resizable.size(context, 15),
                fontSize: Resizable.font(context, 14),
              ),
            ))),
        Expanded(
            flex: 2,
            child:
                Container(alignment: Alignment.center, child: widgetEvaluate)),
      ],
    );
  }
}
