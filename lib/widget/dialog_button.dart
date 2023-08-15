import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DialogButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const DialogButton(this.title, {required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shadowColor:
          MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(
                      Resizable.padding(context, 1000)))),
          backgroundColor:
          MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                  horizontal:
                  Resizable.padding(context, 30)))),
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: Resizable.font(context, 16),
              color: Colors.black)),
    );
  }
}
