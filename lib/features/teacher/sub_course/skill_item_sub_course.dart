import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SkillItemSubCourse extends StatelessWidget {
  const SkillItemSubCourse({super.key, required this.isExist, required this.time, required this.isCustom});
  final bool isExist, isCustom;
  final String time;

  @override
  Widget build(BuildContext context) {
    return isCustom ? Container(
        constraints: BoxConstraints(minWidth: Resizable.size(context, 50)),
        padding:
        EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: time != "00:00:00"
                ? const Color(0xff33691E)
                :  greyColor.shade600),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Resizable.font(context, 15),
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        )) : Container(
      constraints: BoxConstraints(minWidth: Resizable.size(context, 50)),
      padding:
      EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: isExist == false
              ? greyColor.shade600
              : time != "00:00:00"
              ? const Color(0xff33691E)
              : const Color(0xffB71C1C)),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Resizable.font(context, 15),
            fontWeight: FontWeight.w800,
            color: Colors.white,
      ),
    ));
  }
}
