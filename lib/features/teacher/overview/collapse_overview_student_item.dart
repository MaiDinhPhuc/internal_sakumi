import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

class CollapseOverviewStudentItem extends StatelessWidget {
  final int index;
  const CollapseOverviewStudentItem(
      this.index,
      {
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ClassOverviewCubit>(context);
    return OverviewItemRowLayout(icon: const Icon(Icons.circle), name: Text(
        cubit.students![index].name, style: TextStyle(
      fontSize: Resizable.font(context, 20),
      color: const Color(0xff131111), fontWeight: FontWeight.w500
    )),
        attend: Container()
    //     CircleProgress(
    //   title: '${(cubit.listRateAttend![index]*100).toStringAsFixed(0)} %',
    //   lineWidth: Resizable.size(context, 3),
    //   percent: cubit.listRateAttend![index],
    //   radius: Resizable.size(context, 16),
    //   fontSize: Resizable.font(context, 14),
    // )
        , submit: Container(), point: Container(), dropdown: Container(), evaluate: Container());
  }
}
