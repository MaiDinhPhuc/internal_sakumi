import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_item.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'date_filter_report.dart';
import 'filter_report_status.dart';

class ListReportInProfileView extends StatelessWidget {
  const ListReportInProfileView(
      {super.key, required this.role, required this.cubit});
  final ReportCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, int>(
      bloc: cubit..loadTeacherReport(role),
      builder: (c, s) {
        return cubit.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: Resizable.size(context, 1),
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 15)),
                  color: greyColor.shade300,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 10),
                      vertical: Resizable.padding(context, 15)),
                  decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(
                          Resizable.size(context, 5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DateFilterReport(cubit: cubit),
                      FilterReportStatus(cubit: cubit)
                    ],
                  ),
                ),
                cubit.getListReport().isEmpty
                    ? Padding(
                    padding: EdgeInsets.only(
                        top: Resizable.padding(context, 120)),
                    child: Center(
                        child: Text(AppText.txtNoTeacherReport.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 17),
                                color: greyColor.shade600))))
                    : Column(
                  children: [
                    ...cubit.getListReport().map((e) => ReportItem(
                        reportModel: e, cubit: cubit, role: role))
                  ],
                )
              ],
            ));
      },
    );
  }
}
