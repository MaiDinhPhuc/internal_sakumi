import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'list_lesson_cubit_v2.dart';

class CollapseLessonItemV2 extends StatelessWidget {
  const CollapseLessonItemV2 ({Key? key, required this.index, required this.title, required this.cubit}) : super(key: key);
  final int index;
  final String title;
  final ListLessonCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    return LessonItemRowLayout(
      lesson: Text(
          '${AppText.txtLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
              .toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 20))),
      name: Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 10)),child: Text(title.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16)))),
      sensei: Align(
        alignment: Alignment.center,
        child: Opacity(
          opacity: 0,
          child: CircleProgress(
            title: '0 %',
            lineWidth: Resizable.size(context, 3),
            percent: 0,
            radius: Resizable.size(context, 16),
            fontSize: Resizable.font(context, 14),
          ),
        ),
      ),
      attend: cubit.listAttendance![index] == null
          ? Container()
          : CircleProgress(
        title:
        '${(cubit.listAttendance![index]! * 100).toStringAsFixed(0)} %',
        lineWidth: Resizable.size(context, 3),
        percent: cubit.listAttendance![index]!,
        radius: Resizable.size(context, 16),
        fontSize: Resizable.font(context, 14),
      ),
      submit: cubit.listHw![index] == null
          ? Container()
          : CircleProgress(
        title: '${(cubit.listHw![index]! * 100).toStringAsFixed(0)} %',
        lineWidth: Resizable.size(context, 3),
        percent: cubit.listHw![index]!,
        radius: Resizable.size(context, 16),
        fontSize: Resizable.font(context, 14),
      ), //Text(cubit.listRateSubmit![index].toStringAsFixed(2).toString()),
      mark: cubit.listHwStatus![index] == null
          ? Container()
          : Container(
          padding: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 4),
              horizontal: Resizable.padding(context, 10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10000),
              color: cubit.listHwStatus![index] == true
                  ? greenColor
                  : redColor),
          child: Text(
            (cubit.listHwStatus![index] == true
                ? AppText.txtMarked.text
                : AppText.txtNotMark.text)
                .toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: Resizable.font(context, 14),
                fontWeight: FontWeight.w800),
          )),
      dropdown: Container(),
    );
  }
}
