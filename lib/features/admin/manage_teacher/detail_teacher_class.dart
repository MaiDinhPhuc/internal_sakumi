import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_class_item_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_teacher_class_item.dart';

class DetailTeacherClass extends StatelessWidget {
  const DetailTeacherClass({super.key, required this.itemCubit});
  final TeacherClassItemCubit itemCubit;
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
            ...itemCubit.lessonResults!.map((e) => DetailTeacherClassItem(
              title: itemCubit.getTitle(e.lessonId),
              index: itemCubit.lessonResults!.indexOf(e) + 1,
              attendance: itemCubit.getAttendanceForLesson(e.lessonId),
              hw: itemCubit.getHwForLesson(e.lessonId),
            ))
          ],
        ));
  }
}
