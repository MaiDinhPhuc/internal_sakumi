import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'class_item_statistic.dart';
import 'class_statistic_item_layout.dart';
import 'detail_class_statistic_cubit.dart';
import 'filter_class_type_detail.dart';
import 'filter_course_level_detail.dart';
import 'filter_course_type_detail.dart';

class DetailClassStatisticDialog extends StatelessWidget {
  DetailClassStatisticDialog({super.key, required this.filterController})
      : detailCubit = DetailClassStatisticCubit(filterController.classStatisticCubit);
  final DetailClassStatisticCubit detailCubit;
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailClassStatisticCubit, int>(
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
                        FilterCourseLevelDetail(detailCubit),
                        FilterCourseTypeDetail(detailCubit),
                        FilterClassTypeDetail(detailCubit),
                      ],
                    )),
                    Expanded(
                        child:detailCubit.getListClass(filterController).isNotEmpty? Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 10)),
                                child: ClassStatisticItemRowLayout(
                                  widgetClassCode: Text(AppText.txtClassCode.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetCourse: Text(
                                      AppText.txtCourse.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetStatus: Container(),
                                  widgetEndDay: Text(AppText.txtEndDate.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetEvaluate: Text(AppText.txtEvaluate.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetLessons: Text(AppText.txtNumberOfLessons.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                  widgetStartDay: Text(AppText.txtStartDate.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)),
                                )),
                            Expanded(
                                child:  SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...detailCubit.getListClass(filterController)
                                          .map((e) => Container(
                                        constraints: BoxConstraints(maxHeight: Resizable.size(context, 50)),
                                        child: ClassStatisticItem(
                                            classModel: e, detailCubit: detailCubit),
                                      ))
                                          .toList(),
                                    ],
                                  ),
                                ) )
                          ],
                        ): Center(
                          child: Text(AppText.txtNotBill.text),
                        ))
                  ],
                ),
              ));
        });
  }
}