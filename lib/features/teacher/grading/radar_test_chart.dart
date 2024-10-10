import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_grading_cubit.dart';

class AnalyticsTestChart extends StatelessWidget {
  const AnalyticsTestChart({super.key, required this.data});
  final List<RadarEntryCustom> data;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              dataEntries: data.map((e) => e.entry).toList(),
              fillColor: primaryColor.withOpacity(0.8),
              borderColor: Colors.red,
              entryRadius: 3.0,
            ),
            RadarDataSet(
              dataEntries: data.map((e) => const RadarEntry(value: 10),).toList(),
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
            RadarDataSet(
              dataEntries: [
                ...data.map((e) => const RadarEntry(value: 0),).toList(),

              ],
              fillColor: Colors.transparent,
              borderColor: Colors.transparent,

            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.grey),

          titlePositionPercentageOffset: 0.05,
          titleTextStyle: TextStyle(fontSize: Resizable.font(context, 15), color: subTitleColor, fontWeight: FontWeight.bold),
          getTitle: (index, _) {
            var temp = data[index].entry.value;
            var number = '';
            if(temp == temp.toInt()) {
              number = '\n${temp.toInt()}';
            }
            else {
              number = '\n${temp.toStringAsFixed(1)}';
            }
            return RadarChartTitle(text: data[index].title + number);
          },
          tickCount: 2,

          ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 0),
          tickBorderData: BorderSide(color: Colors.grey, width: 1),
          gridBorderData: BorderSide(color: Colors.grey, width: 1),

          radarShape: RadarShape.polygon,
        ),
      ),
    );
  }
}
