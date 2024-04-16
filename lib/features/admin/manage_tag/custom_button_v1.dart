import 'package:flutter/material.dart';

import '../../../configs/color_configs.dart';
import '../../../utils/resizable.dart';

class CustomButtonV1 extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color? border;
  final Color textColor;
  final Color backgroundColor;

  const CustomButtonV1(
      {required this.onPressed,
      required this.title,
      Key? key,
      this.border,
      required this.textColor,
      required this.backgroundColor})
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
              horizontal: Resizable.padding(context, 20)))),
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16),
              color: textColor)),
    );
  }
}
