import 'package:flutter/material.dart';

class LessonItemRowLayout extends StatelessWidget {
  final Widget name, submit, attend, mark;
  const LessonItemRowLayout({required this.name, required this.attend, required this.submit, required this.mark, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 8,
            child: Align(alignment: Alignment.centerLeft,
              child: name,
            )),
        Expanded(
            flex: 2,
            child: Align(alignment: Alignment.center,
              child: attend,
            )),
        Expanded(
            flex: 2,
            child: Align(alignment: Alignment.center,
              child: submit,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: mark,
            )),
        Expanded(
            flex: 1,
            child: Container()),
      ],
    );
  }
}
