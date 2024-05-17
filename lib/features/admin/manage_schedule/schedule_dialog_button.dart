import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ScheduleDialogButton extends StatelessWidget {
  const ScheduleDialogButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.enable,
      required this.onTap});

  final String icon, title;
  final Function() onTap;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enable ? onTap : null,
      child: Container(
        padding: EdgeInsets.all( Resizable.padding(context, 5)),
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            color: enable ? Colors.white : grey2,
            border: Border.all(
              width: 1,
              color: grey2,
            ),
            borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right:Resizable.padding(context, 10)),
                child: Image.asset(
                  icon,
                  height: Resizable.size(context, 25),
                  width: Resizable.size(context, 25),
                )),
            Text(
              title,
              style: TextStyle(
                  fontSize: Resizable.font(context, 17),
                  fontWeight: FontWeight.w700,
                  color: enable?Colors.black:darkPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
