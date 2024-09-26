import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/class_cubit_v2.dart';
import 'package:internal_sakumi/features/admin/manage_class/class_item_v2.dart';
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(),
            Expanded(
                child: SingleChildScrollView(
                  child: Padding(padding:EdgeInsets.symmetric(horizontal: Resizable.padding(context, 70)) ,child: Column(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilterTeacherViewV2(classCubit: cubit, cubit: filterController)
                            ],
                          )),
                      Padding(padding: EdgeInsets.only(bottom: Resizable.padding(context, 10)),child: ClassItemRowLayout(
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
                                  ...shimmerList.map((e) => const ItemShimmer())
                                ],
                              ),
                            ),
                          )
                              : cubit.listClass!.isNotEmpty
                              ? Column(children: [
                            ...cubit.listClass!
                                .map((e) => ClassItemV2(classModel: e, classCubit: cubit))
                                .toList()
                          ])
                              : Text(AppText.txtNoClass.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 17),
                                  color: greyColor.shade600))),
                      SizedBox(height: Resizable.size(context, 50)),
                    ],
                  )),
                )),
          ],
        ));
  }
}
