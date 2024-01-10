import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

// void alertView(BuildContext context, String note, DataCubit dataCubit) {
//   showDialog(
//       context: context,
//       builder: (_) {
//         return Dialog(
//             backgroundColor: Colors.white,
//             insetPadding: const EdgeInsets.all(10),
//             child: Container(
//               width: MediaQuery.of(context).size.width / 3,
//               padding: EdgeInsets.all(Resizable.padding(context, 20)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     AppText.titleNoteForSenseiAfterTeach.text,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: Resizable.font(context, 20)),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Resizable.padding(context, 15)),
//                     child: Text(
//                       AppText.txtNoteForSenseiAfterTeach.text,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: Resizable.font(context, 20)),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Resizable.padding(context, 15)),
//                     child: Text(
//                       AppText.txtQuestionForSenseiAfterTeach.text,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: Resizable.font(context, 20)),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: ButtonStyle(
//                             shadowColor:
//                                 MaterialStateProperty.all(Colors.black),
//                             shape: MaterialStateProperty.all(
//                                 RoundedRectangleBorder(
//                                     side: const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(
//                                         Resizable.padding(context, 1000)))),
//                             backgroundColor:
//                                 MaterialStateProperty.all(Colors.white),
//                             padding: MaterialStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     horizontal:
//                                         Resizable.padding(context, 30)))),
//                         child: Text(AppText.txtBack.text,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: Resizable.font(context, 16),
//                                 color: Colors.black)),
//                       ),
//                       SubmitButton(
//                           onPressed: () {
//                             BlocProvider.of<DetailLessonCubit>(context)
//                                 .updateStatus('Waiting',dataCubit);
//                             BlocProvider.of<DetailLessonCubit>(context)
//                                 .noteForStudents(note,dataCubit);
//                             Navigator.pop(context);
//                           },
//                           title: AppText.txtAgree.text)
//                     ],
//                   )
//                 ],
//               ),
//             ));
//       });
// }
//
// void alertCompleteView(BuildContext context, Function() onPress, DataCubit dataCubit) {
//   showDialog(
//       context: context,
//       builder: (_) {
//         return Dialog(
//             backgroundColor: Colors.white,
//             insetPadding: const EdgeInsets.all(10),
//             child: Container(
//               width: MediaQuery.of(context).size.width / 3,
//               padding: EdgeInsets.all(Resizable.padding(context, 20)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     AppText.titleNoteForSenseiAfterTeach.text,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: Resizable.font(context, 20)),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Resizable.padding(context, 15)),
//                     child: Text(
//                       AppText.txtNoteForSenseiAfterComplete.text,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: Resizable.font(context, 20)),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Resizable.padding(context, 15)),
//                     child: Text(
//                       AppText.txtQuestionForSenseiAfterTeach.text,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: Resizable.font(context, 20)),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: ButtonStyle(
//                             shadowColor:
//                             MaterialStateProperty.all(Colors.black),
//                             shape: MaterialStateProperty.all(
//                                 RoundedRectangleBorder(
//                                     side: const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(
//                                         Resizable.padding(context, 1000)))),
//                             backgroundColor:
//                             MaterialStateProperty.all(Colors.white),
//                             padding: MaterialStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     horizontal:
//                                     Resizable.padding(context, 30)))),
//                         child: Text(AppText.txtBack.text,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: Resizable.font(context, 16),
//                                 color: Colors.black)),
//                       ),
//                       SubmitButton(
//                           onPressed: onPress,
//                           title: AppText.txtAgree.text)
//                     ],
//                   )
//                 ],
//               ),
//             ));
//       });
// }

void alertAssignTestView(BuildContext context, Function() onSubmit) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(Resizable.padding(context, 20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/ic_thumb_up.png",scale: 10,),
                  Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),child: Text(
                    AppText.txtSSConfirmAssignTest.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                            shadowColor:
                            MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        Resizable.padding(context, 1000)))),
                            backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal:
                                    Resizable.padding(context, 30)))),
                        child: Text(AppText.txtBack.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 16),
                                color: Colors.black)),
                      ),
                      SubmitButton(
                          onPressed: onSubmit,
                          title: AppText.txtAgree.text)
                    ],
                  )
                ],
              ),
            ));
      });
}
