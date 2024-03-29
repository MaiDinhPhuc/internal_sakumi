import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_checkbox_layout.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandRegisterSchedule extends StatelessWidget {
  const ExpandRegisterSchedule({super.key, required this.cubit});
  final ScheduleTabCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade300),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Column(
        children: [
          ScheduleCheckBoxLayout(
              day: Container(),
              a: Text("7h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              b: Text("8h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              c: Text("9h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              d: Text("10h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              e: Text("11h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              f: Text("12h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              g: Text("13h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              h: Text("14h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              i: Text("15h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              k: Text("16h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              l: Text("17h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              m: Text("18h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              n: Text("19h",
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600))),
          ...cubit.listDay.map((e) => ScheduleCheckBoxLayout(
              day: Text(e,
                  style: TextStyle(
                      color: greyColor.shade600,
                      fontSize: Resizable.font(context, 15),
                      fontWeight: FontWeight.w600)),
              a: Checkbox(
                  value: cubit.getValue(e, 7),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 7);
                    }
                  }),
              b: Checkbox(
                  value: cubit.getValue(e, 8),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 8);
                    }
                  }),
              c: Checkbox(
                  value: cubit.getValue(e, 9),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 9);
                    }
                  }),
              d: Checkbox(
                  value: cubit.getValue(e, 10),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 10);
                    }
                  }),
              e: Checkbox(
                  value: cubit.getValue(e, 11),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 11);
                    }
                  }),
              f: Checkbox(
                  value: cubit.getValue(e, 12),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 12);
                    }
                  }),
              g: Checkbox(
                  value: cubit.getValue(e, 13),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 13);
                    }
                  }),
              h: Checkbox(
                  value: cubit.getValue(e, 14),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 14);
                    }
                  }),
              i: Checkbox(
                  value: cubit.getValue(e, 15),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 15);
                    }
                  }),
              k: Checkbox(
                  value: cubit.getValue(e, 16),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 16);
                    }
                  }),
              l: Checkbox(
                  value: cubit.getValue(e, 17),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 17);
                    }
                  }),
              m: Checkbox(
                  value: cubit.getValue(e, 18),
                  onChanged: (bool? value) {
                    if (cubit.isEdit) {
                      cubit.updateSchedule(e, 18);
                    }
                  }),
              n: Checkbox(
                value: cubit.getValue(e, 19),
                onChanged: (bool? value) {
                  if (cubit.isEdit) {
                    cubit.updateSchedule(e, 19);
                  }
                },
              ))),
          if (cubit.isEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    cubit.changeEdit();
                  },
                  child: Container(
                    padding: EdgeInsets.all(Resizable.padding(context, 5)),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, Resizable.size(context, 1)),
                            color: Colors.grey,
                           )
                      ],
                      color: Colors.white,
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                    child: Center(
                        child: Text(AppText.textCancel.text,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 15)))),
                  ),
                ),
                Padding(padding: EdgeInsets.all(Resizable.padding(context, 5)),child: InkWell(
                  onTap: () {
                    cubit.changeEdit();
                    cubit.updateScheduleData();
                  },
                  child: Container(
                    padding: EdgeInsets.all(Resizable.padding(context, 5)),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, Resizable.size(context, 1)),
                          color: Colors.grey,
                        )
                      ],
                      color: primaryColor,
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                      borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5)),
                    ),
                    child: Center(
                        child: Text(AppText.txtUpdate.text,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 15)))),
                  ),
                ))
              ],
            )
        ],
      ),
    );
  }
}
