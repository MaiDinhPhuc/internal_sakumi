import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'lesson_item_cubit_v2.dart';

class CollapseLessonItemV2 extends StatelessWidget {
  const CollapseLessonItemV2(
      {Key? key, required this.cubit, required this.index})
      : super(key: key);
  final LessonItemCubitV2 cubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return LessonItemRowLayout(
      lesson: Text(
          '${AppText.txtLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
              .toUpperCase(),
          style: TextStyle(
              color: cubit.lesson.isCustom ? primaryColor : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 20))),
      name: Padding(
          padding: EdgeInsets.only(left: Resizable.padding(context, 10)),
          child: Text(cubit.lesson.title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: cubit.lesson.isCustom ? primaryColor : Colors.black,
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
      attend: cubit.stdLessons == null || cubit.lessonResult == null
          ? Container()
          : CircleProgress(
              title:
                  '${(cubit.getAttendancePercent() * 100).toStringAsFixed(0)} %',
              lineWidth: Resizable.size(context, 3),
              percent: cubit.getAttendancePercent(),
              radius: Resizable.size(context, 16),
              fontSize: Resizable.font(context, 14),
            ),
      submit: cubit.stdLessons == null || cubit.lessonResult == null
          ? Container()
          : cubit.lesson.isCustom
              ? CircleProgress(
                  title:
                      '${(cubit.getHwPercentCustom() * 100).toStringAsFixed(0)} %',
                  lineWidth: Resizable.size(context, 3),
                  percent: cubit.getHwPercentCustom(),
                  radius: Resizable.size(context, 16),
                  fontSize: Resizable.font(context, 14),
                )
              : CircleProgress(
                  title: '${(cubit.getHwPercent() * 100).toStringAsFixed(0)} %',
                  lineWidth: Resizable.size(context, 3),
                  percent: cubit.getHwPercent(),
                  radius: Resizable.size(context, 16),
                  fontSize: Resizable.font(context, 14),
                ),
      mark: cubit.lessonResult == null
          ? Container()
          : cubit.lesson.isCustom
              ? cubit.checkGradingCustom() == null
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 4),
                          horizontal: Resizable.padding(context, 10)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10000),
                          color: cubit.checkGradingCustom()! == true
                              ? greenColor
                              : redColor),
                      child: Text(
                        (cubit.checkGradingCustom()! == true
                                ? AppText.txtMarked.text
                                : AppText.txtNotMark.text)
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Resizable.font(context, 14),
                            fontWeight: FontWeight.w800),
                      ))
              : cubit.checkGrading() == null
                  ? Container()
                  : Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 4),
                          horizontal: Resizable.padding(context, 10)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10000),
                          color: cubit.checkGrading()! == true
                              ? greenColor
                              : redColor),
                      child: Text(
                        (cubit.checkGrading()! == true
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
