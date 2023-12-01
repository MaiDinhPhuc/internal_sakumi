import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/teacher_info_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_teacher_class_item.dart';

class DetailTeacherClass extends StatelessWidget {
  const DetailTeacherClass({super.key, required this.teacherInFo});
  final TeacherInfoModel teacherInFo;
  @override
  Widget build(BuildContext context) {
    return teacherInFo.lessonResults == null
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
        padding: EdgeInsets.all(Resizable.padding(context, 10)),
        child: Column(
          children: [
            SizedBox(height: Resizable.padding(context, 10)),
            ...teacherInFo.lessonResults!.map((e) => DetailTeacherClassItem(
              title: teacherInFo.getTitle(e.lessonId),
              index: teacherInFo.lessonResults!.indexOf(e) + 1,
              attendance: teacherInFo.getAttendanceForLesson(e.lessonId),
              hw: teacherInFo.getHwForLesson(e.lessonId),
            ))
          ],
        ));
  }
}
