import 'package:flutter/material.dart';

class TrackStudentItemRowLayout extends StatelessWidget {
  final Widget name, attendance, submit, note;
  const TrackStudentItemRowLayout({required this.name, required this.attendance, required this.submit, required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Align(
          alignment: Alignment.centerLeft,
          child: name,
        )),
        Expanded(flex: 1, child: Align(
          alignment: Alignment.center,
          child: attendance,
        )),
        Expanded(flex: 1, child: Align(
          alignment: Alignment.center,
          child: submit,
        )),
        Expanded(flex: 4, child: Align(
          alignment: Alignment.center,
          child: note,
        )),
      ],
    );
  }
}
