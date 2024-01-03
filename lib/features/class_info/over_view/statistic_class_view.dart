import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/overview/overview_chart.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'class_overview_cubit_v2.dart';

class StatisticClassViewV2 extends StatelessWidget {
  const StatisticClassViewV2({Key? key, required this.cubit}) : super(key: key);
  final ClassOverViewCubitV2 cubit;
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
                            child: cubit.listStdClass == null
                                ? Align(
                              alignment: Alignment.centerRight,
                              child: Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(),
                              ),
                            )
                                : Text(
                                "${cubit.countAvailable}/${cubit.listStdClass!.length.toString()}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 40)))),
                        Expanded(
                            child:
                            OverviewChart(points: cubit.listAttendance))
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
                          child: cubit.listStdClass == null
                              ? Align(
                            alignment: Alignment.centerRight,
                            child: Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                              : Text('${(cubit.percentHw*100).toStringAsFixed(0)} %',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 40)))),
                      Expanded(
                          child: OverviewChart(
                              points: cubit.listHomework, isPercent: true))
                    ],
                  )
                ],
              ),
            )),
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
              child: cubit.listStdClass == null || cubit.classModel!.classStatus != "Completed" ? Column(
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
                          child: Text('A',
                              style: TextStyle(
                                  color: const Color(0xffFFD600),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 40)))))
                ],
              ) : Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(AppText.txtUpPercent.text,
                        style: TextStyle(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 20))),
                  ),
                  Expanded(
                      child: Center(
                          child: Text("${cubit.getPercentUpSale()}%",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 40)))))
                ],
              ),
            )),
      ],
    );
  }
}
