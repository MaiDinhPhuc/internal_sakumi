import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_cubit_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_item_v2.dart';
import 'package:internal_sakumi/features/teacher/filter_teacher_view_v2.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/welcome_teacher_appbar.dart';
import 'package:internal_sakumi/providers/cache/filter_teacher_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

class TeacherScreenV2 extends StatelessWidget {
  TeacherScreenV2({super.key}) : cubit = ClassCubit();

  final ClassCubit cubit;

  @override
  Widget build(BuildContext context) {
    var filterController = BlocProvider.of<TeacherClassFilterCubit>(context);
    final shimmerList = List.generate(5, (index) => index);
    if (filterController.filter.keys.isNotEmpty) {
      cubit.loadDataTeacher(filterController);
    }
    return Scaffold(
        body: Column(
          children: [
            Container(),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const WelComeTeacherAppBar(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),
                        child: Text(
                            AppText.titleManageClass.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: Resizable.font(context, 30))),
                      ),
                      BlocListener<TeacherClassFilterCubit, int>(
                          listener: (context, _) {
                            cubit.loadDataTeacher(filterController);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Resizable.size(context, 5),
                                horizontal: Resizable.size(context, 140)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilterTeacherViewV2(classCubit: cubit, cubit: filterController)
                              ],
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.size(context, 150)),
                          child: ClassItemRowLayout(
                            widgetClassCode: Text(AppText.txtClassCode.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetCourse: Text(AppText.txtCourse.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetLessons: Text(AppText.txtNumberOfLessons.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetAttendance: Text(AppText.txtRateOfAttendance.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetSubmit: Text(AppText.txtRateOfSubmitHomework.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetEvaluate: Text(AppText.txtEvaluate.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                            widgetStatus: Text(AppText.titleStatus.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: greyColor.shade600)),
                          )),
                      BlocBuilder<ClassCubit, int>(
                          bloc: cubit,
                          builder: (context, _) => cubit.listClass == null
                              ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...shimmerList.map((e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Resizable.size(context, 150)),
                                      child: const ItemShimmer()))
                                ],
                              ),
                            ),
                          )
                              : cubit.listClass!.isNotEmpty
                              ? Column(children: [
                            ...cubit.listClass!
                                .map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                    Resizable.size(context, 150)),
                                child: ClassItemV2(classModel: e, classCubit: cubit)))
                                .toList()
                          ])
                              : const Center(
                            child: CircularProgressIndicator(),
                          )),
                      SizedBox(height: Resizable.size(context, 50)),
                    ],
                  ),
                )),
          ],
        ));
  }
}
