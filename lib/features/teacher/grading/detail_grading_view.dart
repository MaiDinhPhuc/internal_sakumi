
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'answer_view/only_text_view.dart';
import 'drop_down_grading_widget.dart';
import 'answer_view/image_view.dart';

class DetailGradingView extends StatelessWidget {
  const DetailGradingView(this.listAnswer, {super.key});
  final List<AnswerModel>? listAnswer;
  @override
  Widget build(BuildContext context) {
    return listAnswer == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              // SizedBox(
              //     width: MediaQuery.of(context).size.width *
              //         0.5,
              //     child: Row(
              //       mainAxisAlignment : MainAxisAlignment.spaceAround,
              //       children: [
              //         Expanded(
              //             flex: 6,
              //             child: Padding(
              //                 padding: EdgeInsets.only(
              //                   top: Resizable.padding(context, 10),
              //                 ),
              //                 child: Text(AppText.titleGrading.text,
              //                     style: TextStyle(
              //                         fontSize:
              //                         Resizable.font(context, 20),
              //                         fontWeight: FontWeight.w700,
              //                         color: greyColor.shade500)))),
              //         Expanded(
              //             flex: 2,
              //             child: DropDownGrading(items: [
              //               AppText.txtStudent.text,
              //               ...cubit.listStudent!.map((e) => e.name).toList()
              //             ])),
              //         PopupMenuButton(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(Resizable.size(context, 10)),
              //             ),
              //           ),
              //           itemBuilder: (context) => [
              //             PopupMenuItem(
              //               child: CheckboxListTile(
              //                 controlAffinity: ListTileControlAffinity.leading,
              //                 title: Text(AppText.textShowName.text),
              //                 value: true,
              //                 onChanged: (newValue) {},
              //               ),
              //             ),
              //             PopupMenuItem(
              //               child: CheckboxListTile(
              //                 controlAffinity: ListTileControlAffinity.leading,
              //                 title: Text(AppText.textGeneralComment.text),
              //                 value: false,
              //                 onChanged: (newValue) {},
              //               ),
              //             ),
              //           ],
              //           icon:const Icon(Icons.more_vert),
              //         )
              //       ],
              //     )
              // ),
              ...listAnswer!.map((e) => Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10),
                        horizontal: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 5,
                                child: (e.questionType == 1 ||
                                        e.questionType == 5 ||
                                        e.questionType == 6)
                                    ? Padding(padding: EdgeInsets.only(top: Resizable.padding(
                                    context, 5)),child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: e.answer.isEmpty
                                      ? [
                                    Text(
                                      AppText.textStudentNotDo.text,
                                      style: TextStyle(
                                          fontSize: Resizable.font(
                                              context, 20),
                                          fontWeight:
                                          FontWeight.w700,
                                          color: Colors.black),
                                    )
                                  ]
                                      : [
                                    OnlyTextView(
                                      answer: e,
                                    )
                                  ],
                                ))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: e.answer.isEmpty
                                            ? [
                                                Text(
                                                  AppText.textStudentNotDo.text,
                                                  style: TextStyle(
                                                      fontSize: Resizable.font(
                                                          context, 20),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                )
                                              ]
                                            : [
                                                if (e.questionType == 2 ||
                                                    e.questionType == 4)
                                                  ImageView(answer: e)
                                              ],
                                      )),
                            Expanded(
                                flex: 2,
                                child: DropDownGrading(items: [
                                  AppText.textGradingScale.text,
                                  "1",
                                  "2",
                                  "3",
                                  "4",
                                  "5",
                                  "6",
                                  "7",
                                  "8",
                                  "9",
                                  "10",
                                ]))
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          );
  }
}
