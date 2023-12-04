import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'item_student_class.dart';

class ListStudentClassView extends StatelessWidget {
  const ListStudentClassView({super.key, required this.cubit});
  final StudentInfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    return cubit.listStdInfo == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : cubit.listStdInfo!.isEmpty
            ? Text(AppText.txtNotStudentClass.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 17),
                    color: greyColor.shade600))
            : Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10)),
                      child: Text(AppText.txtListStudentClass.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 24),
                              color: greyColor.shade600))),
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
                    widgetAttendance: Text(AppText.txtAttendance.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetSubmit: Text(AppText.txtDoHomeworks.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                    widgetEvaluate: Container(),
                    widgetStatus: Text(AppText.titleStatus.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600)),
                  ),
                  ...cubit.listStdInfo!.map((e) => ItemStudentClass(stdInFo: e))
                ],
              );
  }
}
