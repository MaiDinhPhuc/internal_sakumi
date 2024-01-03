import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/over_view/class_overview_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/over_view/collapse_overview_student_v2.dart';
import 'package:internal_sakumi/features/class_info/over_view/expanded_overview_student_v2.dart';
import 'package:internal_sakumi/features/class_info/over_view/statistic_class_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ClassOverViewScreenV2 extends StatelessWidget {
  ClassOverViewScreenV2({super.key, required this.role})
      : cubit = ClassOverViewCubitV2(int.parse(TextUtils.getName()));
  final String role;
  final ClassOverViewCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 0, classId: TextUtils.getName(), role: role),
          BlocBuilder<ClassOverViewCubitV2, int>(
              bloc: cubit,
              builder: (c, _) {
                return cubit.classModel == null
                    ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 100)),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 20)),
                              child: Text(
                                  '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 30))),
                            ),
                            StatisticClassViewV2(cubit:cubit),
                            Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.padding(context, 30)),
                                padding: EdgeInsets.only(
                                    right: Resizable.padding(context, 15)),
                                child: OverviewItemRowLayout(
                                    icon: Container(),
                                    name: Text(AppText.txtName.text,
                                        style: TextStyle(
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17))),
                                    attend: Text(AppText.txtRateOfAttendance.text,
                                        style: TextStyle(
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17))),
                                    submit: Text(
                                        AppText.txtRateOfSubmitHomework.text,
                                        style: TextStyle(
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17))),
                                    point: Text(AppText.txtAveragePoint.text,
                                        style:
                                            TextStyle(color: const Color(0xff757575), fontWeight: FontWeight.w600, fontSize: Resizable.font(context, 17))),
                                    dropdown: Container(),
                                    evaluate: Text(AppText.txtEvaluate.text, style: TextStyle(color: const Color(0xff757575), fontWeight: FontWeight.w600, fontSize: Resizable.font(context, 17))))),
                            cubit.listStdClass == null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...shimmerList
                                              .map((e) => const ItemShimmer())
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      ...cubit.listStdClass!
                                          .map((e) => Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: Resizable.padding(
                                                        context, 5)),
                                                child: BlocProvider(
                                                    create: (context) =>
                                                        DropdownCubit(),
                                                    child: BlocBuilder<
                                                            DropdownCubit, int>(
                                                        builder: (c, state) =>
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width: Resizable.size(
                                                                            context, 1),
                                                                        color: state % 2 == 0 ? greyColor.shade100 : Colors.black),
                                                                    borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
                                                                child: AnimatedCrossFade(
                                                                    firstChild: CollapseOverviewStudentV2(cubit: cubit, role: role, stdClass: e),
                                                                    secondChild: Column(
                                                                      children: [
                                                                        CollapseOverviewStudentV2(cubit: cubit, role: role, stdClass: e),
                                                                        ExpandedOverViewStudentV2(stdClass: e, cubit: cubit)
                                                                      ],
                                                                    ),
                                                                    crossFadeState: state % 2 == 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                                                    duration: const Duration(milliseconds: 100))))),
                                              ))
                                          .toList(),
                                      SizedBox(
                                          height: Resizable.size(context, 50))
                                    ],
                                  )
                          ],
                        ),
                      )));
              })
        ],
      ),
    );
  }
}
