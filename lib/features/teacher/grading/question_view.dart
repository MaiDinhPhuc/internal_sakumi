import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sounder.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'detail_grading_cubit.dart';
import 'detail_grading_cubit_v2.dart';

class QuestionView extends StatelessWidget {
  const QuestionView(
      {super.key,
      required this.questionModel,
      required this.soundCubit,
      required this.cubit});
  final QuestionModel questionModel;
  final SoundCubit soundCubit;
  final DetailGradingCubit cubit;
  @override
  Widget build(BuildContext context) {
    String question = questionModel.convertQuestion;
    return Column(
        key: Key("${questionModel.id}"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (questionModel.instruction != "")
            Padding(padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),child: Text(
              questionModel.instruction,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            )),
          if (question != "")
            Text(
              question,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            ),
          if (questionModel.paragraph != "")
            Text(
              questionModel.paragraph ,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            ),
          if (questionModel.sound != "")
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: Resizable.padding(context, 350)),
                    child: Sounder(
                      AppConfigs.getDataUrl(
                          "${cubit.gradingType}_${TextUtils.getName()}_${questionModel.listSound.first}",
                          cubit.token),
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
                        margin: EdgeInsets.all(Resizable.padding(context, 2)),
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(AppConfigs.getDataUrl(
                                  "${cubit.gradingType}_${TextUtils.getName()}_${questionModel.listImage[i]}",
                                  cubit.token)),
                              fit: BoxFit.fill),
                          border: Border.all(width: 0, color: secondaryColor),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Resizable.size(context, 5))),
                        ),
                      )),
            ),
          if (questionModel.questionType == 1 ||
              questionModel.questionType == 5)
            ...questionModel.listAnswer.map((e) => Padding(
                padding: EdgeInsets.only(top: Resizable.padding(context, 3)),
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
                          margin: EdgeInsets.all(Resizable.padding(context, 2)),
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(AppConfigs.getDataUrl(
                                    "${cubit.gradingType}_${TextUtils.getName()}_$item",
                                    cubit.token)),
                                fit: BoxFit.fill),
                            border: Border.all(width: 0, color: secondaryColor),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Resizable.size(context, 5))),
                          ),
                        ))
                    .toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: questionModel.listAnswer
                    .sublist(2)
                    .map((item) => Container(
                          margin: EdgeInsets.all(Resizable.padding(context, 2)),
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(AppConfigs.getDataUrl(
                                    "${cubit.gradingType}_${TextUtils.getName()}_$item",
                                    cubit.token)),
                                fit: BoxFit.fill),
                            border: Border.all(color: secondaryColor),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Resizable.size(context, 5))),
                          ),
                        ))
                    .toList())
          ],
        ]);
  }
}

class QuestionViewV2 extends StatelessWidget {
  const QuestionViewV2(
      {super.key,
        required this.questionModel,
        required this.soundCubit,
        required this.cubit});
  final QuestionModel questionModel;
  final SoundCubit soundCubit;
  final DetailGradingCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    String question = questionModel.convertQuestion;
    return Column(
        key: Key("${questionModel.id}"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (questionModel.instruction != "")
            Padding(padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),child: Text(
              questionModel.instruction,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            )),
          if (question != "")
            Text(
              question,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            ),
          if (questionModel.paragraph != "")
            Text(
              questionModel.paragraph ,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 17)),
            ),
          if (questionModel.sound != "")
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                    EdgeInsets.only(right: Resizable.padding(context, 350)),
                    child: Sounder(
                      AppConfigs.getDataUrl(
                          "${cubit.gradingType}_${TextUtils.getName()}_${questionModel.listSound.first}",
                          cubit.token),
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
                    margin: EdgeInsets.all(Resizable.padding(context, 2)),
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(AppConfigs.getDataUrl(
                              "${cubit.gradingType}_${TextUtils.getName()}_${questionModel.listImage[i]}",
                              cubit.token)),
                          fit: BoxFit.fill),
                      border: Border.all(width: 0, color: secondaryColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(Resizable.size(context, 5))),
                    ),
                  )),
            ),
          if (questionModel.questionType == 1 ||
              questionModel.questionType == 5)
            ...questionModel.listAnswer.map((e) => Padding(
                padding: EdgeInsets.only(top: Resizable.padding(context, 3)),
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
                  margin: EdgeInsets.all(Resizable.padding(context, 2)),
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(AppConfigs.getDataUrl(
                            "${cubit.gradingType}_${TextUtils.getName()}_$item",
                            cubit.token)),
                        fit: BoxFit.fill),
                    border: Border.all(width: 0, color: secondaryColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(Resizable.size(context, 5))),
                  ),
                ))
                    .toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: questionModel.listAnswer
                    .sublist(2)
                    .map((item) => Container(
                  margin: EdgeInsets.all(Resizable.padding(context, 2)),
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(AppConfigs.getDataUrl(
                            "${cubit.gradingType}_${TextUtils.getName()}_$item",
                            cubit.token)),
                        fit: BoxFit.fill),
                    border: Border.all(color: secondaryColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(Resizable.size(context, 5))),
                  ),
                ))
                    .toList())
          ],
        ]);
  }
}
