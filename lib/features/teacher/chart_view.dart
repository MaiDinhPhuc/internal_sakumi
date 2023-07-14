import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/chart_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChartView extends StatelessWidget {
  final int classId;
  const ChartView(this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartCubit(classId)..init(context),
      child: BlocBuilder<ChartCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<ChartCubit>(c);
          return s <= 0
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          AppText.txtQuantity.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 17),
                              fontWeight: FontWeight.w700),
                        ),
                        cubit.listStudentClass == null
                            ? const CircularProgressIndicator()
                            : Text(
                                cubit.listStudentClass!.length.toString(),
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: Resizable.font(context, 70),
                                    fontWeight: FontWeight.w600),
                              ),
                        Text(
                          AppText.txtStudent.text,
                          style: TextStyle(
                              fontSize: Resizable.font(context, 14),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const LineChart(),
                    const CircleProgress(),
                    const ColumnChart()
                  ],
                );
        },
      ),
    );
  }
}

class CircleProgress extends StatelessWidget {
  const CircleProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
        radius: Resizable.size(context, 24),
        lineWidth: Resizable.size(context, 6),
        animation: true,
        animationDuration: 3000,
        percent: 3 / 4,
        center: Card(
          elevation: 15,
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Center(
              child: Text(
            '7.5',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 24)),
          )),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        rotateLinearGradient: true,
        linearGradient: LinearGradient(colors: [
          primaryColor.withOpacity(0.63),
          primaryColor.withOpacity(0.63),
          primaryColor.withOpacity(0.63),
          primaryColor,
          primaryColor,
          primaryColor,
        ]),
        backgroundColor: Colors.transparent);
  }
}

class LineChart extends StatelessWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300 * 9 / 16,
      child: DChartLine(
        data: const [
          {
            'id': 'Attendances',
            'data': [
              {'domain': 0, 'measure': 5},
              {'domain': 1, 'measure': 4},
              {'domain': 2, 'measure': 6},
              {'domain': 3, 'measure': 4},
              {'domain': 4, 'measure': 4},
              {'domain': 5, 'measure': 2},
            ],
          },
          {
            'id': 'Homeworks',
            'data': [
              {'domain': 0, 'measure': 2},
              {'domain': 1, 'measure': 5},
              {'domain': 2, 'measure': 4},
              {'domain': 3, 'measure': 1},
              {'domain': 4, 'measure': 3},
              {'domain': 5, 'measure': 2},
            ],
          },
        ],
        includePoints: true,
        lineColor: (lineData, index, id) {
          if (id == 'Homeworks') {
            return primaryColor;
          } else {
            return secondaryColor;
          }
        },
      ),
    );
  }
}

class ColumnChart extends StatelessWidget {
  const ColumnChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 300 * 9 / 16,
      child: DChartBar(
        data: [
          {
            'id': 'Bar',
            'data': [
              {'domain': '   ', 'measure': 3},
              {'domain': '   ', 'measure': 4},
              {'domain': '   ', 'measure': 6},
              {'domain': '   ', 'measure': 5},
            ],
          },
        ],
        //domainLabelPaddingToAxisLine: 16,

        minimumPaddingBetweenLabel: 100,
        measureAxisTitleOutPadding: 20,
        measureLabelPaddingToTick: 30,
        axisLineTick: 1,
        domainLabelPaddingToAxisLine: 10,
        measureAxisTitleColor: Colors.transparent,
        showMeasureLine: false,
        axisLinePointTick: 1,
        axisLinePointWidth: 10,
        axisLineColor: Colors.black,
        measureLabelPaddingToAxisLine: 10,
        barColor: (barData, index, id) => primaryColor,
        showBarValue: true,
      ),
    );
  }
}
