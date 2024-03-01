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
  const BillStatisticChart({super.key, required this.billStatisticCubit});
  final BillStatisticCubit billStatisticCubit;
  @override
  Widget build(BuildContext context) {
    TooltipBehavior tooltip = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                seriesIndex == 0?
                Text(
                  '${series.name} : ${billStatisticCubit.getTotalYen(pointIndex)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ) : Text(
                  '${series.name} : ${billStatisticCubit.getTotalVnd(pointIndex)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Padding(padding: const EdgeInsets.only(top: 5),child: Text(
                  '${data.x} : ${data.y.toString()}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),)
              ],
            ),
          );
        }
        );

    List<ChartStatisticData> yenData = billStatisticCubit.yenData;
    List<ChartStatisticData> vndData = billStatisticCubit.vndData;
    return SfCartesianChart(
        tooltipBehavior: tooltip,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(interval: 1),
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
