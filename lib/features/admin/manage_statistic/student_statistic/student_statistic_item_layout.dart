import 'package:flutter/material.dart';

class StudentStatisticItemRowLayout extends StatelessWidget {
  final Widget widgetClassCode,
      widgetStudentName,
      widgetStudentPhone,
      widgetContent,
      widgetStatus;
  const StudentStatisticItemRowLayout(
      {required this.widgetClassCode,
        required this.widgetStudentName,
        required this.widgetContent,
        required this.widgetStudentPhone,
        required this.widgetStatus,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.centerLeft, child: widgetStatus)),
        Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: widgetStudentName,
            )),
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: widgetStudentPhone,
            )),
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center, child: widgetClassCode)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.center, child: widgetContent)),
      ],
    );
  }
}
