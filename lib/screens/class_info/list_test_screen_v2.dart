import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/test/test_item_v2.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ListTestScreenV2 extends StatelessWidget {
  ListTestScreenV2({super.key, required this.role})
      : cubit = TestCubitV2(int.parse(TextUtils.getName()));
  final String role;
  final TestCubitV2 cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(10, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 2, classId: TextUtils.getName(), role: role),
          BlocBuilder<TestCubitV2, int>(
              bloc: cubit,
              builder: (cc, s) {
                return cubit.classModel == null
                    ? Expanded(
                        child: Center(
                            child: Transform.scale(
                                scale: 0.75,
                                child: const CircularProgressIndicator())))
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
                                      fontSize: Resizable.font(context, 30))),
                            ),
                            cubit.listTest == null
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      children: [
                                        ...shimmerList.map((e) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 150)),
                                            child: const ItemShimmer()))
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      if (cubit.listTest!.isNotEmpty)
                                        Container(
                                            padding: EdgeInsets.only(
                                                right: Resizable.padding(
                                                    context, 20),
                                                left: Resizable.padding(
                                                    context, 10)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: Resizable.padding(
                                                    context, 150)),
                                            child: TestItemRowLayout(
                                              test: Text(AppText.txtTest.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff757575),
                                                      fontSize: Resizable.font(
                                                          context, 17))),
                                              name: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Resizable.padding(
                                                          context, 5)),
                                                  child: Text(
                                                      AppText.titleSubject.text,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xff757575),
                                                          fontSize:
                                                              Resizable.font(
                                                                  context,
                                                                  17)))),
                                              submit: Text(
                                                  AppText
                                                      .txtRateOfSubmitTest.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff757575),
                                                      fontSize: Resizable.font(
                                                          context, 17))),
                                              mark: Text(
                                                  AppText.txtAveragePoint.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff757575),
                                                      fontSize: Resizable.font(
                                                          context, 17))),
                                              status: Text(
                                                  AppText.titleStatus.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff757575),
                                                      fontSize: Resizable.font(
                                                          context, 17))),
                                              dropdown: Container(),
                                            )),
                                      if (cubit.listTest!.isEmpty)
                                        Center(
                                          child:
                                              Text(AppText.txtTestEmpty.text),
                                        ),
                                      if (cubit.listTest!.isNotEmpty)
                                        ...cubit.listTest!
                                            .map((e) => TestItemV2(
                                                cubit: cubit,
                                                role: role,
                                                test: e))
                                            .toList()
                                    ],
                                  )
                          ],
                        ),
                      ));
              }),
          if (role == 'teacher') FooterView()
        ],
      ),
    );
  }
}
