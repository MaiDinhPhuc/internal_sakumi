import 'package:flutter/material.dart';

import '../../../configs/color_configs.dart';
import '../../../utils/resizable.dart';

class CustomButtonV1 extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color? border;
  final Color textColor;
  final Color backgroundColor;
  final double paddingHorizontal;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? prefixIcon;
  const CustomButtonV1(
      {required this.onPressed,
      required this.title,
      Key? key,
      this.border,
      required this.textColor,
        this.paddingHorizontal = 20,
        this.fontSize = 16,
        this.fontWeight = FontWeight.w700,
      required this.backgroundColor, this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      
      style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(
              border != null ? Colors.black26 : backgroundColor),
          side: border != null ? MaterialStateProperty.all(
             BorderSide(
               color: border!,
               width: 1,
             )
          ): null,
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 1000)))),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, paddingHorizontal)))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(prefixIcon != null)
            ...[
              prefixIcon!,
              SizedBox(width: Resizable.padding(context, 2),)
            ],
          Text(title,
              style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: Resizable.font(context, fontSize),
                  color: textColor)),
        ],
      ),
    );
  }
}
