import 'package:flutter/Material.dart';

class ScheduleCheckBoxLayout extends StatelessWidget {
  const ScheduleCheckBoxLayout(
      {super.key,
      required this.day,
      required this.a,
      required this.b,
      required this.c,
      required this.d,
      required this.e,
      required this.f,
      required this.g,
      required this.h,
      required this.i,
      required this.k,
      required this.l,
      required this.m,
      required this.n});
  final Widget day, a, b, c, d, e, f, g, h, i, k, l, m, n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: day,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: a,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: b,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: c,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: d,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: e,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: f,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: g,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: h,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: i,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: k,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: l,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: m,
            )),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: n,
            ))
      ],
    );
  }
}
