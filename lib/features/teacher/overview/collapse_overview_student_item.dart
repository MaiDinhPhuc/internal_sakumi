import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'icon_tooltip.dart';

class CollapseOverviewStudentItem extends StatelessWidget {
  final String role;
  final StudentClassModel stdClass;
  const CollapseOverviewStudentItem(this.stdClass, this.role,
      {Key? key, required this.cubit, required this.dataCubit})
      : super(key: key);
  final ClassOverviewCubit cubit;
  final DataCubit dataCubit;

  @override
  Widget build(BuildContext context) {
    int index = cubit.listStdClass!.indexOf(stdClass);
    return Container(
        padding: EdgeInsets.only(
          right: Resizable.padding(context, 15),
        ),
        child: OverviewItemRowLayout(
            icon: IconToolTip(
                role: role,
                cubit: cubit,
                stdClass: stdClass,
                dataCubit: dataCubit),
            name: Text(
                "${cubit.students!.firstWhere((e) => e.userId == stdClass.userId).name} - ${cubit.students!.firstWhere((e) => e.userId == stdClass.userId).studentCode}",
                style: TextStyle(
                    fontSize: Resizable.font(context, 20),
                    color: const Color(0xff131111),
                    fontWeight: FontWeight.w500)),
            attend: CircleProgress(
              title:
                  '${(cubit.listStdDetail[index]["attendancePercent"] * 100).toStringAsFixed(0)} %',
              lineWidth: Resizable.size(context, 3),
              percent: cubit.listStdDetail[index]["attendancePercent"],
              radius: Resizable.size(context, 16),
              fontSize: Resizable.font(context, 14),
            ),
            submit: CircleProgress(
              title:
                  '${(cubit.listStdDetail[index]["hwPercent"] * 100).toStringAsFixed(0)} %',
              lineWidth: Resizable.size(context, 3),
              percent: cubit.listStdDetail[index]["hwPercent"],
              radius: Resizable.size(context, 16),
              fontSize: Resizable.font(context, 14),
            ),
            point: cubit.getGPAPoint(index) == null
                ? Container()
                : Container(
                    height: Resizable.size(context, 30),
                    width: Resizable.size(context, 30),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(context, 1),
                            color: greyColor.shade100),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(
                      cubit.getGPAPoint(index)!.toStringAsFixed(1),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: Resizable.font(context, 18),
                          fontWeight: FontWeight.w800),
                    ))),
            dropdown: IconButton(
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(context).update();
                },
                splashRadius: Resizable.size(context, 15),
                icon: Icon(
                  BlocProvider.of<DropdownCubit>(context).state % 2 == 0
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                )),
            evaluate: Container(
              width: Resizable.size(context, 20),
              height: Resizable.size(context, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
              child: Text('A', //TODO ADD ALGORITHM
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: Resizable.font(context, 30))),
            )));
  }
}
