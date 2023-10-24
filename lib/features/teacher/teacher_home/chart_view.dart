import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/list_class/chart_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ChartView extends StatelessWidget {

  List<double> stds;
  List<int>? attendances;
  List<int>? hws;
  ChartView({Key? key, required this.attendances, required this.hws, required this.stds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Resizable.size(context, 10)),
      height: Resizable.size(context, 190),
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