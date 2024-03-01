import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/student_log_statistic_item.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic/student_statistic_item_layout.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_student_statistic_cubit.dart';

class DetailStudentStatisticDialog extends StatelessWidget {
  DetailStudentStatisticDialog({super.key, required this.filterController})
      : detailCubit = DetailStudentStatisticCubit(filterController.studentStatisticCubit.listLog);
  final DetailStudentStatisticCubit detailCubit;
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStudentStatisticCubit, int>(
        bloc: detailCubit,
        builder: (c, s) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.textDetail.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 25),
                                color: greyColor.shade600)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/ic_dropped.png',
                            color: greyColor.shade600,
                            height: Resizable.size(context, 15),
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // FilterCourseLevelDetail(detailCubit),
                        // FilterCourseTypeDetail(detailCubit),
                        // FilterClassTypeDetail(detailCubit),
                      ],
                    )),
                    Expanded(
                        child:detailCubit.getListLog(filterController).isNotEmpty? Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 10)),
                                child: StudentStatisticItemRowLayout(
                                  widgetClassCode: Text(AppText.txtClassCode.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetStudentPhone: Text(
                                      AppText.txtPhone.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetStatus: Container(),
                                  widgetStudentName: Text(AppText.txtStdName.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetContent: Text(AppText.txtContent.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600))
                                )),
                            Expanded(
                                child:  SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...detailCubit.getListLog(filterController)
                                          .map((e) => Container(
                                        constraints: BoxConstraints(maxHeight: Resizable.size(context, 50)),
                                        child: LogStatisticItem(
                                            logModel: e, detailCubit: detailCubit),
                                      ))
                                          .toList(),
                                    ],
                                  ),
                                ) )
                          ],
                        ): Center(
                          child: Text(AppText.txtNotLog.text),
                        ))
                  ],
                ),
              ));
        });
  }
}