import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_statistic/bill_statistic/chart_bill_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'class_statistic_cubit.dart';

class ClassStatisticChart extends StatelessWidget {
  const ClassStatisticChart({super.key, required this.classStatisticCubit});
  final ClassStatisticCubit classStatisticCubit;
  @override
  Widget build(BuildContext context) {
    TooltipBehavior tooltip = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
            padding: const EdgeInsets.all(5),
            height: 30,
            child: Text(
              '${data.x} : ${data.y.toString()}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            )
          );
        }
    );
    return SfCartesianChart(
        tooltipBehavior: tooltip,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(interval: 1),
        series: <CartesianSeries<ChartStatisticData, String>>[
          ColumnSeries<ChartStatisticData, String>(
              dataSource: classStatisticCubit.classData,
              xValueMapper: (ChartStatisticData data, _) => data.x,
              yValueMapper: (ChartStatisticData data, _) => data.y,
              color: primaryColor),
        ]);
  }
}
