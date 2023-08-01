import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/teacher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:screenshot/screenshot.dart';

class ChartView extends StatelessWidget {
  final int index;
  const ChartView(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return Container(
      margin: EdgeInsets.only(top: Resizable.size(context, 10)),
      height: Resizable.size(context, 130),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: Resizable.size(context, 10)),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         AppText.txtQuantity.text,
          //         style: TextStyle(
          //             fontSize: Resizable.font(context, 17),
          //             fontWeight: FontWeight.w700),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: Resizable.padding(context, 15)),
          //         child: Text(
          //           '${cubit.listStudentInClass![index]}',
          //           style: TextStyle(
          //               color: primaryColor,
          //               fontSize: Resizable.font(context, 70),
          //               fontWeight: FontWeight.w600),
          //         ),
          //       ),
          //       Text(
          //         AppText.txtStudent.text,
          //         style: TextStyle(
          //             fontSize: Resizable.font(context, 14),
          //             fontWeight: FontWeight.w600),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(flex: 4, child: Container()),
          const Expanded(flex: 2, child: ColumnChart()),
          Expanded(child: Container()),
          Expanded(
              flex: 8,
              child: LineChart(
                attendances: cubit.listAttendance![index],
                hws: cubit.listSubmit![index],
                points: cubit.listPoint,
              )),
          Expanded(flex: 4, child: Container()),
          //AveragePointView(point: cubit.listPoint![index]),
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

class LineChart extends StatelessWidget {
  final List<int>? attendances, hws;
  final List<double>? points;
  const LineChart(
      {required this.attendances,
      required this.hws,
      required this.points,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //width: Resizable.size(context, 360),
          margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
          height: Resizable.size(context, 110),
          child: DChartLine(
            data: [
              {
                'id': 'Attendances',
                'data': [
                  const {'domain': 0, 'measure': 0},
                  ...List.generate(
                      attendances!.length,
                      (index) => {
                            'domain': index + 1,
                            'measure': attendances![index]
                          }).toList()
                ],
              },
              {
                'id': 'Homeworks',
                'data': [
                  const {'domain': 0, 'measure': 0},
                  ...List.generate(
                      hws!.length,
                      (index) => {
                            'domain': index + 1,
                            'measure': hws![index]
                          }).toList()
                ],
              },
              {
                'id': 'Points',
                'data': [
                  const {'domain': 0, 'measure': 0},
                  ...List.generate(
                      points!.length,
                      (index) => {
                            'domain': index + 1,
                            'measure': points![index]
                          }).toList()
                ],
              },
            ],
            //includePoints: true,
            lineColor: (lineData, index, id) {
              if (id == 'Attendances') {
                return primaryColor;
              } else if (id == 'Homeworks') {
                return secondaryColor;
              }
              return Colors.yellow;
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 5),
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
                  height: Resizable.size(context, 5),
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
                  height: Resizable.size(context, 5),
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
