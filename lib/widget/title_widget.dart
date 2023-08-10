import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: Text(
          title, style: TextStyle(
          color: const Color(0xff757575), fontSize: Resizable.font(context, 20), fontWeight: FontWeight.w700
      )),
    );
  }
}
