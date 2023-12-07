import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/filter_grading_tab.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/grading_cubit.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/list_grading_item.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ClassGradingTab extends StatelessWidget {
  ClassGradingTab({super.key}) : cubit = GradingCubit();
  final GradingCubit cubit;

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    final shimmerList = List.generate(10, (index) => index);
    return BlocBuilder<DataCubit, int>(builder: (c, classes){
      return Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
                index: 3, classId: TextUtils.getName(), role: 'teacher'),
            BlocBuilder<GradingCubit, int>(
                bloc: cubit
                  ..load(int.parse(TextUtils.getName()), dataController),
                builder: (c, s) {
              return cubit.classModel == null
                  ? Transform.scale(
                scale: 0.75,
                child: const CircularProgressIndicator(),
              )
                  :  Expanded(child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 20)),
                      child: Text(
                          '${AppText.textClass.text} ${cubit.classModel!.classCode}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 30))),
                    ),
                    cubit.students == null
                        ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor:
                      Colors.grey[100]!,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...shimmerList.map((e) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 80)),
                                  child: const ItemShimmer()))
                            ],
                          )),
                    )
                        :Column(
                      children: [
                        FilterGradingTab(cubit: cubit),
                        ListGradingItem(cubit: cubit)
                      ],
                    )
                  ],
                ),
              ));
            }),
          ],
        ),
      );
    });
  }
}
