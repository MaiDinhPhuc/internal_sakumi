import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/search_in_schedule_view.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_item.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_taught_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../search/item_search_list.dart';
import 'change_date_view.dart';
import 'manage_schedule_cubit.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key, required this.cubit});

  final ManageScheduleCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageScheduleCubit,int>(
        bloc: cubit,
        builder: (c,s){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchInScheduleView(cubit: cubit),
                SizedBox(height: Resizable.size(context, 10)),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.txtSchedule.text.toUpperCase(),
                            style: TextStyle(
                                color: greyColor.shade600,
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20))),
                        ChangeDateView(cubit: cubit),
                        cubit.isLoadingSchedule
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                          children: [
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                  height: Resizable.size(context, 600),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: Resizable.size(context, 1),
                                          color: greyColor.shade300),
                                      borderRadius:
                                      BorderRadius.circular(Resizable.size(context, 5))),
                                  child: Column(
                                    children: [
                                      ...cubit.listDay.map((e) => Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    e,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: Resizable.font(context, 15),
                                                        color: greyColor.shade600),
                                                  ),
                                                  Text(
                                                    cubit.getDate(cubit.listDay.indexOf(e)),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: Resizable.font(context, 15),
                                                        color: greyColor.shade600),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: Resizable.padding(context, 10)),
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    ...cubit
                                                        .getResult(cubit.listDay.indexOf(e))
                                                        .map((ee) => Padding(
                                                        padding: EdgeInsets.all(
                                                            Resizable.padding(
                                                                context, 3)),
                                                        child: ScheduleTaughtItemV2(
                                                            cubit: cubit,
                                                            lessonResultModel: ee))),
                                                    ...cubit
                                                        .getScheduleItem(
                                                        cubit.listDay.indexOf(e), e)
                                                        .map((e) => Padding(padding: EdgeInsets.all(
                                                        Resizable.padding(
                                                            context, 3)),child: ScheduleItemV2(
                                                        cubit: cubit, scheduleModel: e)))
                                                  ],
                                                ),
                                              )
                                            ],
                                          )))
                                    ],
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        cubit.classId == null ?
                        Expanded(
                            flex: 3,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("class")
                                    .snapshots(),
                                builder: (c, snapshots) {
                                  return (snapshots.connectionState ==
                                      ConnectionState.waiting)
                                      ? Container()
                                      : ClassSearchListSchedule(
                                      snapshots: snapshots, scheduleCubit: cubit);
                                })): Expanded(
                            flex:3,
                            child: Container()),
                        SizedBox(width: Resizable.padding(context, 10)),
                        cubit.teacherId == null ?
                        Expanded(
                            flex: 5,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("teacher")
                                    .snapshots(),
                                builder: (c, snapshots) {
                                  return (snapshots.connectionState ==
                                      ConnectionState.waiting)
                                      ? Container()
                                      : TeacherSearchListSchedule(
                                      snapshots: snapshots, scheduleCubit: cubit);
                                })): Expanded(
                            flex:5,
                            child: Container()),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: Resizable.padding(context, 10)),
                                child: Container()))
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
