import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class AnalyticsTestChart extends StatelessWidget {
  const AnalyticsTestChart({super.key, required this.data});
  final List<RadarEntry> data;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              dataEntries: data,
              fillColor: primaryColor.withOpacity(0.8),
              borderColor: Colors.red,
              entryRadius: 3.0,
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.grey),
          titlePositionPercentageOffset: 0.02,
          titleTextStyle: TextStyle(fontSize: Resizable.font(context, 15), color: const Color(0xff565656), fontWeight: FontWeight.bold),
          getTitle: (index, _) {
            var number = '\n${data[index].value.toInt()}';
            switch (index) {
              case 0:
                return RadarChartTitle(text: "Từ vựng $number"); // Grammar
              case 1:
                return RadarChartTitle(text: "Ngữ pháp $number"); // Grammar // Speaking
              case 2:
                return RadarChartTitle(text: "Kanji $number"); // Grammar// Reading
              case 3:
                return RadarChartTitle(text: "Nghe $number"); // Grammar Listening
              case 4:
                return RadarChartTitle(text: 'Kaiwa $number'); // Grammar// Vocabulary
              case 5:
                return RadarChartTitle(text: "Nói $number");
              case 6:
                return RadarChartTitle(text: "Bảng chữ $number");
              case 7:
                return RadarChartTitle(text: 'JLPT $number'); // Gra// Gramma// Grammar/ Kanji
              default:
                return const RadarChartTitle(text: '');
            }
          },
          tickCount: 2,
          ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 0),
          tickBorderData: const BorderSide(color: Colors.grey, width: 1),
          gridBorderData: const BorderSide(color: Colors.grey, width: 1),

          radarShape: RadarShape.polygon,
        ),
      ),
    );
  }
}