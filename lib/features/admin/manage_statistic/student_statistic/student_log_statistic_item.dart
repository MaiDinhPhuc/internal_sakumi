import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/student_statistic_item_layout.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_student_statistic_cubit.dart';


class LogStatisticItem extends StatelessWidget {
  const LogStatisticItem({super.key, required this.detailCubit, required this.logModel});
  final DetailStudentStatisticCubit detailCubit;
  final StudentClassLogModel logModel;
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
        child: StudentStatisticItemRowLayout(
            widgetClassCode: Text(detailCubit.getClassCode(logModel.classId),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17),
                    color: greyColor.shade600)),
            widgetStudentPhone: Text(
                detailCubit.getStudentPhone(logModel.userId),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17),
                    color: greyColor.shade600)),
            widgetStatus: Tooltip(
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.black, width: Resizable.size(context, 1)),
                    borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5))),
                richMessage: WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: vietnameseSubText(logModel.to),
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
                        color: logModel.color,
                        borderRadius:
                        BorderRadius.horizontal(
                            left: Radius.circular(
                                Resizable.padding(context, 5)))),
                    child: Image.asset('assets/images/ic_${logModel.icon}.png'),
                  ),
                )),
            widgetStudentName: Text(detailCubit.getStudentName(logModel.userId),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17),
                    color: greyColor.shade600)),
            widgetContent: Text(detailCubit.getContent(logModel, ),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17),
                    color: greyColor.shade600))
        )
    );
  }
}
