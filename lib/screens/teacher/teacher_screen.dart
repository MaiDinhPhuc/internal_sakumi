import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/class_item_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/welcome_teacher_appbar.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/teacher/teacher_home/class_item.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context)..loadClass();
    print("================>TeacherScreen");
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
        body: Column(
      children: [
        Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const WelComeTeacherAppBar(),
              //TeacherHomeFilter(cubit: dataController),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.size(context, 150)),
                  child: ClassItemRowLayout(
                    widgetClassCode: Text(AppText.txtClassCode.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetCourse: Text(AppText.txtCourse.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetLessons: Text(AppText.txtNumberOfLessons.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetAttendance: Text(AppText.txtRateOfAttendance.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetSubmit: Text(AppText.txtRateOfSubmitHomework.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetEvaluate: Text(AppText.txtEvaluate.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetStatus: Text(AppText.titleStatus.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                  )),
              BlocBuilder<DataCubit, int>(
                  builder: (context, _) => dataController.classNow == null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...shimmerList.map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.size(context, 150)),
                                    child: const ItemShimmer()))
                              ],
                            ),
                          ),
                        )
                      : dataController.classNow!.isNotEmpty
                          ? Column(children: [
                              ...dataController.classNow!
                                  .map((e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.size(context, 150)),
                                      child: ClassItem(classModel: e, classItemCubit: ClassItemCubit(e),)))
                                  .toList(),
                              SizedBox(height: Resizable.size(context, 50))
                            ])
                          : Center(
                              child: Text(AppText.txtNoClass.text),
                            ))
            ],
          ),
        )),
      ],
    ));
  }
}


