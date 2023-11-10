import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/features/teacher/test/test_already_view.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/features/teacher/test/test_not_already_view.dart';
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
                  ..load(dataController.classes!.firstWhere((e) =>
                  e.classModel.classId ==
                      int.parse(TextUtils.getName())), dataController),
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
                                      vertical: Resizable.padding(context, 20)),
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
                                  highlightColor:
                                  Colors.grey[100]!,
                                  child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...shimmerList.map((e) => Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: Resizable
                                                      .padding(
                                                      context,
                                                      150)),
                                              child:
                                              const ItemShimmer()))
                                        ],
                                      )),
                                )
                                    : Column(
                                        children: [
                                          if (cubit.listTest!.isNotEmpty)
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 20)),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 150)),
                                                child: TestItemRowLayout(
                                                  test: Text(
                                                      AppText.txtTest.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17))),
                                                  name: Text(
                                                      AppText.titleSubject.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17))),
                                                  submit: Text(
                                                      AppText
                                                          .txtRateOfSubmitTest
                                                          .text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17))),
                                                  mark: Text(
                                                      AppText
                                                          .txtAveragePoint.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17))),
                                                  status: Text(
                                                      AppText.titleStatus.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17))),
                                                  dropdown: Container(),
                                                )),
                                          if (cubit.listTest!.isEmpty)
                                            Center(
                                              child: Text(
                                                  AppText.txtTestEmpty.text),
                                            ),
                                          if (cubit.listTest!.isNotEmpty)
                                            ...cubit.listTest!.map(
                                                (e) => cubit.checkAlready(e.id)
                                                    ? TestAlreadyView(
                                                        e: e,
                                                        cubit: cubit,
                                                        role: role,
                                                      )
                                                    : TestNotAlreadyView(
                                                        index: cubit.listTest!
                                                            .indexOf(e),
                                                        title: e.title,
                                                        onTap: () async {
                                                          cubit.assignmentTest(
                                                              context,
                                                              int.parse(TextUtils
                                                                  .getName()),
                                                              e.courseId,
                                                              e.id);
                                                        },
                                                        role: role,
                                                      ))
                                        ],
                                      )
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
