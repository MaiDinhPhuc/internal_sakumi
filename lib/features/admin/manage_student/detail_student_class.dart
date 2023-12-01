import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/student_info_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_student_lesson_item.dart';

class DetailStudentClassInfo extends StatelessWidget {
  const DetailStudentClassInfo({super.key, required this.stdInFo});
  final StudentInfoModel stdInFo;
  @override
  Widget build(BuildContext context) {
    return stdInFo.lessonResults == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: Column(
              children: [
                SizedBox(height: Resizable.padding(context, 10)),
                ...stdInFo.lessonResults!.map((e) => DetailStudentLessonItem(
                      title: stdInFo.getTitle(e.lessonId),
                      index: stdInFo.lessonResults!.indexOf(e) + 1,
                      attendance:stdInFo.getStudentLesson(e.lessonId) == null? null : stdInFo.getStudentLesson(e.lessonId)!.timekeeping,
                      hw: stdInFo.getStudentLesson(e.lessonId) == null? null :stdInFo.getStudentLesson(e.lessonId)!.hw,
                    ))
              ],
            ));
  }
}
