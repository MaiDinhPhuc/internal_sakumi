import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_view.dart';
import 'package:internal_sakumi/features/teacher/grading/drop_down_grading_widget.dart';
import 'package:internal_sakumi/features/teacher/grading/question_option.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/detail_grading_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailGradingScreen extends StatelessWidget {
  final String name;
  const DetailGradingScreen(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DetailGradingCubit()..init(context),
        child: Scaffold(
          body: Column(
            children: [
              HeaderTeacher(
                  index: 3,
                  classId: TextUtils.getName(position: 2),
                  name: name),
              BlocBuilder<DetailGradingCubit, int>(builder: (c, s) {
                var cubit = BlocProvider.of<DetailGradingCubit>(c);
                return cubit.listQuestions == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                            child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.size(context, 15),
                                    left: Resizable.size(context, 150),
                                    bottom: Resizable.size(context, 15)),
                                width: Resizable.size(context, 70),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_back_ios_new,
                                          size: Resizable.size(context, 15),
                                          color: greyColor.shade500),
                                      Text(AppText.textBack.text,
                                          style: TextStyle(
                                              color: greyColor.shade500,
                                              fontSize:
                                                  Resizable.font(context, 20)))
                                    ],
                                  ),
                                )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: Resizable.padding(
                                                      context, 15),
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1),
                                              child: Text(
                                                  AppText.titleQuestion.text,
                                                  style: TextStyle(
                                                      fontSize: Resizable.font(
                                                          context, 20),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          greyColor.shade500))),
                                          ...cubit.listQuestions!
                                              .map((e) => QuestionOptionItem(
                                                    s,
                                                    cubit.listQuestions!
                                                        .indexOf(e),
                                                    questionModel: e,
                                                    onTap: () {
                                                      cubit.change(e.id, c);
                                                    },
                                                  )),
                                        ],
                                      ),
                                    )),
                                Column(
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.5,
                                      child: Row(
                                        mainAxisAlignment : MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: Resizable.padding(context, 10),
                                                  ),
                                                  child: Text(AppText.titleGrading.text,
                                                      style: TextStyle(
                                                          fontSize:
                                                          Resizable.font(context, 20),
                                                          fontWeight: FontWeight.w700,
                                                          color: greyColor.shade500)))),
                                          Expanded(
                                              flex: 2,
                                              child: DropDownGrading(items: [
                                                AppText.txtStudent.text,
                                                ...cubit.listStudent!.map((e) => e.name).toList()
                                              ])),
                                          PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(Resizable.size(context, 10)),
                                              ),
                                            ),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: CheckboxListTile(
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  title: Text(AppText.textShowName.text),
                                                  value: true,
                                                  onChanged: (newValue) {},
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: CheckboxListTile(
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  title: Text(AppText.textGeneralComment.text),
                                                  value: false,
                                                  onChanged: (newValue) {},
                                                ),
                                              ),
                                            ],
                                            icon:const Icon(Icons.more_vert),
                                          )
                                        ],
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              Resizable.padding(context, 5)),
                                      padding: EdgeInsets.all(
                                          Resizable.padding(context, 5)),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.85,
                                      decoration: BoxDecoration(
                                          color: lightGreyColor,
                                          borderRadius: BorderRadius.circular(
                                              Resizable.size(context, 5))),
                                      child: DetailGradingView(cubit.listAnswer),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )));
              }),
            ],
          ),
        ));
  }
}
