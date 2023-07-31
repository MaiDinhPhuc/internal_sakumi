import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class QuestionOptionItem extends StatelessWidget {
  const QuestionOptionItem(this.id, this.index,
      {super.key, required this.questionModel, required this.onTap});
  final int id, index;
  final QuestionModel questionModel;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    String question = "";
      if (questionModel.questionType == 7) {
        question = questionModel.question.replaceAll("/", " ");
      } else if (questionModel.questionType == 8) {
        question = questionModel.question.replaceAll(";", "\n").replaceAll("|", "-");
      } else if (questionModel.questionType == 10) {
        question = "";
      } else {
        question = questionModel.question;
      }
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: EdgeInsets.only(
          left: Resizable.padding(context, 150),
          top: Resizable.padding(context, 5),
          bottom: Resizable.padding(context, 5),
          right: Resizable.padding(context, 35)),
      child: Stack(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: Resizable.padding(context, 20),right: Resizable.padding(context, 10),
                  top: Resizable.padding(context, 8), bottom: Resizable.padding(context, 8)),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: Resizable.size(
                          context, id == questionModel.id ? 0.5 : 1.5),
                      color: id == questionModel.id
                          ? Colors.black
                          : greyColor.shade100),
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${AppText.textQuestionNumber.text}${index + 1}"),
                  if (id == questionModel.id)
                    ...[
                      if(questionModel.instruction != "")
                        Text(questionModel.instruction),
                      if(questionModel.question != "")
                        Text(question),

                    ]
                ],
              )),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onTap,
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
          )),
        ],
      ),
    );
  }
}
