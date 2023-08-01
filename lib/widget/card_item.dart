import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CardItem extends StatelessWidget {
  final Widget widget;
  final Function() onPressed;
  final Function() onTap;
  final bool isExpand;
  const CardItem(
      {required this.widget,
      required this.onTap,
      required this.onPressed,
      this.isExpand = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      //alignment: Alignment.center,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                //horizontal: Resizable.padding(context, 20),
                vertical: Resizable.padding(context, 8)),
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: isExpand ? Colors.black : greyColor.shade100),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: widget),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Resizable.size(context, 5)),
          ),
        )),
        Container(
          margin: EdgeInsets.only(
              right: Resizable.padding(context, 70),
              top: Resizable.padding(context, 10)),
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: onPressed,
              splashRadius: Resizable.size(context, 15),
              icon: const Icon(
                Icons.keyboard_arrow_down,
              )),
        )
      ],
    );
  }
}
