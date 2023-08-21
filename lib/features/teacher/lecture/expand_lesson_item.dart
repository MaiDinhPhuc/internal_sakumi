import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/track_student_item_row_layout.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'dart:ui' as ui;

// class ExpandLessonItem extends StatelessWidget {
//   final int index;
//   const ExpandLessonItem(this.index, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var cubit = BlocProvider.of<ListLessonCubit>(context);
//     String imageUrl =
//         'https://firebasestorage.googleapis.com/v0/b/demoproject-f305d.appspot.com/o/question_result_image%2Fdata%2Fuser%2F0%2Fcom.example.firebase_demo%2Fcache%2F3ec5b469-bffe-4af4-85f1-989f58bf9b34%2FScreenshot_20220719-103331.png?alt=media&token=82cfb4f3-05f5-492f-a61a-f11e8cd7acc1';
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//         imageUrl, (int _) => ImageElement()..src = imageUrl);
//     //debugPrint('===============> lesson result ${cubit.listLessonResult!.indexOf(lessonResultModel)} == ${cubit.listLessonResult!.length}');
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(AppText.titleNoteFromSupport.text,
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: Resizable.font(context, 19))),
//           NoteWidget(index > cubit.listLessonResult!.length - 1
//               ? ''
//               : cubit.listLessonResult![index].noteForSupport.toString()),
//           Text(AppText.titleNoteFromAnotherTeacher.text,
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: Resizable.font(context, 19))),
//           NoteWidget(index > cubit.listLessonResult!.length - 1
//               ? ''
//               : cubit.listLessonResult![index].noteForTeacher.toString()),
//           Container(
//             height: Resizable.size(context, 1),
//             margin:
//                 EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
//             color: const Color(0xffD9D9D9),
//           ),
//           TrackStudentItemRowLayout(
//               name: Text(
//                 AppText.txtName.text,
//                 style: TextStyle(
//                     color: const Color(0xff757575),
//                     fontWeight: FontWeight.w600,
//                     fontSize: Resizable.font(context, 17)),
//               ),
//               attendance: Text(
//                 AppText.txtAttendance.text,
//                 style: TextStyle(
//                     color: const Color(0xff757575),
//                     fontWeight: FontWeight.w600,
//                     fontSize: Resizable.font(context, 17)),
//               ),
//               submit: Text(
//                 AppText.txtDoHomeworks.text,
//                 style: TextStyle(
//                     color: const Color(0xff757575),
//                     fontWeight: FontWeight.w600,
//                     fontSize: Resizable.font(context, 17)),
//               ),
//               note: Text(
//                 AppText.titleNoteFromAnotherTeacher.text,
//                 style: TextStyle(
//                     color: const Color(0xff757575),
//                     fontWeight: FontWeight.w600,
//                     fontSize: Resizable.font(context, 17)),
//               )),
//           // SizedBox(
//           //   height: 700,
//           //   width: 200,
//           //   child: HtmlElementView(
//           //     viewType: imageUrl,
//           //   ),
//           // ),
//           //     ImageNetwork(image: 'https://firebasestorage.googleapis.com/v0/b/demoproject-f305d.appspot.com/o/question_result_image%2Fdata%2Fuser%2F0%2Fcom.example.firebase_demo%2Fcache%2F3ec5b469-bffe-4af4-85f1-989f58bf9b34%2FScreenshot_20220719-103331.png?alt=media&token=82cfb4f3-05f5-492f-a61a-f11e8cd7acc1', height: 300, width: 200,),
//           cubit.listStudent == null
//               ? Center(
//                   child: Transform.scale(
//                     scale: 0.75,
//                     child: const CircularProgressIndicator(),
//                   ),
//                 )
//               : Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: Resizable.padding(context, 8)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ...cubit.listStudent!
//                           .map((e) => TrackStudentItemRowLayout(
//                               name: Text(
//                                 e.name,
//                                 style: TextStyle(
//                                     fontSize: Resizable.font(context, 20),
//                                     fontWeight: FontWeight.w500),
//                               ),
//                               attendance:
//                               TrackingItem((cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)] == null)
//                                   ? null
//                                   : (cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)]!.timekeeping < 6 &&
//                                       cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)]!.timekeeping >
//                                           0)),
//                               submit:
//                               TrackingItem(
//                                 (cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)] == null)
//                                     ? null
//                                     : (cubit
//                                             .listStudentLessons![index]![
//                                                 cubit.listStudent!.indexOf(e)]!
//                                             .hw >
//                                         -2),
//                                 isSubmit: true,
//                               ),
//                           //note: Text('${cubit.listStudent!.indexOf(e)}' + '${cubit.listStudentLessons![index]!.length}')
//                               note: NoteWidget(cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)] == null
//                                   ? ''
//                                   : cubit.listStudentLessons![index]![cubit.listStudent!.indexOf(e)]!.teacherNote)
//                       ))
//                           .toList(),
//                     ],
//                   ),
//                 )
//         ],
//       ),
//     );
//   }
// }
