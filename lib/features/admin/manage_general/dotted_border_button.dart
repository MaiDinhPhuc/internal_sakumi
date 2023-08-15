import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DottedBorderButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isManageGeneral;
  const DottedBorderButton(this.title, {required this.onPressed, this.isManageGeneral = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
      child: DottedBorder(
        dashPattern: [Resizable.size(context, 5), Resizable.size(context, 3)],
          borderType: BorderType.RRect,
          radius:
          Radius.circular(Resizable.size(context, 5)),
          padding: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, isManageGeneral ? 10 : 15)),
          color: isManageGeneral ? const Color(0xff757575): const Color(0xffE0E0E0),
          strokeWidth: Resizable.size(context, 0.75),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: const Color(0xff757575), size: Resizable.size(context, 10)),
              Text(title, style: TextStyle(
                  fontSize: Resizable.font(context, isManageGeneral ? 15 : 20), fontWeight: FontWeight.w700, color: const Color(0xff757575)
              ))],
          )),
    );
  }
}
