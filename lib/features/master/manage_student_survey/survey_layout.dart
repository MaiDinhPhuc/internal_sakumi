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
            child: Container(alignment: Alignment.center, child: surveyCode)),
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

class TeacherSurveyLayout extends StatelessWidget {
  const TeacherSurveyLayout(
      {Key? key,
        required this.surveyCode,
        required this.title,
        required this.status,
        required this.assignDate,
        required this.sensei,
        required this.moreButton})
      : super(key: key);
  final Widget surveyCode, title, status, assignDate, moreButton, sensei;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: surveyCode)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.centerLeft, child: title)),
        Expanded(
            flex: 3,
            child: Container(alignment: Alignment.center, child: sensei)),
        Expanded(
            flex: 5,
            child: Container(alignment: Alignment.center, child: assignDate)),
        Expanded(
            flex: 5,
            child: Container(alignment: Alignment.center, child: status)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: moreButton)),
      ],
    );
  }
}
