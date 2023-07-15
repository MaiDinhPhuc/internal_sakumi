import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircleProgress extends StatelessWidget {
  final String title;
  final double radius, percent, lineWidth, fontSize;
  const CircleProgress(
      {required this.title,
      required this.lineWidth,
      required this.percent,
      required this.radius,
      required this.fontSize,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
        radius: radius,
        lineWidth: lineWidth,
        animation: true,
        animationDuration: 2500,
        percent: percent,
        center: Card(
          elevation: Resizable.size(context, 10),
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Center(
              child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
          )),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        rotateLinearGradient: true,
        linearGradient: LinearGradient(colors: [
          primaryColor.withOpacity(0.4),
          primaryColor.withOpacity(0.5),
          primaryColor.withOpacity(0.6),
          primaryColor.withOpacity(0.7),
          primaryColor.withOpacity(0.8),
          primaryColor.withOpacity(0.9),
          primaryColor,
        ]),
        backgroundColor: Colors.transparent);
  }
}
