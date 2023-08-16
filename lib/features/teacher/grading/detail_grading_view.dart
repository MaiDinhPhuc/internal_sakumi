import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'alert_grading_done.dart';
import 'answer_view/only_text_view.dart';
import 'answer_view/sound_view.dart';
import 'detail_grading_cubit.dart';
import 'drop_down_grading_widget.dart';
import 'answer_view/image_view.dart';

class DetailGradingView extends StatelessWidget {
  const DetailGradingView(this.cubit,this.soundCubit, {super.key});
  final DetailGradingCubit cubit;
  final SoundCubit soundCubit;

  @override
  Widget build(BuildContext context) {
    return cubit.listAnswer == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ...cubit.answers.map((e) => Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10),
                      horizontal: Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5)),
                      color: Colors.white),
                  child:e.answer.isEmpty? Row(
                    children: [
                      Text(
                        AppText.textStudentNotDo.text,
                        style: TextStyle(
                            fontSize: Resizable.font(
                                context, 20),
                            fontWeight:
                            FontWeight.w700,
                            color: Colors.black),
                      )
                    ],
                  ): Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 7,
                          child: (e.questionType == 1 ||
                              e.questionType == 5 ||
                              e.questionType == 6 ||
                              e.questionType == 7 ||
                              e.questionType == 8)
                              ? OnlyTextView(
                            answer: e,
                          )
                              : (e.questionType == 4 ||
                              e.questionType == 2 ||
                              e.questionType == 11)
                              ? ImageView(answer: e)
                              : SoundView(answer: e,soundCubit: soundCubit)),
                      Expanded(
                        key: Key("${e.questionId}_${e.studentId}"),
                          flex: 2,
                          child: BlocProvider(
                            create: (context)=>DropdownGradingCubit(cubit.listAnswer![cubit.listAnswer!.indexOf(e)].score != -1 ?
                            cubit.listAnswer![cubit.listAnswer!.indexOf(e)].score.toString()
                                :cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore == null
                                  ? AppText.textGradingScale.text
                                  : cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore.toString()),
                            child: BlocBuilder<DropdownGradingCubit, String>(
                              builder: (c,s){
                                return DropDownGrading(items: [
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
                                ], onChanged: (item) {
                                  if(item != AppText.textGradingScale.text){
                                    BlocProvider.of<DropdownGradingCubit>(c).change(item!);
                                    cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore = int.parse(item);
                                  }else{
                                    BlocProvider.of<DropdownGradingCubit>(c).change(item!);
                                    cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore = -1;
                                  }
                                  FirebaseFirestore.instance
                                      .collection('answer')
                                      .doc('student_${e.studentId}_homework_question_${e.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 2)}')
                                      .update({
                                    'score': cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore,
                                  });
                                  if(cubit.listAnswer![cubit.listAnswer!.indexOf(e)].score == -1  &&  cubit.listAnswer![cubit.listAnswer!.indexOf(e)].newScore != -1){
                                    cubit.count++;
                                    print("==========>count now: ${cubit.count}");
                                  }
                                  if(cubit.count == cubit.listAnswer!.length){
                                    alertGradingDone(context, ()async{
                                      Navigator.of(context).pop();
                                      await Navigator.pushNamed(
                                          context,
                                          "${Routes.teacher}?name=${TextUtils.getName(position: 1)}/grading/class?id=${TextUtils.getName(position: 2)}");
                                    });
                                  }
                                }, value: s);
                              },
                            ),
                          ))
                    ],
                  ),
                )),
                // Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 15)),child: ElevatedButton(
                //   onPressed: (){
                //
                //   },
                //   style: ButtonStyle(
                //       shadowColor: MaterialStateProperty.all(
                //           primaryColor ),
                //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
                //           borderRadius:
                //           BorderRadius.circular(Resizable.padding(context, 1000)))),
                //       backgroundColor: MaterialStateProperty.all(
                //           primaryColor ),
                //       padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                //           horizontal: Resizable.padding(context, 30)))),
                //   child: Text(AppText.btnUpdate.text.toUpperCase(),
                //       style: TextStyle(
                //           fontWeight: FontWeight.w700,
                //           fontSize: Resizable.font(context, 16),
                //           color: Colors.white)),
                // ),)
              ],
            ),
          );
  }
}

class DropdownGradingCubit extends Cubit<String>{
  DropdownGradingCubit(this.value):super(value);

  final String value;
  change(String value){
    emit(value);
  }
}
