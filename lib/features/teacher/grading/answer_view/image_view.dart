import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ImageView extends StatelessWidget {
  ImageView({super.key, required this.answer});
  AnswerModel answer;

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
        Row(
          children: [
            SizedBox(
                height: Resizable.size(context, 100),
                width:Resizable.size(context, 110),
                child: Padding(
                    padding: EdgeInsets.only(
                        right: Resizable.padding(context, 10)),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(Resizable.size(context, 10))),
                      child: Image.network(answer.answer.first.toString(),
                          fit: BoxFit.fitWidth),
                    ))),
            if(answer.answer.length == 2)
              SizedBox(
                  height: Resizable.size(context,100),
                  width:Resizable.size(context, 110),
                  child: Padding(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 10)),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(Resizable.size(context, 10))),
                        child: Image.network(answer.answer[1].toString(),
                            fit: BoxFit.fitWidth),
                      ))),
            if(answer.answer.length > 2)
              SizedBox(
                  height: Resizable.size(context, 100),
                  width:Resizable.size(context, 110),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              right: Resizable.padding(context, 10)),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(Resizable.size(context, 10))),
                            child: Image.network(answer.answer[1].toString(),
                                fit: BoxFit.fitWidth),
                          )),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(Resizable.size(context, 10))),
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          height: Resizable.size(context, 100),
                          width:Resizable.size(context, 110),
                        ),
                      ),
                      Text("+${answer.answer.length-2}",style: TextStyle(color:Colors.white,fontSize: Resizable.font(context, 30), fontWeight: FontWeight.w600),)
                    ],
                  ))
          ],
        )
      ],
    );
  }
}
