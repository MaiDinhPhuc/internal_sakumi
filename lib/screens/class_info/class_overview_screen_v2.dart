import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/over_view/class_overview_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/over_view/statistic_class_view.dart';
import 'package:internal_sakumi/features/class_info/over_view/student_item_overview.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
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
                    ? Expanded(
                        child: Center(
                        child: Transform.scale(
                          scale: 0.75,
                          child: const CircularProgressIndicator(),
                        ),
                      ))
                    : Expanded(
                        flex: 10,
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
                              StatisticClassViewV2(cubit: cubit),
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
                                          style: TextStyle(
                                              color: const Color(0xff757575),
                                              fontWeight: FontWeight.w600,
                                              fontSize: Resizable.font(context, 17))),
                                      dropdown: Container(),
                                      evaluate: Text(AppText.txtEvaluate.text, style: TextStyle(color: const Color(0xff757575), fontWeight: FontWeight.w600, fontSize: Resizable.font(context, 17))))),
                              cubit.loaded == false
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
                                            .map((e) => StudentItemOverView(
                                                cubit: cubit,
                                                stdClass: e,
                                                role: role))
                                            .toList(),
                                        SizedBox(
                                            height: Resizable.size(context, 50))
                                      ],
                                    )
                            ],
                          ),
                        )));
              }),
          if(role == 'teacher')
            FooterView()
        ],
      ),
    );
  }
}
