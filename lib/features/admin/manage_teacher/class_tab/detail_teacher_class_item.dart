import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/detail_student_lesson_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class DetailTeacherClassItem extends StatelessWidget {
  const DetailTeacherClassItem(
      {super.key,
      required this.title,
      required this.index,
      required this.attendance,
      required this.hw});
  final String title;
  final int index;
  final double attendance, hw;
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
          widgetAttendance: Padding(
              padding: EdgeInsets.only(left: Resizable.padding(context, 10)),
              child: CircleProgress(
                title: '${(attendance * 100).toStringAsFixed(0)} %',
                lineWidth: Resizable.size(context, 3),
                percent: attendance,
                radius: Resizable.size(context, 15),
                fontSize: Resizable.font(context, 14),
              )),
          widgetSubmit: CircleProgress(
            title: '${(hw * 100).toStringAsFixed(0)} %',
            lineWidth: Resizable.size(context, 3),
            percent: hw,
            radius: Resizable.size(context, 15),
            fontSize: Resizable.font(context, 14),
          ),
        ));
  }
}
