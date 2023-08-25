import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sounder.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class QuestionOptionItem extends StatelessWidget {
  const QuestionOptionItem(this.id, this.index,this.now,
      {super.key,
      required this.questionModel,
      required this.onTap,
      required this.soundCubit, required this.isDone});
  final int id, index, now;
  final QuestionModel questionModel;
  final Function() onTap;
  final SoundCubit soundCubit;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    String question = questionModel.convertQuestion;
    return Row(
      children: [
        Container(
          color: id == questionModel.id || now == questionModel.id ? primaryColor : Colors.transparent,
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
                elevation:
                id == questionModel.id || now == questionModel.id ? 0 : Resizable.size(context, 2),
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
                              Icon(Icons.check_circle, color: isDone?greenColor:greyColor.shade500),
                              SizedBox(width: Resizable.padding(context, 5)),
                              Text(
                                "${AppText.textQuestionNumber.text}${index + 1}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 17)),
                              )
                            ],
                          ),
                          if (id == questionModel.id || now == questionModel.id) ...[
                            if (questionModel.instruction != "")
                              Text(
                                questionModel.instruction,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 17)),
                              ),
                            if (question != "")
                              Text(
                                question,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 17)),
                              ),
                            if (questionModel.sound != "")
                              Expanded(
                                child: Sounder(
                                  "assets/practice/${TextUtils.getName()}/${questionModel.listSound.first}",
                                  "assets",0,
                                  soundCubit: soundCubit,
                                  backgroundColor: primaryColor,
                                  iconColor: Colors.white,
                                ),
                              ),
                            if (questionModel.image != "")
                              SizedBox(
                                height: Resizable.size(context, 100),
                                child: ListView.builder(
                                    itemCount: questionModel.listImage.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Resizable.padding(context, 5)),
                                    itemBuilder: (_, i) => Container(
                                          margin: EdgeInsets.all(
                                              Resizable.padding(context, 2)),
                                          height: MediaQuery.of(context).size.width*0.1,
                                          width: MediaQuery.of(context).size.width*0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/practice/${TextUtils.getName()}/${questionModel.listImage[i]}'),
                                                fit: BoxFit.fill),
                                            border: Border.all(
                                                width: 0,
                                                color: secondaryColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Resizable.size(
                                                    context, 5))),
                                          ),
                                        )),
                              ),
                            if (questionModel.questionType == 1 ||
                                questionModel.questionType == 5)
                              ...questionModel.listAnswer.map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      top: Resizable.padding(context, 3)),
                                  child: Text(
                                      "${questionModel.listAnswer.indexOf(e) + 1}.$e",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Resizable.font(context, 15),
                                          fontWeight: FontWeight.w800)))),
                            if (questionModel.questionType == 11) ...[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: questionModel.listAnswer
                                      .sublist(0, 2)
                                      .map((item) => Container(
                                            margin: EdgeInsets.all(
                                                Resizable.padding(context, 2)),
                                            height:
                                            MediaQuery.of(context).size.width*0.1,
                                            width: MediaQuery.of(context).size.width*0.1,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/practice/${TextUtils.getName()}/$item'),
                                                  fit: BoxFit.fill),
                                              border: Border.all(
                                                  width: 0,
                                                  color: secondaryColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Resizable.size(
                                                          context, 5))),
                                            ),
                                          ))
                                      .toList()),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: questionModel.listAnswer
                                      .sublist(2)
                                      .map((item) => Container(
                                            margin: EdgeInsets.all(
                                                Resizable.padding(context, 2)),
                                            height:
                                            MediaQuery.of(context).size.width*0.1,
                                            width: MediaQuery.of(context).size.width*0.1,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/practice/${TextUtils.getName()}/$item'),
                                                  fit: BoxFit.fill),
                                              border: Border.all(
                                                  color: secondaryColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Resizable.size(
                                                          context, 5))),
                                            ),
                                          ))
                                      .toList())
                            ],
                          ]
                        ],
                      )),
                )))
      ],
    );
  }
}
