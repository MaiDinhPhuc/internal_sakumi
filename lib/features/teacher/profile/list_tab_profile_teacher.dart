import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/add_new_report_dialog.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_teacher_tab_cubit.dart';

class ListTabProfileTeacher extends StatelessWidget {
  const ListTabProfileTeacher(
      {super.key, required this.cubit, required this.role});
  final ManageTeacherTabCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: cubit.tabType == 'report' && role == 'admin'
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Container(
          width: Resizable.size(context, 500),
          height: Resizable.size(context, 35),
          decoration: BoxDecoration(
              color: greyColor.shade100,
              borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        cubit.changeTab('class');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: cubit.tabType == 'class'
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF757575)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                )
                              : null,
                          child: Center(
                              child: Text(AppText.titleManageClass.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: cubit.tabType == 'class'
                                        ? Colors.black
                                        : greyColor.shade600,
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w700,
                                  )))))),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        cubit.changeTab('schedule');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: cubit.tabType == 'schedule'
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF757575)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                )
                              : null,
                          child: Center(
                              child: Text(AppText.txtSchedule.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: cubit.tabType == 'schedule'
                                        ? Colors.black
                                        : greyColor.shade600,
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w700,
                                  )))))),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        cubit.changeTab('overview');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: cubit.tabType == 'overview'
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF757575)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                )
                              : null,
                          child: Center(
                              child: Text(AppText.titleOverView.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: cubit.tabType == 'overview'
                                        ? Colors.black
                                        : greyColor.shade600,
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w700,
                                  )))))),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        cubit.changeTab('report');
                      },
                      child: Container(
                          height: Resizable.size(context, 40),
                          decoration: cubit.tabType == 'report'
                              ? ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF757575)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    )
                                  ],
                                )
                              : null,
                          child: Center(
                              child: Text(AppText.txtReport.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: cubit.tabType == 'report'
                                        ? Colors.black
                                        : greyColor.shade600,
                                    fontSize: Resizable.font(context, 18),
                                    fontWeight: FontWeight.w700,
                                  ))))))
            ],
          ),
        ),
        if (cubit.tabType == 'report' && role == 'admin')
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AddNewReportDialog(reportCubit: cubit.reportCubit, isEdit: false));
            },
            child: Container(
              width: Resizable.size(context, 100),
              height: Resizable.size(context, 35),
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 30),
                  vertical: Resizable.padding(context, 5)),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFFDADADA),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                  child: Text(
                AppText.txtAdd.text,
                style: TextStyle(
                  color: greyColor.shade600,
                  fontSize: Resizable.font(context, 18),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              )),
            ),
          )
      ],
    );
  }
}
