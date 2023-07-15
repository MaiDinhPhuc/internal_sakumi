import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/chart_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
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
              : Container(
                  margin: EdgeInsets.only(top: Resizable.size(context, 10)),
                  height: Resizable.size(context, 110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Resizable.size(context, 10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppText.txtQuantity.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 17),
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Resizable.padding(context, 15)),
                              child: cubit.listStudentClass == null
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      cubit.listStudentClass!.length.toString(),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: Resizable.font(context, 70),
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                            Text(
                              AppText.txtStudent.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 14),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const LineChart(),
                      const AveragePointView(),
                      const ColumnChart()
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class AveragePointView extends StatelessWidget {
  const AveragePointView({Key? key}) : super(key: key);

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
            title: '7.5',
            lineWidth: Resizable.size(context, 6),
            percent: 3 / 4,
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

class LineChart extends StatelessWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: Resizable.size(context, 180),
          child: DChartLine(
            data: const [
              //TODO ADD ALGORITHM
              {
                'id': 'Attendances',
                'data': [
                  {'domain': 0, 'measure': 5},
                  {'domain': 1, 'measure': 4},
                  {'domain': 2, 'measure': 6},
                  {'domain': 3, 'measure': 4},
                  {'domain': 4, 'measure': 4},
                  {'domain': 5, 'measure': 2},
                  {'domain': 6, 'measure': 5},
                  {'domain': 7, 'measure': 4},
                  {'domain': 8, 'measure': 6},
                  {'domain': 9, 'measure': 4},
                  {'domain': 10, 'measure': 4},
                  {'domain': 11, 'measure': 10},
                  {'domain': 12, 'measure': 5},
                  {'domain': 13, 'measure': 4},
                  {'domain': 14, 'measure': 6},
                  {'domain': 15, 'measure': 4},
                  {'domain': 16, 'measure': 4},
                  {'domain': 17, 'measure': 2},
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
                  {'domain': 6, 'measure': 1},
                  {'domain': 7, 'measure': 4},
                  {'domain': 8, 'measure': 2},
                  {'domain': 9, 'measure': 10},
                  {'domain': 10, 'measure': 1},
                  {'domain': 11, 'measure': 2},
                  {'domain': 12, 'measure': 4},
                  {'domain': 13, 'measure': 2},
                  {'domain': 14, 'measure': 6},
                  {'domain': 15, 'measure': 6},
                  {'domain': 16, 'measure': 2},
                  {'domain': 17, 'measure': 5},
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
        ),
        Container(
          margin: EdgeInsets.only(top: Resizable.padding(context, 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: Resizable.size(context, 5),
                    width: Resizable.size(context, 20),
                    color: secondaryColor,
                    margin:
                        EdgeInsets.only(right: Resizable.padding(context, 3)),
                  ),
                  Text(
                    AppText.txtDoHomeworks.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: Resizable.size(context, 5),
                    width: Resizable.size(context, 20),
                    color: primaryColor,
                    margin:
                        EdgeInsets.only(right: Resizable.padding(context, 3)),
                  ),
                  Text(
                    AppText.txtPresent.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
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
        Container(
          width: Resizable.size(context, 85),
          height: Resizable.size(context, 70),
          margin: EdgeInsets.only(bottom: Resizable.size(context, 10)),
          child: DChartBarCustom(
            //domainLabelAlignVertical: CrossAxisAlignment.center,
            spaceBetweenItem: Resizable.size(context, 3),
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
      ],
    );
  }
}
