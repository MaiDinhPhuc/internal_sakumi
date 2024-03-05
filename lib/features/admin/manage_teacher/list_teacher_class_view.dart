import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

import 'filter_class_status_manage_teacher.dart';
import 'item_teacher_class.dart';

class ListTeacherClassView extends StatelessWidget {
  const ListTeacherClassView({super.key, required this.cubit});
  final TeacherInfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return cubit.isLoading == true
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Resizable.size(context, 10)),
                  ...shimmerList.map((e) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.size(context, 0)),
                      child: const ItemShimmer()))
                ],
              ),
            ),
          )
        : cubit.teacherClasses!.isEmpty
            ? Text(AppText.txtNotTeacherClass.text,
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
                  Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilterClassStatusManageTeacher(cubit: cubit)
                    ],
                  )),
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
                  ...cubit.getClasses().map(
                      (e) => ItemTeacherClass(classModel: e, cubit: cubit))
                ],
              );
  }
}
