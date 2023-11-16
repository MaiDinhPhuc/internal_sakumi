import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'grading_item_layout.dart';

class CollapseGradingItem extends StatelessWidget {
  const CollapseGradingItem(
      {super.key,
      required this.title,
      required this.receiveTitle,
      required this.gradingTitle,
      required this.receivePercent,
      required this.gradingPercent});
  final String title, receiveTitle, gradingTitle;
  final double receivePercent, gradingPercent;

  @override
  Widget build(BuildContext context) {
    return GradingItemLayout(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xff131111),
                fontSize: Resizable.font(context, 17))),
        receivedNUmber: CircleProgress(
          title: receiveTitle,
          lineWidth: Resizable.size(context, 3),
          percent: receivePercent,
          radius: Resizable.size(context, 16),
          fontSize: Resizable.font(context, 14),
        ),
        gradingNumber: CircleProgress(
          title: gradingTitle,
          lineWidth: Resizable.size(context, 3),
          percent: gradingPercent,
          radius: Resizable.size(context, 16),
          fontSize: Resizable.font(context, 14),
        ),
        button: Container(),
        dropdown: Container());
  }
}
