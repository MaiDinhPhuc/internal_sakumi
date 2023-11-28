import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/list_class/chart_view_admin.dart';
import 'package:internal_sakumi/features/teacher/list_class/column_chart.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ChartView extends StatelessWidget {

  final List<double> stds;
  final List<int>? attendances;
  final List<int>? hws;
  const ChartView({Key? key, required this.attendances, required this.hws, required this.stds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Resizable.size(context, 10)),
      constraints: BoxConstraints(
        maxHeight: Resizable.size(context, 200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 4, child: Container()),
          Expanded(
              flex: 8, child: ColumnChart(listStd: stds)),
          Expanded(child: Container()),
          Expanded(
              flex: 8,
              child: CustomLineChart(
                  attendances: attendances,
                  hws: hws,
                  points: [] //cubit.listPoint![index],
              )),
          Expanded(flex: 4, child: Container()),
        ],
      ),
    );
  }
}