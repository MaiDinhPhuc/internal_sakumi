import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_item.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_taught_item.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';

class ScheduleWithDateView extends StatelessWidget {
  const ScheduleWithDateView({super.key, required this.cubit});
  final ScheduleTabCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppText.txtSchedule.text.toUpperCase(),
            style: TextStyle(
                color: greyColor.shade600,
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 20))),
        Container(
          margin:
              EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
          width: Resizable.size(context, 250),
          decoration: BoxDecoration(
              border: Border.all(
                  width: Resizable.size(context, 1), color: greyColor.shade300),
              borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () {
                cubit.previous();
              },
              child: Padding(
                  padding: EdgeInsets.all(Resizable.padding(context, 5)),
                  child: Icon(Icons.arrow_back_ios_new_sharp,
                      color: greyColor.shade600)),
            ),
            InkWell(
                child: Text(cubit.getRangeDate(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w700,
                        color: greyColor.shade600))),
            InkWell(
              onTap: () {
                cubit.next();
              },
              child: Padding(
                  padding: EdgeInsets.all(Resizable.padding(context, 5)),
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      color: greyColor.shade600)),
            )
          ]),
        ),
        cubit.isLoadingSchedule
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(Resizable.padding(context, 10)),
                    height: Resizable.size(context, 500),
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
                                              child: ScheduleTaughtItem(
                                                  cubit: cubit,
                                                  lessonResultModel: ee))),
                                      ...cubit
                                          .getScheduleItem(
                                              cubit.listDay.indexOf(e), e)
                                          .map((e) => ScheduleItem(
                                              cubit: cubit, scheduleModel: e))
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
    );
  }
}
