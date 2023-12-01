import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StudentLessonLayout extends StatelessWidget {
  final Widget widgetTitle, widgetAttendance, widgetSubmit;
  const StudentLessonLayout({
    super.key,
    required this.widgetTitle,
    required this.widgetAttendance,
    required this.widgetSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerLeft,
              child: widgetTitle,
            )),
        Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.center, child: widgetAttendance)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: widgetSubmit)),
        Expanded(flex: 1,child: Container())
      ],
    );
  }
}
