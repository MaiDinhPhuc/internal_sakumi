import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/grading/question_option.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/detail_grading_cubit.dart';
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
                              margin: EdgeInsets.only(top: Resizable.size(context, 15), left: Resizable.size(context, 150), bottom: Resizable.size(context, 15)),
                              width: Resizable.size(context, 70),
                              child: TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios_new, size: Resizable.size(context, 15),color: greyColor.shade500),
                                    Text(AppText.textBack.text, style: TextStyle(color: greyColor.shade500, fontSize: Resizable.font(context, 20)))
                                  ],
                                ),
                              )
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:MediaQuery.of(context).size.height,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: Resizable.padding(context, 15),
                                                left:
                                                MediaQuery.of(context).size.width *
                                                    0.1),
                                            child: Text(AppText.titleQuestion.text,
                                                style: TextStyle(
                                                    fontSize:
                                                    Resizable.font(context, 20),
                                                    color: greyColor.shade500))),
                                        ...cubit.listQuestions!
                                            .map((e) => QuestionOptionItem(
                                          s,
                                          cubit.listQuestions!.indexOf(e),
                                          questionModel: e,
                                          onTap: () {
                                            cubit.change(e.id,c);
                                          },
                                        )),
                                      ],
                                    ),
                                  )),
                                Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: Resizable.padding(context, 15),
                                        ),
                                        child: Text("CHẤM ĐIỂM",
                                            style: TextStyle(
                                                fontSize:
                                                    Resizable.font(context, 20),
                                                color: greyColor.shade500))),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: Resizable.padding(context, 5)),
                                      padding:EdgeInsets.all(Resizable.padding(context, 5)),
                                      width:
                                      MediaQuery.of(context).size.width * 0.5,
                                      height:MediaQuery.of(context).size.height * 0.75,
                                      decoration: BoxDecoration(
                                          color: greyColor.shade100,
                                          borderRadius: BorderRadius.circular(
                                              Resizable.size(context, 5))),
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
