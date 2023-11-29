import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class LessonItemRowLayout extends StatelessWidget {
  final Widget lesson, name, submit, attend, mark, sensei, dropdown;
  const LessonItemRowLayout({required this.lesson, required this.name, required this.attend, required this.submit, required this.sensei, required this.mark, required this.dropdown, Key? key}) : super(key: key);

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
              child: sensei,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: attend,
            )),
        Expanded(
            flex: 5,
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
              child: dropdown,
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

class TestItemRowLayout extends StatelessWidget {
  final Widget test, name, submit, mark, status, dropdown;
  const TestItemRowLayout({ required this.name, required this.submit, required this.mark, required this.test, required this.status, Key? key, required this.dropdown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft,
          child: test,
        )),
        Expanded(
            flex: 16,
            child: Align(alignment: Alignment.centerLeft,
              child: name,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: submit,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: mark,
            )),
        Expanded(
            flex: 6,
            child: Align(alignment: Alignment.center,
              child: status,
            )),
        Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: dropdown,
            ))
      ],
    );
  }
}
