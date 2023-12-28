import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/class_item_v2.dart';
import 'package:internal_sakumi/features/admin_v2/manage_class_v2/filter_class_type_v2.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

class ManageClassScreenV2 extends StatelessWidget {
  const ManageClassScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    var filterController = BlocProvider.of<AdminClassFilterCubit>(context);
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
                          if(filterController.listClass != null)
                            FilterTypeAdminV2(filterController)
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
                  BlocBuilder<AdminClassFilterCubit, int>(
                      builder: (context, _) => filterController.listClass== null
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
                          : filterController.listClass!.isNotEmpty
                          ? Column(children: [
                        ...filterController.listClass!
                            .map((e) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.size(context, 150)),
                            child: ClassItemV2(classModel: e)))
                            .toList(),
                      ])
                          : Center(
                        child: Text(AppText.txtNoClass.text),
                      )),
                  SizedBox(height: Resizable.size(context, 50)),
                ],
              )))
        ],
      ),
    );
  }
}
