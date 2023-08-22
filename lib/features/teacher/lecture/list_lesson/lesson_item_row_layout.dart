import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class LessonItemRowLayout extends StatelessWidget {
  final Widget lesson, name, submit, attend, mark;
  const LessonItemRowLayout({required this.lesson, required this.name, required this.attend, required this.submit, required this.mark, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft,
          child: lesson,
        )),
        Expanded(
            flex: 16,
            child: Align(alignment: Alignment.centerLeft,
              child: name,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: attend,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: submit,
            )),
        Expanded(
            flex: 8,
            child: Align(alignment: Alignment.center,
              child: mark,
            )),
        Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Opacity(opacity: 0,
                child: CircleProgress(
                  title:
                  '0 %',
                  lineWidth: Resizable.size(context, 3),
                  percent: 0,
                  radius: Resizable.size(context, 16),
                  fontSize: Resizable.font(context, 14),
                ),
              ),
            )),
      ],
    );
  }
}

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
