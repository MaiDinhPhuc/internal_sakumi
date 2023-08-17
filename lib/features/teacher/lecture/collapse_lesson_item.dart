import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

// class CollapseLessonItem extends StatelessWidget {
//   final LessonResultModel lessonResultModel;
//   final
//   const CollapseLessonItem(this.lessonResultModel, {Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var cubit = BlocProvider.of<ListLessonCubit>(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//             flex: 4,
//             child: Text(
//               cubit.lessons![cubit.listLessonResult!.indexOf(lessonResultModel)]
//                   .title
//                   .toUpperCase(),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: Resizable.font(context, 20)),
//             )),
//         Expanded(
//             flex: 1,
//             child:
//                 cubit.listAttendance == null || cubit.listStudentClass!.isEmpty
//                     ? Center(
//                         child: Transform.scale(
//                           scale: 0.75,
//                           child: const CircularProgressIndicator(),
//                         ),
//                       )
//                     : CircleProgress(
//                         title:
//                             '${(((cubit.listAttendance![cubit.listLessonResult!.indexOf(lessonResultModel)]) / (cubit.listStudentClass!.length)) * 100).toStringAsFixed(0)} %',
//                         lineWidth: Resizable.size(context, 3),
//                         percent: (cubit.listAttendance![cubit.listLessonResult!
//                                 .indexOf(lessonResultModel)]) /
//                             (cubit.listStudentClass!.length),
//                         radius: Resizable.size(context, 16),
//                         fontSize: Resizable.font(context, 14),
//                       )),
//         Expanded(
//             flex: 1,
//             child: cubit.listSubmitHomework == null ||
//                     cubit.listStudentClass!.isEmpty
//                 ? Center(
//                     child: Transform.scale(
//                       scale: 0.75,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   )
//                 : CircleProgress(
//                     title:
//                         '${(((cubit.listSubmitHomework![cubit.listLessonResult!.indexOf(lessonResultModel)]) / (cubit.listStudentClass!.length)) * 100).toStringAsFixed(0)} %',
//                     lineWidth: Resizable.size(context, 3),
//                     percent: (cubit.listSubmitHomework![cubit.listLessonResult!
//                             .indexOf(lessonResultModel)]) /
//                         (cubit.listStudentClass!.length),
//                     radius: Resizable.size(context, 16),
//                     fontSize: Resizable.font(context, 14),
//                   )),
//         Expanded(
//             flex: 2,
//             child: Row(
//               children: [
//                 cubit.listSubmitHomework == null ||
//                         cubit.listStudentClass!.isEmpty
//                     ? Center(
//                         child: Transform.scale(
//                           scale: 0.75,
//                           child: const CircularProgressIndicator(),
//                         ),
//                       )
//                     : Container(
//                         padding: EdgeInsets.symmetric(
//                             vertical: Resizable.padding(context, 4),
//                             horizontal: Resizable.padding(context, 10)),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10000),
//                             color: cubit.listMarked![cubit.listLessonResult!.indexOf(lessonResultModel)] == cubit.listStudentClass!.length
//                                 ? greenColor
//                                 : redColor),
//                         child: Text(
//                           (cubit.listMarked![cubit.listLessonResult!.indexOf(lessonResultModel)] ==
//                                       cubit.listStudentClass!.length
//                                   ? AppText.txtMarked.text
//                                   : AppText.txtNotMark.text)
//                               .toUpperCase(),
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: Resizable.font(context, 14),
//                               fontWeight: FontWeight.w800),
//                         )),
//               ],
//             )),
//       ],
//     );
//   }
// }

class CollapseLessonItem extends StatelessWidget {
  //final LessonResultModel lessonResultModel;
  final int index;
  final String title;
  const CollapseLessonItem(this.index, this.title, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ListLessonCubit>(context);
    return LessonItemRowLayout(
        name: Row(
          children: [
            Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  fontWeight: FontWeight.w700),
            ),
    Opacity(opacity: 0, child: CircleProgress(
        title:
        '%',
        lineWidth: Resizable.size(context, 3),
        percent: 0,
        radius: Resizable.size(context, 16),
        fontSize: Resizable.font(context, 14)),)
          ],
        ),
        attend: index > cubit.listLessonResult!.length - 1
            ? Container()
            : cubit.listAttendance == null || cubit.listStudentClass!.isEmpty
                ? Center(
                    child: Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : CircleProgress(
                    title:
                        '${(((cubit.listAttendance![index]) / (cubit.listStudentClass!.length)) * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: (cubit.listAttendance![index]) /
                        (cubit.listStudentClass!.length),
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
        submit: index > cubit.listLessonResult!.length - 1
            ? Container()
            : cubit.listAttendance == null || cubit.listStudentClass!.isEmpty
                ? Center(
                    child: Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : CircleProgress(
                    title:
                        '${(((cubit.listAttendance![index]) / (cubit.listStudentClass!.length)) * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: (cubit.listAttendance![index]) /
                        (cubit.listStudentClass!.length),
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
        mark: index > cubit.listLessonResult!.length - 1
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cubit.listSubmitHomework == null ||
                          cubit.listStudentClass!.isEmpty
                      ? Center(
                          child: Transform.scale(
                            scale: 0.75,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 4),
                              horizontal: Resizable.padding(context, 10)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10000),
                              color: cubit.listMarked![index] ==
                                      cubit.listStudentClass!.length
                                  ? greenColor
                                  : redColor),
                          child: Text(
                            (cubit.listMarked![index] ==
                                        cubit.listStudentClass!.length
                                    ? AppText.txtMarked.text
                                    : AppText.txtNotMark.text)
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w800),
                          )),
                ],
              ));
  }
}
