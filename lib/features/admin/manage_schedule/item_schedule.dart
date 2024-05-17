import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ItemSchedule extends StatelessWidget {
  const ItemSchedule(
      {super.key,
      required this.type,
      required this.sensei,
      required this.info,
      required this.onTap,
      required this.isChoose});
  final String type, sensei, info;
  final Function() onTap;
  final bool isChoose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            bottom: Resizable.padding(context, 5)),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: isChoose ? primaryColor : darkPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                child: Image.asset(
                  'assets/images/${type == "single" ? "single_schedule" : "cyclic_schedule"}.png',
                  height: Resizable.size(context, 25),
                  width: Resizable.size(context, 25),
                )),
            Column(
              children: [
                Text(
                  sensei,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  info,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 17),
                      fontWeight: FontWeight.w600,
                      color: darkPrimaryColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
