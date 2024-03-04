import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CardStudentClassItem extends StatelessWidget {
  final Widget widget, widgetStatus;
  final Function() onPressed;
  final Function() onTap;
  final bool canTap;
  final bool isExpand;
  const CardStudentClassItem(
      {required this.widget,
      required this.onPressed,
      required this.widgetStatus,
      required this.onTap,
      this.isExpand = false,
      this.canTap = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 9)),
            alignment: Alignment.centerLeft,
            child: widget),
        if (canTap)
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
                ))),
        Container(
            width: Resizable.size(context, 50),
            height: Resizable.size(context, 50),
            alignment: Alignment.centerLeft,
            child: widgetStatus),
      ],
    );
  }
}
