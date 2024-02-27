import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'bill_statistic_cubit.dart';

class ChartStatisticData {
  ChartStatisticData(this.x, this.y);

  final String x;
  final double y;
}

class BillStatisticChart extends StatelessWidget {
  BillStatisticChart({super.key, required this.billStatisticCubit});
  final TooltipBehavior  tooltip = TooltipBehavior(enable: true);
  final BillStatisticCubit billStatisticCubit;
  @override
  Widget build(BuildContext context) {
    List<ChartStatisticData> yenData = billStatisticCubit.yenData;
    List<ChartStatisticData> vndData = billStatisticCubit.vndData;
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(interval: 1),
        tooltipBehavior: tooltip,
        series: <CartesianSeries<ChartStatisticData, String>>[
          ColumnSeries<ChartStatisticData, String>(
              dataSource: yenData,
              xValueMapper: (ChartStatisticData data, _) => data.x,
              yValueMapper: (ChartStatisticData data, _) => data.y,
              name: 'Yên Nhật(¥)',
              color: primaryColor),
          ColumnSeries<ChartStatisticData, String>(
              dataSource: vndData,
              xValueMapper: (ChartStatisticData data, _) => data.x,
              yValueMapper: (ChartStatisticData data, _) => data.y,
              name: 'Tiền Việt(VNĐ)',
              color: primaryColor)
        ]);
  }
}
