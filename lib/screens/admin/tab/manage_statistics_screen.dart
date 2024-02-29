import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/bill_statistic_view.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/class_statistic/class_statistic_view.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/filter_manage_statistic_view.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/student_statistic_view.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ManageStatisticsScreen extends StatelessWidget {
  const ManageStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filterController = BlocProvider.of<StatisticFilterCubit>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminAppBar(index: 3),
          BlocBuilder<StatisticFilterCubit, int>(
              bloc: filterController,
              builder: (c, s) {
                return Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 70)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Resizable.padding(context, 30)
                            ),
                            child: Text(AppText.titleStatisticsDashboard.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: Resizable.font(context, 28))),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 30),
                                  vertical: Resizable.padding(context, 15)),
                              decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.circular(
                                      Resizable.size(context, 5))),
                              child: FilterManageStatistic(
                                  filterController: filterController))),
                      Expanded(
                          flex: 6,
                          child: filterController.tabType == 'student'
                              ? StudentStatisticView(
                                  filterController: filterController)
                              : filterController.tabType == 'class'
                                  ? ClassStatisticView(
                                      filterController: filterController)
                                  : BillStatisticView(
                                      filterController: filterController))
                    ],
                  ),
                ));
              })
        ],
      ),
    );
  }
}
