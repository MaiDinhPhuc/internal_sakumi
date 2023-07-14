import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ClassOverView extends StatelessWidget {
  final double value1, value2;
  final String courseName;
  final ClassModel classModel;
  const ClassOverView(
      {required this.value1,
      required this.value2,
      required this.classModel,
      required this.courseName,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(classModel.classCode.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20))),
                SizedBox(
                  width: Resizable.size(context, 10),
                ),
                Text(courseName,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 16))),
              ],
            )),
        Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  width: (MediaQuery.of(context).size.width -
                          2 * Resizable.padding(context, 200)) /
                      4,
                  animation: true,
                  lineHeight: Resizable.size(context, 8),
                  animationDuration: 2000,
                  percent: value1 <= 0 ? 0 : value1 / value2,
                  center: const SizedBox(),
                  barRadius: const Radius.circular(10000),
                  backgroundColor: greyColor.shade100,
                  progressColor: primaryColor,
                ),
                SizedBox(width: Resizable.size(context, 10)),
                Text('$value1/$value2 ${AppText.txtLesson.text.toLowerCase()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 16)))
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //SizedBox(width: Resizable.size(context, 30)),
                Container(
                  width: Resizable.size(context, 20),
                  height: Resizable.size(context, 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                  child: Text('A', //TODO ADD ALGORITHM
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: Resizable.font(context, 30))),
                )
              ],
            ))
      ],
    );
  }
}
