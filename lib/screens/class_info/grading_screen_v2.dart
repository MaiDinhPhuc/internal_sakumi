import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/filter_grading_tab.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/list_grading_item.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_cubit_v2.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class GradingScreen extends StatelessWidget {
  GradingScreen({super.key}) : cubit = GradingCubitV2(int.parse(TextUtils.getName()));
  final GradingCubitV2 cubit;

  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(10, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(
              index: 3, classId: cubit.classId.toString(), role: 'teacher'),
          BlocBuilder<GradingCubitV2, int>(
              bloc: cubit,
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
                            vertical:
                            Resizable.padding(context, 20)),
                        child: Text(
                            '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize:
                                Resizable.font(context, 30))),
                      ),
                      cubit.loading == true
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
  }
}