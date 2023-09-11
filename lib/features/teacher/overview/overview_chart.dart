import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/chart_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewChart extends StatelessWidget {
  final List<double> points;
  final bool isPercent;
  const OverviewChart({required this.points, this.isPercent = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Resizable.size(context, 50),
      // width: Resizable.size(context, 100),
      child: SfCartesianChart(
          primaryXAxis: NumericAxis(
            minimum: 1,
            isVisible: false,
          ),
          series: <LineSeries<ChartData, int>>[
            LineSeries<ChartData, int>(
              color: primaryColor,
              dataSource:  <ChartData>[
                ...List.generate(points.length,
                        (index) => ChartData(index+1,int.parse(points[index].round().toString()))).toList()
              ],
              xValueMapper: (ChartData chartData, _) => chartData.index,
              yValueMapper: (ChartData chartData, _) => chartData.value,
            ),
          ]
      ),
    );
  }
}

class OverviewItemRowLayout extends StatelessWidget {
  final Widget icon, name, attend, submit, point, dropdown, evaluate;
  const OverviewItemRowLayout(
      {required this.icon,
      required this.name,
      required this.attend,
      required this.submit,
      required this.point,
      required this.dropdown,
      required this.evaluate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: icon,
            )),
        Expanded(
            flex: 3,
            child: Container(
            )),
        Expanded(
            flex: 18,
            child: Container(alignment: Alignment.centerLeft, child: name)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.center, child: attend)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.center, child: submit)),
        Expanded(
            flex: 8,
            child: Container(alignment: Alignment.center, child: point)),
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: evaluate)),
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: dropdown)),
      ],
    );
  }
}
