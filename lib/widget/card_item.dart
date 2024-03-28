import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CardItem extends StatelessWidget {
  final Widget widget, widgetStatus;
  final Function() onPressed;
  final Function() onTap;
  final bool isExpand;
  const CardItem(
      {required this.widget,
      required this.onTap,
      required this.onPressed,
        required this.widgetStatus,
      this.isExpand = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Container(padding: EdgeInsets.symmetric(
            //horizontal: Resizable.padding(context, 20),
              vertical: Resizable.padding(context, 9)),
              alignment: Alignment.centerLeft,
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
                ))
          ),
          Container(
              width: Resizable.size(context, 50),
              height: Resizable.size(context, 50),
              alignment: Alignment.centerLeft,
              child: widgetStatus),
        ],
      ),
    );
  }
}

class CardTeacherItem extends StatelessWidget {
  final Widget widget, widgetStatus;
  final Function() onPressed;
  final Function() onTap;
  final bool isExpand;
  const CardTeacherItem(
      {required this.widget,
        required this.onTap,
        required this.onPressed,
        required this.widgetStatus,
        this.isExpand = false,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Container(padding: EdgeInsets.symmetric(
            //horizontal: Resizable.padding(context, 20),
              vertical: Resizable.padding(context, 9)),
              alignment: Alignment.centerLeft,
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
                  right: Resizable.padding(context, 30),
                  top: Resizable.padding(context, 10)),
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: onPressed,
                  splashRadius: Resizable.size(context, 15),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                  ))
          ),
          Container(
              width: Resizable.size(context, 50),
              height: Resizable.size(context, 50),
              alignment: Alignment.centerLeft,
              child: widgetStatus),
        ],
      ),
    );
  }
}