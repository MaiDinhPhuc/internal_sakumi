import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_class/class_item_admin.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_class_status.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_class_type.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_course.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_level.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/teacher/cubit/class_item_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ManageClassesScreen extends StatelessWidget {
  const ManageClassesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context)..loadClass();
    final shimmerList = List.generate(5, (index) => index);
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 1),
          Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 20)),
                    child: Text(AppText.titleListClass.text.toUpperCase(),
                        style: TextStyle(
                          fontSize: Resizable.font(context, 30),
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 150)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilterClassTypeMenuAdmin(dataController),
                          FilterCourseMenuAdmin(dataController),
                          FilterByLevel(dataController),
                          FilterByClassStatusAdmin(dataController)
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 150)),
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
                      widgetAttendance: Text(
                          AppText.txtRateOfAttendance.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 17),
                              color: greyColor.shade600)),
                      widgetSubmit: Text(
                          AppText.txtRateOfSubmitHomework.text,
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
                    )
                  ),
                  BlocBuilder<DataCubit, int>(
                      builder: (context, _) => dataController.classNow == null
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
                          : dataController.classNow!.isNotEmpty
                          ? Column(children: [
                        ...dataController.classNow!
                            .map((e) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.size(context, 150)),
                            child: ClassItemAdmin(classItemCubit: ClassItemCubit(e), dataCubit: dataController)))
                            .toList(),
                      ])
                          : Center(
                        child: Text(AppText.txtNoClass.text),
                      )),
                  SizedBox(height: Resizable.size(context, 5)),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 150)),
                      child: DottedBorderButton(
                          AppText.btnManageClass.text.toUpperCase(),
                          onPressed: ()  {
                              Navigator.pushNamed(context,
                                  '${Routes.admin}/${Routes.manageGeneral}');

                          })),
                  SizedBox(height: Resizable.size(context, 50)),
                ],
              )))
        ],
      ),
    );
  }
}
