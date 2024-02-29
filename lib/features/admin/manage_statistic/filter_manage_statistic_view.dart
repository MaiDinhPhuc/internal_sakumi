import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'filter_course_level_statistic.dart';
import 'filter_course_type_statistic.dart';
import 'filter_type_statistic.dart';

class FilterManageStatistic extends StatelessWidget {
  const FilterManageStatistic({super.key, required this.filterController,});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: Resizable.size(context, 300),
          height: Resizable.size(context, 40),
          decoration: BoxDecoration(
              color: greyColor.shade100,
              borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        filterController.changeTab('student');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: filterController.tabType == 'student' ? ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF757575)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows:const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ): null,
                          child: Center(child: Text(
                              AppText.txtStudent.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filterController.tabType == 'student' ?Colors.black:greyColor.shade600,
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w700,
                              )
                          ))
                      )
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        filterController.changeTab('class');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: filterController.tabType == 'class'? ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF757575)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows:const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ): null,
                          child: Center(child: Text(
                              AppText.txtClass.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filterController.tabType == 'class' ?Colors.black:greyColor.shade600,
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w700,
                              )
                          ))
                      )
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        filterController.changeTab('bill');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: filterController.tabType == 'bill' ? ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: Color(0xFF757575)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows:const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ): null,
                          child: Center(child: Text(
                              AppText.txtBill.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filterController.tabType == 'bill' ?Colors.black:greyColor.shade600,
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.w700,
                              )
                          ))
                      )
                  )),
            ],
          ),
        ),
        BlocListener<StatisticFilterCubit, int>(
            listener: (context, _) {
              filterController.loadData(filterController);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.size(context, 5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilterCourseTypeStatistic(filterController),
                  FilterCourseLevelStatistic(filterController),
                  FilterTypeStatistic(filterController)
                ],
              ),
            )),
      ],
    );
  }
}