import 'package:flutter/Material.dart';

class SurveyLayout extends StatelessWidget {
  const SurveyLayout(
      {Key? key,
      required this.surveyCode,
      required this.title,
      required this.number,
      required this.date,
      required this.moreButton})
      : super(key: key);
  final Widget surveyCode, title, number, date, moreButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.centerLeft, child: surveyCode)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.centerLeft, child: title)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.center, child: number)),
        Expanded(
            flex: 6,
            child: Container(alignment: Alignment.center, child: date)),
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: moreButton)),
      ],
    );
  }
}
