
import 'package:flutter/Material.dart';

class TeacherItemLayout extends StatelessWidget {
  final Widget widgetTeacherCode,
      widgetName,
      widgetPhone,
      widgetStatus,
      widgetRating,
      widgetDropdown;
  const TeacherItemLayout(
      {required this.widgetTeacherCode,
        required this.widgetName,
        required this.widgetPhone,
        required this.widgetRating,
        required this.widgetStatus,
        required this.widgetDropdown,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center, child: widgetTeacherCode)),
        Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: widgetName,
            )),
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center,
                child: widgetPhone)),
        Expanded(
            flex: 3,
            child:
            Container(alignment: Alignment.center, child: widgetStatus)),
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center, child: widgetRating)),
        Expanded(
            flex: 1,
            child: Container(alignment: Alignment.center, child: widgetDropdown)),
      ],
    );
  }
}