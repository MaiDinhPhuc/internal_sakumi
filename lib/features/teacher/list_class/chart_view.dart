import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  final int index;
  const ChartView(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return
        cubit.listPoint!.isEmpty ||
        cubit.listSubmit!.isEmpty ||
        cubit.listAttendance!.isEmpty
        ? Center(
          child: Transform.scale(
            scale: 0.75,
            child: const CircularProgressIndicator(),
          ),
        ) : Container(
      margin: EdgeInsets.only(top: Resizable.size(context, 10)),
      height: Resizable.size(context, 130),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 4, child: Container()),
          const Expanded(flex: 2, child: ColumnChart()),
          Expanded(child: Container()),
          Expanded(
              flex: 8,
              child: CustomLineChart(
                attendances: cubit.listAttendance![index],
                hws: cubit.listSubmit![index],
                points: cubit.listPoint![index],
              )),
          Expanded(flex: 4, child: Container()),
        ],
      ),
    );
  }
}

class CharInAdminView extends StatelessWidget {
  final int index;
  const CharInAdminView(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoadListClassCubit>(context);
    return
      cubit.listPoint!.isEmpty ||
          cubit.listSubmit!.isEmpty ||
          cubit.listAttendance!.isEmpty
          ? Center(
        child: Transform.scale(
          scale: 0.75,
          child: const CircularProgressIndicator(),
        ),
      ) : Container(
        margin: EdgeInsets.only(top: Resizable.size(context, 10)),
        height: Resizable.size(context, 130),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 4, child: Container()),
            const Expanded(flex: 2, child: ColumnChart()),
            Expanded(child: Container()),
            Expanded(
                flex: 8,
                child: CustomLineChart(
                  attendances: cubit.listAttendance![index],
                  hws: cubit.listSubmit![index],
                  points: cubit.listPoint![index],
                )),
            Expanded(flex: 4, child: Container()),
          ],
        ),
      );
  }
}

class AveragePointView extends StatelessWidget {
  final double point;
  const AveragePointView({required this.point, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Resizable.size(context, 10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppText.txtTest.text,
            style: TextStyle(
                fontSize: Resizable.font(context, 17),
                fontWeight: FontWeight.w700),
          ),
          CircleProgress(
            title: point.toString(),
            lineWidth: Resizable.size(context, 6),
            percent: point / 10,
            radius: Resizable.size(context, 24),
            fontSize: Resizable.font(context, 24),
          ),
          Text(
            AppText.txtAveragePoint.text,
            style: TextStyle(
                fontSize: Resizable.font(context, 14),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.index, this.value);
  final int index;
  final int value;
}

class CustomLineChart extends StatelessWidget {
  final List<int>? attendances, hws;
  final List<double>? points;
  const CustomLineChart(
      {required this.attendances,
      required this.hws,
      required this.points,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Resizable.size(context, 110),
          child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  minimum: 1,
                  isVisible: false,
                ),
                series: <LineSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                      color: primaryColor,
                      dataSource:  <ChartData>[
                        ...List.generate(attendances!.length,
                                (index) => ChartData(index+1,attendances![index])).toList()
                      ],
                      xValueMapper: (ChartData chartData, _) => chartData.index,
                      yValueMapper: (ChartData chartData, _) => chartData.value,
                  ),
                  LineSeries<ChartData, int>(
                    color: secondaryColor,
                    dataSource:  <ChartData>[
                      ...List.generate(hws!.length,
                              (index) => ChartData(index+1,hws![index])).toList()
                    ],
                    xValueMapper: (ChartData chartData, _) => chartData.index,
                    yValueMapper: (ChartData chartData, _) => chartData.value,
                  ),
                  LineSeries<ChartData, int>(
                    color: Colors.yellow,
                    dataSource:  <ChartData>[
                      ...List.generate(points!.length,
                              (index) => ChartData(index+1,int.parse(points![index].toString()))).toList()
                    ],
                    xValueMapper: (ChartData chartData, _) => chartData.index,
                    yValueMapper: (ChartData chartData, _) => chartData.value,
                  )
                ]
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: primaryColor,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 20)),
                  child: Text(
                    AppText.txtPresent.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: secondaryColor,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 20)),
                  child: Text(
                    AppText.txtDoHomeworks.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: Colors.yellow,
                  margin: EdgeInsets.only(right: Resizable.padding(context, 3)),
                ),
                Text(
                  AppText.txtPointOfTest.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class ColumnChart extends StatelessWidget {
  const ColumnChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Resizable.size(context, 10)),
        Expanded(
            child: Text(AppText.titleStatistics.text,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Resizable.font(context, 17)))),
        SizedBox(
          //width: Resizable.size(context, 130),
          height: Resizable.size(context, 56),
          child: DChartBarCustom(
            //domainLabelAlignVertical: CrossAxisAlignment.center,
            spaceBetweenItem: Resizable.size(context, 5),
            spaceDomainLinetoChart: Resizable.size(context, 1),
            spaceMeasureLinetoChart: Resizable.size(context, 0),
            showDomainLine: true,
            //showDomainLabel: true,
            listData: [
              //TODO ADD ALGORITHM
              DChartBarDataCustom(color: primaryColor, value: 13, label: '00'),
              DChartBarDataCustom(color: primaryColor, value: 20, label: '09'),
              DChartBarDataCustom(color: primaryColor, value: 30, label: '08'),
              DChartBarDataCustom(color: primaryColor, value: 40, label: '08'),
              DChartBarDataCustom(color: primaryColor, value: 25, label: '08'),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 35)),
      ],
    );
  }
}
