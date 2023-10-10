import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StatisticClassView extends StatelessWidget {
  final ClassOverviewCubit cubit;
  const StatisticClassView(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('okkkkkkkkkk'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Container(
          margin:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),
          height: Resizable.size(context, 85),
          padding: EdgeInsets.only(
              left: Resizable.padding(context, 10),
              top: Resizable.padding(context, 10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
              border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5),
              )),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppText.txtQuantity.text,
                    style: TextStyle(
                        color: const Color(0xff757575),
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20))),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: cubit.students == null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : Text("${cubit.countAvailable}/${cubit.students!.length.toString()}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 40)))),
                    Expanded(
                        child: cubit.listAttendance == null
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : OverviewChart(points: cubit.listAttendance!))
                  ],
                ),
              )
            ],
          ),
        )),
        SizedBox(width: Resizable.size(context, 20)),
        Expanded(
            child: Container(
          height: Resizable.size(context, 85),
          padding: EdgeInsets.only(
              top: Resizable.padding(context, 10),
              left: Resizable.padding(context, 10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
              border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5),
              )),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppText.titleHomework.text,
                    style: TextStyle(
                        color: const Color(0xff757575),
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20))),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: cubit.listHomework == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : Text('${cubit.percentHw!.toStringAsFixed(0)} %',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 40)))),
                  Expanded(
                      child: cubit.listHomework == null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : OverviewChart(
                              points: cubit.listHomework!, isPercent: true))
                ],
              )
            ],
          ),
        )),
        // if (cubit.averagePts != 0)
        //   SizedBox(width: Resizable.size(context, 20)),
        // if (cubit.averagePts != 0)
        //   Expanded(
        //       child: Container(
        //     height: Resizable.size(context, 85),
        //     padding: EdgeInsets.only(
        //         top: Resizable.padding(context, 10),
        //         left: Resizable.padding(context, 10)),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
        //         border: Border.all(
        //           color: const Color(0xffE0E0E0),
        //           width: Resizable.size(context, 0.5),
        //         )),
        //     child: Column(
        //       children: [
        //         Align(
        //           alignment: Alignment.topLeft,
        //           child: Text(AppText.txtPointOfTest.text,
        //               style: TextStyle(
        //                   color: const Color(0xff757575),
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: Resizable.font(context, 20))),
        //         ),
        //         Row(
        //           mainAxisSize: MainAxisSize.max,
        //           children: [
        //             Expanded(
        //                 child: cubit.listPoints == null
        //                     ? Align(
        //                         alignment: Alignment.centerLeft,
        //                         child: Transform.scale(
        //                           scale: 0.5,
        //                           child: const CircularProgressIndicator(),
        //                         ),
        //                       )
        //                     : Text(cubit.averagePts.toStringAsFixed(1),
        //                         style: TextStyle(
        //                             color: Colors.black,
        //                             fontWeight: FontWeight.w600,
        //                             fontSize: Resizable.font(context, 40)))),
        //             Expanded(
        //                 child: cubit.listPoints == null
        //                     ? Align(
        //                         alignment: Alignment.centerRight,
        //                         child: Transform.scale(
        //                           scale: 0.5,
        //                           child: const CircularProgressIndicator(),
        //                         ),
        //                       )
        //                     : OverviewChart(points: cubit.listPoints!))
        //           ],
        //         )
        //       ],
        //     ),
        //   )),
        SizedBox(width: Resizable.size(context, 20)),
        Expanded(
            child: Container(
          height: Resizable.size(context, 85),
          padding: EdgeInsets.all(Resizable.padding(context, 10)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
              border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5),
              )),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(AppText.txtEvaluate.text,
                    style: TextStyle(
                        color: const Color(0xff757575),
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20))),
              ),
              Expanded(
                  child: Center(
                      child: Text('A', //TODO ADD EVALUATE
                          style: TextStyle(
                              color: const Color(0xffFFD600),
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 40)))))
            ],
          ),
        )),
      ],
    );
  }
}
