import 'package:flutter/material.dart';

import '../configs/color_configs.dart';
import '../utils/resizable.dart';

class CircleItem1 extends StatelessWidget {
  const CircleItem1({super.key, this.color, required this.child});
  final Color? color;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Resizable.size(context, 40),
    height: Resizable.size(context, 40),
    margin: EdgeInsets.symmetric(
    horizontal: Resizable.padding(context, 20),
    vertical: Resizable.padding(context, 8),
    ),
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: color ?? grey2
    ),
    child: child);
  }
}
