import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_class_item_cubit.dart';
import 'package:internal_sakumi/model/student_info_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_student_lesson_item.dart';

class DetailStudentClassInfo extends StatelessWidget {
  const DetailStudentClassInfo({super.key, required this.itemCubit});
  final StudentClasItemCubit itemCubit;
  @override
  Widget build(BuildContext context) {
    return itemCubit.lessonResults == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: Column(
              children: [
                SizedBox(height: Resizable.padding(context, 10)),
                ...itemCubit.lessonResults!.map((e) => DetailStudentLessonItem(
                      title: itemCubit.getTitle(e.lessonId),
                      index: itemCubit.lessonResults!.indexOf(e) + 1,
                      attendance:itemCubit.getStudentLesson(e.lessonId) == null ? null : itemCubit.getStudentLesson(e.lessonId)!.timekeeping,
                      hw: itemCubit.getLesson(e.lessonId) == null? null :itemCubit.getPoint(e.lessonId),
                      isCustom: itemCubit.getLesson(e.lessonId) == null ? false : itemCubit.getLesson(e.lessonId)!.isCustom,
                    ))
              ],
            ));
  }
}
