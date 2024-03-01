import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'class_statistic_item_layout.dart';
import 'detail_class_statistic_cubit.dart';

class ClassStatisticItem extends StatelessWidget {
  const ClassStatisticItem({super.key, required this.detailCubit, required this.classModel});
  final DetailClassStatisticCubit detailCubit;
  final ClassModel classModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1),
              color: greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))
      ),
      child: ClassStatisticItemRowLayout(
        widgetClassCode: Text(classModel.classCode,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 17),
                color: greyColor.shade600)),
        widgetCourse: Text(
            detailCubit.getCourse(classModel.courseId),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 17),
                color: greyColor.shade600)),
        widgetStatus: Tooltip(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                    color: Colors.black,
                    width: Resizable.size(context, 1)),
                borderRadius:
                BorderRadius.circular(Resizable.size(context, 5))),
            richMessage: WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: vietnameseSubText(classModel.classStatus),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.white),
                      ),
                    ),
                  ],
                )),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                    color: classModel.getColor(),
                    borderRadius:
                    BorderRadius.horizontal(
                        left: Radius.circular(
                            Resizable.padding(context, 5)))),
                child: Image.asset('assets/images/ic_${classModel.getIcon()}.png'),
              ),
            )),
        widgetEndDay: Text(detailCubit.convertDate(classModel.endTime),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 17),
                color: greyColor.shade600)),
        widgetEvaluate: Container(
          width: Resizable.size(context, 20),
          height: Resizable.size(context, 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
          child: Text('A',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: Resizable.font(context, 30))),
        ),
        widgetLessons: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left:Resizable.padding(context, 0)),
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: Resizable.size(context, 6),
                      animationDuration: 2000,
                      percent: detailCubit.getPercent(classModel.classId),
                      center: const SizedBox(),
                      barRadius: const Radius.circular(10000),
                      backgroundColor: greyColor.shade100,
                      progressColor: primaryColor,
                    ))),
            Container(
              alignment: Alignment.centerRight,
              constraints:
              BoxConstraints(minWidth: Resizable.size(context, 50)),
              child: Text(
                  '${detailCubit.getLessonResult(classModel.classId)}/${detailCubit.getCountLesson(classModel.classId)} ${AppText.txtLesson.text.toLowerCase()}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 16))),
            )
          ],
        ),
        widgetStartDay: Text(detailCubit.convertDate(classModel.startTime),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 17),
                color: greyColor.shade600)),
      )
    );
  }
}
