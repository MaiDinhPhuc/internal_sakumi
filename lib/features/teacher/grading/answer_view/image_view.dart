import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.answer, required this.token, required this.type});
  final AnswerModel answer;
  final String token;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(bottom: Resizable.padding(context, 10)),child: Text(
          AppText
              .textStudentAnswer.text,
          style: TextStyle(
            fontSize: Resizable.font(
                context, 18),
            fontWeight: FontWeight.w700,
          ),
        )),
        answer.questionType != 11
            ? SizedBox(
          height: Resizable.size(context, 200),
          child: ListView.builder(
              itemCount: answer.convertAnswer.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.padding(context, 5)),
              itemBuilder: (_, i) => Container(
                margin: EdgeInsets.all(
                    Resizable.padding(context, 2)),
                height: Resizable.size(context, 200),
                width: Resizable.size(context, 200),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 0,
                      color: secondaryColor),
                  borderRadius: BorderRadius.all(
                      Radius.circular(
                          Resizable.size(
                              context, 5))),
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(Resizable.size(context, 10))),
                  child: ImageNetwork(
                      fitWeb: answer.questionType == 4 ? BoxFitWeb.contain : BoxFitWeb.fill,
                      image: answer.convertAnswer.first , height: Resizable.size(context, 200), width: Resizable.size(context, 200)),
                ),
              )),
        )
            : Row(
          children: [
            Padding(
                key: Key(answer.convertAnswer.first),
                padding: EdgeInsets.only(
                    right: Resizable.padding(context, 10)),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(Resizable.size(context, 10))),
                  child: ImageNetwork(
                      fitWeb: answer.questionType == 4 ? BoxFitWeb.contain : BoxFitWeb.fill,
                      image: AppConfigs.getDataUrl(
                          "${type}_${TextUtils.getName()}_${answer.convertAnswer.first}",
                          token), height: Resizable.size(context, 200), width: Resizable.size(context, 200)),
                )),
            if(answer.answer.length == 2)
              Padding(
                  key: Key(answer.convertAnswer[1]),
                  padding: EdgeInsets.only(
                      right: Resizable.padding(context, 10)),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(Resizable.size(context, 10))),
                    child: ImageNetwork(image: answer.convertAnswer[1].toString(),
                        fitWeb: answer.questionType == 4 ? BoxFitWeb.contain :  BoxFitWeb.fill,
                        height: Resizable.size(context, 200), width: Resizable.size(context, 200)),
                  )),
            if(answer.answer.length > 2)
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    key: Key(answer.convertAnswer[1]),
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(Resizable.size(context, 10))),
                    child: ImageNetwork(image: answer.convertAnswer[1].toString(),
                        fitWeb:answer.questionType == 4 ? BoxFitWeb.contain :  BoxFitWeb.fill,
                        height: Resizable.size(context, 200), width: Resizable.size(context, 200)),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(Resizable.size(context, 10))),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      height: Resizable.size(context, 200),
                      width:Resizable.size(context, 200),
                    ),
                  ),
                  Text("+${answer.answer.length-2}",style: TextStyle(color:Colors.white,fontSize: Resizable.font(context, 30), fontWeight: FontWeight.w600),)
                ],
              )
          ],
        )
      ],
    );
  }
}
