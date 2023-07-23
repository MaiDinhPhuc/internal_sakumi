import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SubmitButton extends StatelessWidget {
  final Function() onPressed;
  final bool isActive;
  final String title;
  const SubmitButton(
      {required this.onPressed,
      required this.title,
      this.isActive = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(
              isActive ? primaryColor : greyColor.shade400),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 1000)))),
          backgroundColor: MaterialStateProperty.all(
              isActive ? primaryColor : greyColor.shade400),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 30)))),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16),
              color: Colors.white)),
    );
  }
}
