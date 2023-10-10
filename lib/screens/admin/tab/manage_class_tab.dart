import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_class_status.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_class_type.dart';
import 'package:internal_sakumi/features/admin/manage_class/filter_by_course.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageClassTab extends StatelessWidget {
  const ManageClassTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadListClassCubit()..init(),
      child: BlocBuilder<LoadListClassCubit, int>(builder: (c, list) {
        var cubit = BlocProvider.of<LoadListClassCubit>(c);
        return cubit.data == null
            ? Transform.scale(
                scale: 0.75,
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : SingleChildScrollView(
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
                          FilterClassTypeMenuAdmin(cubit),
                          FilterCourseMenuAdmin(cubit),
                          FilterByClassStatusAdmin(cubit)
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 150)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClassItemRowLayout(
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
                        ),
                        SizedBox(height: Resizable.size(context, 10)),
                        (cubit.listClassIds!.isNotEmpty)
                            ? Column(children: [
                                ...cubit.listClassIds!
                                    .map((e) => ClassItemInAdmin(
                                        cubit.listClassIds!.indexOf(e), e))
                                    .toList(),
                              ])
                            : Center(
                                child: Text(AppText.txtNoClass.text),
                              )
                      ],
                    ),
                  ),
                  SizedBox(height: Resizable.size(context, 5)),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 150)),
                      child: DottedBorderButton(
                          AppText.btnManageClass.text.toUpperCase(),
                          onPressed: () async {
                        SharedPreferences localData =
                            await SharedPreferences.getInstance();
                        if (c.mounted) {
                          Navigator.pushNamed(context,
                              '${Routes.admin}?name=${localData.getString(PrefKeyConfigs.code)!}/${Routes.manageGeneral}');
                        }
                      })),
                  SizedBox(height: Resizable.size(context, 50)),
                ],
              ));
      }),
    );
  }
}
