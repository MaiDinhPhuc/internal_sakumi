import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

import 'detail_student_lesson_layout.dart';

class DetailStudentLessonItem extends StatelessWidget {
  const DetailStudentLessonItem(
      {super.key,
      required this.title,
      required this.index,
      required this.attendance,
      required this.hw});
  final String title;
  final int index;
  final dynamic attendance, hw;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 15),
            vertical: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            border: Border.all(
                width: Resizable.size(context, 1), color: greyColor.shade100),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        child: StudentLessonLayout(
          widgetTitle: Row(
            children: [
              Text(
                "Buổi $index: ",
                style: TextStyle(
                    fontSize: Resizable.font(context, 17),
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              Text(title)
            ],
          ),
          widgetAttendance: Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 10)),child: TrackingItem(attendance)),
          widgetSubmit: TrackingItem(hw, isSubmit: true),
        ));
  }
}
