import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'class_overview_cubit_v2.dart';
import 'icon_tool_tip_v2.dart';

class CollapseOverviewStudentV2 extends StatelessWidget {
  const CollapseOverviewStudentV2(
      {Key? key,
      required this.role,
      required this.stdClass,
      required this.cubit})
      : super(key: key);
  final String role;
  final StudentClassModel stdClass;
  final ClassOverViewCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    int index = cubit.listStdClass!.indexOf(stdClass);
    return Container(
        padding: EdgeInsets.only(
          right: Resizable.padding(context, 15),
        ),
        child: OverviewItemRowLayout(
            icon: IconToolTipV2(role: role, cubit: cubit, stdClass: stdClass),
            name: Text(
                cubit.students!.length - 1 < index
                    ? ""
                    : "${cubit.students![index].name} - ${cubit.students![index].studentCode}",
                style: TextStyle(
                    fontSize: Resizable.font(context, 20),
                    color: const Color(0xff131111),
                    fontWeight: FontWeight.w500)),
            attend: cubit.listStdDetail.length - 1 < index
                ? CircleProgress(
                    title: '0 %',
                    lineWidth: Resizable.size(context, 3),
                    percent: 0,
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  )
                : CircleProgress(
                    title:
                        '${(cubit.listStdDetail[index]["attendancePercent"] * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: cubit.listStdDetail[index]["attendancePercent"],
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
            submit: cubit.listStdDetail.length - 1 < index
                ? CircleProgress(
                    title: '0 %',
                    lineWidth: Resizable.size(context, 3),
                    percent: 0,
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  )
                : CircleProgress(
                    title:
                        '${(cubit.listStdDetail[index]["hwPercent"] * 100).toStringAsFixed(0)} %',
                    lineWidth: Resizable.size(context, 3),
                    percent: cubit.listStdDetail[index]["hwPercent"],
                    radius: Resizable.size(context, 16),
                    fontSize: Resizable.font(context, 14),
                  ),
            point: cubit.listStdDetail.length - 1 < index
                ? Container()
                : cubit.getGPAPoint(index) == null
                    ? Container()
                    : Container(
                        height: Resizable.size(context, 30),
                        width: Resizable.size(context, 30),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Resizable.size(context, 1),
                                color: greyColor.shade100),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
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
