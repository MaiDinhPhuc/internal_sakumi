import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/features/teacher/test/list_in_test_tab.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/text_utils.dart';

class ClassTestTab extends StatelessWidget {
  ClassTestTab(this.role, {super.key}) : cubit = TestCubit();
  final String role;
  final TestCubit cubit;

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    final shimmerList = List.generate(10, (index) => index);
    return BlocBuilder<DataCubit, int>(builder: (c, classes) {
      return Scaffold(
        body: Column(
          children: [
            HeaderTeacher(index: 2, classId: TextUtils.getName(), role: role),
            dataController.classes == null
                ? Center(
                    child: Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : BlocBuilder<TestCubit, int>(
                    bloc: cubit
                      ..load(int.parse(TextUtils.getName()), dataController),
                    builder: (cc, s) {
                      return cubit.classModel == null
                          ? Transform.scale(
                              scale: 0.75,
                              child: const CircularProgressIndicator(),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            Resizable.padding(context, 20)),
                                    child: Text(
                                        '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize:
                                                Resizable.font(context, 30))),
                                  ),
                                  cubit.listTest == null ||
                                          cubit.listTestResult == null
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: SingleChildScrollView(
                                              child: Column(
                                            children: [
                                              ...shimmerList.map((e) => Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Resizable.padding(
                                                              context, 150)),
                                                  child: const ItemShimmer()))
                                            ],
                                          )),
                                        )
                                      : ListTest(cubit: cubit, role: role)
                                ],
                              ),
                            ));
                    })
          ],
        ),
      );
    });
  }
}
