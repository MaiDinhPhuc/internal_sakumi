import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class ClassStatisticItemRowLayout extends StatelessWidget {
  final Widget widgetClassCode,
      widgetCourse,
      widgetLessons,
      widgetEvaluate,
      widgetStartDay,
      widgetEndDay,
      widgetStatus;
  const ClassStatisticItemRowLayout(
      {required this.widgetClassCode,
        required this.widgetCourse,
        required this.widgetLessons,
        required this.widgetStartDay,
        required this.widgetEndDay,
        required this.widgetEvaluate,
        required this.widgetStatus,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft, child: widgetStatus)),
        Expanded(
            flex: 21,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: widgetClassCode,
                    )),
                Expanded(
                    flex: 6,
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: Resizable.padding(context, 10)),
                        child: widgetCourse)),
                Expanded(
                    flex: 6,
                    child:
                    Container(alignment: Alignment.center, child: widgetLessons)),
                Expanded(
                    flex: 3,
                    child: Container(
                        alignment: Alignment.center, child: widgetStartDay)),
                Expanded(
                    flex: 3,
                    child: Container(alignment: Alignment.center, child: widgetEndDay)),
                Expanded(
                    flex: 2,
                    child:
                    Container(alignment: Alignment.center, child: widgetEvaluate)),
              ],
            ))
      ],
    );
  }
}
