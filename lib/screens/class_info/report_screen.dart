import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/footer/footer_view.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/add_new_report_dialog.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/date_filter_report.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/filter_report_status.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/report_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key, required this.role}) : cubit = ReportCubit();
  final String role;
  final ReportCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderTeacher(index: 5, classId: TextUtils.getName(), role: role),
          Expanded(
              child: BlocBuilder<ReportCubit, int>(
            bloc: cubit..loadClassReport(int.parse(TextUtils.getName())),
            builder: (c, s) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 70)),
                child: cubit.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 20)),
                            child: Row(
                              mainAxisAlignment: role == "admin"
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              children: [
                                Text(
                                    '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 30))),
                                if (role == "admin")
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AddNewReportDialog(
                                                  reportCubit: cubit,
                                                  isEdit: false));
                                    },
                                    child: Container(
                                      width: Resizable.size(context, 100),
                                      height: Resizable.size(context, 35),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 30),
                                          vertical:
                                              Resizable.padding(context, 5)),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Color(0xFFDADADA),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DateFilterReport(cubit: cubit),
                                  FilterReportStatus(cubit: cubit)
                                ],
                              )),
                          cubit.getListReport().isEmpty
                              ? Center(
                                  child: Text(AppText.txtNoClassReport.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Resizable.font(context, 17),
                                          color: greyColor.shade600)))
                              : Column(
                                  children: [
                                    ...cubit.getListReport().map((e) =>
                                        ReportItem(
                                            reportModel: e,
                                            cubit: cubit,
                                            role: role))
                                  ],
                                )
                        ],
                      )),
              );
            },
          )),
          if (role == 'teacher') FooterView()
        ],
      ),
    );
  }
}
