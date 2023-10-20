import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  final int index;
  const ChartView(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return Container(
      margin: EdgeInsets.only(top: Resizable.size(context, 10)),
      height: Resizable.size(context, 190),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 4, child: Container()),
          Expanded(
              flex: 8, child: ColumnChart(listStd: cubit.colStd![index])),
          Expanded(child: Container()),
          Expanded(
              flex: 8,
              child: CustomLineChart(
                  attendances: cubit.rateAttendanceChart![index],
                  hws: cubit.rateSubmitChart![index],
                  points: [] //cubit.listPoint![index],
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
    return cubit.listLastLessonTitleNow[index] == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: Resizable.size(context, 10)),
                height: Resizable.size(context, 190),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 4, child: Container()),
                    Expanded(
                        flex: 8,
                        child: ColumnChart(listStd: cubit.colStd![index])),
                    Expanded(child: Container()),
                    Expanded(
                        flex: 8,
                        child: CustomLineChart(
                          attendances: cubit.rateAttendanceChart![index],
                          hws: cubit.rateSubmitChart![index],
                          points: [],
                        )),
                    Expanded(flex: 4, child: Container()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Resizable.size(context, 1),
                      margin: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 15)),
                      color: const Color(0xffD9D9D9),
                    ),
                    Row(
                      children: [
                        Text(AppText.txtLastLesson.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 19))),
                        SizedBox(width: Resizable.padding(context, 10)),
                        Text(cubit.listLastLessonTitleNow[index]!,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: Resizable.font(context, 19))),
                      ],
                    ),
                    Container(
                      height: Resizable.size(context, 1),
                      margin: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 15)),
                      color: const Color(0xffD9D9D9),
                    ),
                    Text(AppText.titleClassDes.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 19))),
                    NoteWidget(cubit.listClassDes![index]),
                    Text(AppText.titleClassNote.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 19))),
                    NoteWidget(cubit.listClassNote![index])
                  ],
                ),
              )
            ],
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
            height: Resizable.size(context, 160),
            child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  minimum: 1,
                  isVisible: false,
                ),
                series: <LineSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                    color: primaryColor,
                    dataSource: <ChartData>[
                      ...List.generate(
                              attendances!.length,
                              (index) =>
                                  ChartData(index + 1, attendances![index]))
                          .toList()
                    ],
                    xValueMapper: (ChartData chartData, _) => chartData.index,
                    yValueMapper: (ChartData chartData, _) => chartData.value,
                  ),
                  LineSeries<ChartData, int>(
                    color: secondaryColor,
                    dataSource: <ChartData>[
                      ...List.generate(hws!.length,
                          (index) => ChartData(index + 1, hws![index])).toList()
                    ],
                    xValueMapper: (ChartData chartData, _) => chartData.index,
                    yValueMapper: (ChartData chartData, _) => chartData.value,
                  ),
                  LineSeries<ChartData, int>(
                    color: Colors.yellow,
                    dataSource: <ChartData>[
                      ...List.generate(
                          points!.length,
                          (index) => ChartData(index + 1,
                              int.parse(points![index].toString()))).toList()
                    ],
                    xValueMapper: (ChartData chartData, _) => chartData.index,
                    yValueMapper: (ChartData chartData, _) => chartData.value,
                  )
                ])),
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
  const ColumnChart({Key? key, required this.listStd}) : super(key: key);

  final List<double> listStd;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppText.titleStdNumber.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 17))),
        SizedBox(height: Resizable.size(context, 5)),
        SizedBox(
          width: Resizable.size(context, 300),
          height: Resizable.size(context, 130),
          child: DChartBarCustom(
            spaceBetweenItem: Resizable.size(context, 5),
            spaceDomainLinetoChart: Resizable.size(context, 1),
            spaceMeasureLinetoChart: Resizable.size(context, 0),
            showDomainLine: true,
            listData: [
              DChartBarDataCustom(
                  color: const Color(0xff33691E),
                  value: listStd[0],
                  label: 'A',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xff757575),
                  value: listStd[1],
                  label: 'B',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffFFD600),
                  value: listStd[2],
                  label: 'C',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffE65100),
                  value: listStd[3],
                  label: 'D',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffB71C1C),
                  value: listStd[4],
                  label: 'E',
                  showValue: true),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 5)),
        Row(
          children: [
            Container(
              height: Resizable.size(context, 3),
              width: Resizable.size(context, 20),
              color: const Color(0xff33691E),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol1.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: const Color(0xff757575),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 20)),
                  child: Text(
                    AppText.txtCol2.text,
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
                  color: const Color(0xffFFD600),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 0)),
                  child: Text(
                    AppText.txtCol3.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: Resizable.size(context, 3),
              width: Resizable.size(context, 20),
              color: const Color(0xffE65100),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol4.text,
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
              color: const Color(0xffB71C1C),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol5.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        )
      ],
    );
  }
}
