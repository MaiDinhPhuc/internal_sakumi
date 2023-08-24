import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPress, required this.bgColor, required this.foreColor, required this.text}) : super(key: key);
  final Function() onPress;
  final Color bgColor;
  final Color foreColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 500),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        elevation: MaterialStateProperty.all(10),
        foregroundColor: MaterialStateProperty.all(foreColor),
        backgroundColor: MaterialStateProperty.all(bgColor),
        overlayColor: MaterialStateProperty.all(
            greyColor.shade300,
      ),
      ),
      child:  Text(text),
    );
  }
}
