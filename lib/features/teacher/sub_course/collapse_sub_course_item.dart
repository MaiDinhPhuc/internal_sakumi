import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/sub_course/sub_course_item_layout.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseSubCourseItem extends StatelessWidget {
  const CollapseSubCourseItem({super.key, required this.index, required this.lesson, required this.dropDown});
  final int index;
  final LessonModel lesson;
  final Widget dropDown;
  @override
  Widget build(BuildContext context) {
    return SubCourseItemLayout(
        dropdown: dropDown,
        lesson: Text("${AppText.txtLesson.text.toUpperCase()} ${index+1}",
            style: TextStyle(
                color: lesson.isCustom ? primaryColor :Colors.black,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 20))),
        title: Text(lesson.title.toUpperCase(),
            style: TextStyle(
                color: lesson.isCustom ? primaryColor :Colors.black,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 20))));
  }
}
