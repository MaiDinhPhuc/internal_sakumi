import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:screenshot/screenshot.dart';

class OnlyTextView extends StatelessWidget {
  const OnlyTextView({super.key, required this.answer});
  final AnswerModel answer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppText.textStudentAnswer.text,
          style: TextStyle(
            fontSize: Resizable.font(context, 18),
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
            child: Text(
              answer.convertAnswer.first,
              style: TextStyle(
                  fontSize: Resizable.font(context, 18),
                  fontWeight: FontWeight.w700,
                  color: primaryColor),
            ))
      ],
    );
  }
}
