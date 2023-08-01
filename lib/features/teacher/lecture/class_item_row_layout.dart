import 'package:flutter/material.dart';

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
            child: Container(alignment: Alignment.center, child: Container())),
        Expanded(
            flex: 2,
            child:
                Container(alignment: Alignment.center, child: widgetEvaluate)),
      ],
    );
  }
}
