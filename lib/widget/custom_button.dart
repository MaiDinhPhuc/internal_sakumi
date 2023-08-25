import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPress, required this.bgColor, required this.foreColor, required this.text}) : super(key: key);
  final Function() onPress;
  final Color bgColor;
  final Color foreColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 20)),
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 500),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          padding: MaterialStateProperty.all( EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 20) ,
              vertical: Resizable.padding(context, 10))),
          elevation: MaterialStateProperty.all(10),
          foregroundColor: MaterialStateProperty.all(foreColor),
          backgroundColor: MaterialStateProperty.all(bgColor),
          overlayColor: MaterialStateProperty.all(
             Colors.black.withOpacity(0.3)
        ),
        ),
        child:  Text(text),
      ),
    );
  }
}
