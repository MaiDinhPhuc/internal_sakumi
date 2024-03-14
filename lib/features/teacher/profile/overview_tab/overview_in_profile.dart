import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/circle_progress.dart';

import 'overview_tab_cubit.dart';

class OverViewTabInProfile extends StatelessWidget {
  OverViewTabInProfile({super.key, required this.role})
      : cubit = OverViewTabCubit(role);

  final OverViewTabCubit cubit;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverViewTabCubit, int>(
        bloc: cubit,
        builder: (c, s) {
          return Column(
            children: [
              Container(
                  height: Resizable.size(context, 150),
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10)),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 10),
                      vertical: Resizable.padding(context, 10)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: greyColor.shade600),
                      borderRadius: BorderRadius.all(
                          Radius.circular(Resizable.size(context, 5))),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppText.titleOverView.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: Resizable.font(context, 26))),
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: Resizable.size(context, 80),
                                child: CircleProgress(
                                  title: cubit.levelUpPercent == null
                                      ? '0%'
                                      : '${cubit.levelUpPercent!.toStringAsFixed(0)} %',
                                  lineWidth: Resizable.size(context, 5),
                                  percent: cubit.levelUpPercent == null
                                      ? 0
                                      : cubit.levelUpPercent! / 100,
                                  radius: Resizable.size(context, 30),
                                  fontSize: Resizable.font(context, 20),
                                ),
                              ),
                              Text(AppText.txtUpPercent.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: Resizable.font(context, 24)))
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: Resizable.size(context, 80),
                                  child: CircleProgress(
                                    title: cubit.attendancePercent == null
                                        ? '0%'
                                        : '${(cubit.attendancePercent! * 100).toStringAsFixed(0)} %',
                                    lineWidth: Resizable.size(context, 5),
                                    percent: cubit.attendancePercent == null
                                        ? 0
                                        : cubit.attendancePercent!,
                                    radius: Resizable.size(context, 30),
                                    fontSize: Resizable.font(context, 20),
                                  )),
                              Text(AppText.txtRateOfAttendance.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: Resizable.font(context, 24)))
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: Resizable.size(context, 80),
                                  child: CircleProgress(
                                    title: cubit.hwPercent == null
                                        ? '0%'
                                        : '${(cubit.hwPercent! * 100).toStringAsFixed(0)} %',
                                    lineWidth: Resizable.size(context, 5),
                                    percent: cubit.hwPercent == null
                                        ? 0
                                        : cubit.hwPercent!,
                                    radius: Resizable.size(context, 30),
                                    fontSize: Resizable.font(context, 20),
                                  )),
                              Text(AppText.txtRateOfSubmitHomework.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: Resizable.font(context, 24)))
                            ],
                          )
                        ],
                      )
                    ],
                  ))
            ],
          );
        });
  }
}
