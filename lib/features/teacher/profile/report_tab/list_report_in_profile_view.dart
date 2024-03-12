import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_item.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/teacher_report_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'date_filter_report.dart';
import 'filter_report_status.dart';

class ListReportInProfileView extends StatelessWidget {
  const ListReportInProfileView(
      {super.key, required this.role, required this.cubit});
  final TeacherReportCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherReportCubit, int>(
      bloc: cubit..loadReport(role),
      builder: (c, s) {
        return Padding(
          padding: EdgeInsets.only(top: Resizable.padding(context, 20)),
          child: cubit.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        bottom: Resizable.padding(context, 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateFilterReport(cubit: cubit),
                        FilterReportStatus(cubit: cubit)],
                    )),
                cubit.getListReport().isEmpty?
                Center(
                    child: Text(AppText.txtNoReport.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 17),
                            color: greyColor.shade600))):Column(
                  children: [
                    ...cubit.getListReport().map((e) => ReportItem(reportModel: e, cubit: cubit, role: role))
                  ],
                )

              ],
            )
          ),
        );
      },
    );
  }
}
