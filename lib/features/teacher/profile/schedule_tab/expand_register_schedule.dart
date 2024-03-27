import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_checkbox_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ExpandRegisterSchedule extends StatelessWidget {
  const ExpandRegisterSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade600),
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
                      fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }
}
