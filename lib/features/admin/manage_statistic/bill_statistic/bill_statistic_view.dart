import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/total_bill_view.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'bill_statistic_cubit.dart';
import 'chart_bill_view.dart';
import 'header_chart_bill_statistic.dart';

class BillStatisticView extends StatelessWidget {
  const BillStatisticView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillStatisticCubit, int>(
        bloc: filterController.billStatisticCubit,
        builder: (c, s) {
          return Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TotalBillView(filterController: filterController)),
              Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10)),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: const Color(0xffE0E0E0)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: HeaderBillStatistic(
                                filterController: filterController)),
                        Expanded(
                            flex: 5,
                            child: BillStatisticChart(
                                billStatisticCubit:
                                    filterController.billStatisticCubit))
                      ],
                    ),
                  ))
            ],
          );
        });
  }
}
