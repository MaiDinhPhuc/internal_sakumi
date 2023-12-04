import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sounder.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class QuestionTestView extends StatelessWidget {
  const QuestionTestView(
      {super.key,
      required this.questionModel,
      required this.soundCubit,
      required this.testId,
      required this.token,
      required this.index});
  final QuestionModel questionModel;
  final SoundCubit soundCubit;
  final int testId;
  final String token;
  final int index;
  @override
  Widget build(BuildContext context) {
    String question = questionModel.convertQuestion;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
        child: Column(
            key: Key("${questionModel.id}"),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${AppText.textQuestionNumber.text}${index + 1}: ",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 17)),
                  ),
                  if (questionModel.instruction != "")
                    Padding(
                        padding: EdgeInsets.only(
                            left: Resizable.padding(context, 5)),
                        child: Text(
                          questionModel.instruction,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 17),
                              color: primaryColor),
                        )),
                ],
              ),
              if (question != "")
                Text(
                  question,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 17)),
                ),
              if (questionModel.paragraph != "")
                Text(
                  questionModel.paragraph,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 17)),
                ),
              if (questionModel.sound != "")
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: Resizable.padding(context, 350)),
                        child: Sounder(
                          AppConfigs.getDataUrl(
                              "test_${testId}_${questionModel.listSound.first}",
                              token),
                          "network",
                          0,
                          soundCubit: soundCubit,
                          backgroundColor: primaryColor,
                          iconColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              if (questionModel.image != "")
                SizedBox(
                  height: Resizable.size(context, 100),
                  child: ListView.builder(
                      itemCount: questionModel.listImage.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 5)),
                      itemBuilder: (_, i) => Container(
                            margin:
                                EdgeInsets.all(Resizable.padding(context, 2)),
                            height: MediaQuery.of(context).size.width * 0.1,
                            width: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(AppConfigs.getDataUrl(
                                      "test_${testId}_${questionModel.listImage[i]}",
                                      token)),
                                  fit: BoxFit.fill),
                              border:
                                  Border.all(width: 0, color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Resizable.size(context, 5))),
                            ),
                          )),
                ),
              if (questionModel.questionType == 1 ||
                  questionModel.questionType == 5)
                ...questionModel.listAnswer.map((e) => Padding(
                    padding:
                        EdgeInsets.only(top: Resizable.padding(context, 3)),
                    child: Text("${questionModel.listAnswer.indexOf(e) + 1}.$e",
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
                              margin:
                                  EdgeInsets.all(Resizable.padding(context, 2)),
                              height: MediaQuery.of(context).size.width * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(AppConfigs.getDataUrl(
                                        "test_${testId}_$item", token)),
                                    fit: BoxFit.fill),
                                border:
                                    Border.all(width: 0, color: secondaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Resizable.size(context, 5))),
                              ),
                            ))
                        .toList()),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: questionModel.listAnswer
                        .sublist(2)
                        .map((item) => Container(
                              margin:
                                  EdgeInsets.all(Resizable.padding(context, 2)),
                              height: MediaQuery.of(context).size.width * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(AppConfigs.getDataUrl(
                                        "test_${testId}_$item", token)),
                                    fit: BoxFit.fill),
                                border: Border.all(color: secondaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    Resizable.size(context, 5))),
                              ),
                            ))
                        .toList())
              ],
            ]));
  }
}
