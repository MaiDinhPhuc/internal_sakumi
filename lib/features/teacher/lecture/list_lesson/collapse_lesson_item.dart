import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class CollapseLessonItem extends StatelessWidget {
  final int index;
  final String title;
  const CollapseLessonItem(this.index, this.title, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LessonTabCubit>(context);
    debugPrint('==============> CollapseLessonItem ${index} ==== ${cubit.listLessonResult!.length}');
    return LessonItemRowLayout(
      lesson: Text(
          '${AppText.txtLesson.text} ${index + 1 < 10 ? '0${index + 1}' : '${index + 1}'}'
              .toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 20))),
      name: Text(title.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16))),
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
      attend: cubit.listRateAttend == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (index > cubit.listLessonResult!.length - 1) ? Container(): CircleProgress(
        title: '${(cubit.listRateAttend![index]*100).toStringAsFixed(0)} %',
        lineWidth: Resizable.size(context, 3),
        percent: cubit.listRateAttend![index],
        radius: Resizable.size(context, 16),
        fontSize: Resizable.font(context, 14),
      ),
      submit: cubit.listRateSubmit == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (index > cubit.listLessonResult!.length - 1) ? Container() :CircleProgress(
        title: '${(cubit.listRateSubmit![index]*100).toStringAsFixed(0)} %',
        lineWidth: Resizable.size(context, 3),
        percent: cubit.listRateSubmit![index],
        radius: Resizable.size(context, 16),
        fontSize: Resizable.font(context, 14),
      ),//Text(cubit.listRateSubmit![index].toStringAsFixed(2).toString()),
      mark: cubit.listMarked == null
          ? Transform.scale(
              scale: 0.75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (index > cubit.listLessonResult!.length - 1)
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 4),
                      horizontal: Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10000),
                      color: cubit.listMarked![index] == true
                          ? greenColor
                          : redColor),
                  child: Text(
                    (cubit.listMarked![index] == true
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
