import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class QuestionOptionItem extends StatelessWidget {
  const QuestionOptionItem(this.id, this.index, this.now,
      {super.key,
      required this.questionModel,
      required this.onTap,
      required this.isDone});
  final int id, index, now;
  final QuestionModel questionModel;
  final Function() onTap;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: id == questionModel.id || now == questionModel.id
              ? primaryColor
              : Colors.transparent,
          width: Resizable.size(context, 4),
          margin: EdgeInsets.only(
              right: Resizable.padding(context, 5),
              bottom: Resizable.padding(context, 10)),
        ),
        Expanded(
            child: Card(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5)),
                    side: BorderSide(
                        color: id == questionModel.id || now == questionModel.id
                            ? Colors.black
                            : const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1))),
                elevation: id == questionModel.id || now == questionModel.id
                    ? 0
                    : Resizable.size(context, 2),
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5)),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10),
                          horizontal: Resizable.padding(context, 15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color:
                                      isDone ? greenColor : greyColor.shade500),
                              SizedBox(width: Resizable.padding(context, 5)),
                              Text(
                                "${AppText.textQuestionNumber.text}${index + 1}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 17)),
                              )
                            ],
                          ),
                        ],
                      )),
                )))
      ],
    );
  }
}
