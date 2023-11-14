import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/collapse_overview_student_item.dart';
import 'package:internal_sakumi/features/teacher/overview/expanded_overview_student_item.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/features/teacher/overview/statistic_class_view.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:shimmer/shimmer.dart';


class ClassOverViewTab extends StatelessWidget {
  ClassOverViewTab(this.role, {super.key}) : cubit = ClassOverviewCubit();
  final String role;
  final ClassOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    final shimmerList = List.generate(5, (index) => index);
    return BlocBuilder<DataCubit, int>(
        builder: (cc, classes) => Scaffold(
              body: Column(
                children: [
                  HeaderTeacher(
                      index: 0, classId: TextUtils.getName(), role: role),
                  dataController.classes == null ? Center(
                    child: Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    ),
                  ) : BlocBuilder<ClassOverviewCubit, int>(
                      bloc: cubit
                        ..loadFirst(dataController.classes!.firstWhere((e) =>
                        e.classModel.classId ==
                            int.parse(TextUtils.getName())), dataController),
                      builder: (c, _) {
                        return cubit.classModel == null
                            ? Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        )
                            : Expanded(
                            child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 100)),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),
                                        child: Text(
                                            '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: Resizable.font(context, 30))),
                                      ),
                                      StatisticClassView(cubit),
                                      Container(
                                          margin: EdgeInsets.only(top: Resizable.padding(context, 30)),
                                          padding: EdgeInsets.only(right: Resizable.padding(context, 15)),
                                          child: OverviewItemRowLayout(
                                              icon: Container(),
                                              name: Text(AppText.txtName.text,
                                                  style: TextStyle(
                                                      color: const Color(0xff757575),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: Resizable.font(context, 17))),
                                              attend: Text(AppText.txtRateOfAttendance.text,
                                                  style: TextStyle(
                                                      color:
                                                      const Color(0xff757575),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: Resizable.font(context, 17))),
                                              submit: Text(AppText.txtRateOfSubmitHomework.text,
                                                  style: TextStyle(
                                                      color: const Color(0xff757575),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: Resizable.font(context, 17))),
                                              point: Text(AppText.txtAveragePoint.text, style: TextStyle(color: const Color(0xff757575), fontWeight: FontWeight.w600, fontSize: Resizable.font(context, 17))),
                                              dropdown: Opacity(
                                                opacity: 0,
                                                child: CircleProgress(
                                                  title: '%',
                                                  lineWidth:
                                                  Resizable.size(context, 3),
                                                  percent: 0,
                                                  radius:
                                                  Resizable.size(context, 15),
                                                  fontSize:
                                                  Resizable.font(context, 14),
                                                ),
                                              ),
                                              evaluate: Text(AppText.txtEvaluate.text, style: TextStyle(color: const Color(0xff757575), fontWeight: FontWeight.w600, fontSize: Resizable.font(context, 17))))),
                                      cubit.listStdClass == null
                                          ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ...shimmerList.map((e) =>
                                              const ItemShimmer())
                                            ],
                                          ),
                                        ),
                                      )
                                          : Column(
                                        children: [
                                          ...cubit.listStdClass!
                                              .map((e) => Container(
                                            margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                                            child: BlocProvider(
                                                create: (context) => DropdownCubit(),
                                                child: BlocBuilder<DropdownCubit, int>(
                                                    builder: (c, state) => Container(
                                                            alignment: Alignment.centerLeft,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(width: Resizable.size(context, 1), color: state % 2 == 0 ? greyColor.shade100 : Colors.black),
                                                                borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
                                                            child: AnimatedCrossFade(
                                                                firstChild: CollapseOverviewStudentItem(e, role , cubit: cubit, dataCubit: dataController),
                                                                secondChild: Column(
                                                                  children: [
                                                                    CollapseOverviewStudentItem(e, role, cubit: cubit, dataCubit: dataController),
                                                                    ExpandedOverviewStudentItem(e, cubit: cubit)
                                                                  ],
                                                                ),
                                                                crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                duration: const Duration(milliseconds: 100))))),
                                          ))
                                              .toList(),
                                          SizedBox(height: Resizable.size(context, 50))
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                      })
                ],
              ),
            ));
  }
}
