import 'dart:math';
import 'package:flutter/cupertino.dart';

class Resizable {
  static double font(BuildContext context, double size) {
    return fontScaleRatioForTablet(context) *
        width(context) *
        size /
        standard(context);
  }

  static double padding(BuildContext context, double size) {
    return paddingScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));
  }

  static double size(BuildContext context, double size) {
    return sizeScaleRatioForTablet(context) *
        size *
        ((width(context) + standard(context)) / (2 * standard(context)));
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double standard(BuildContext context) {
    return isTablet(context) == 3
        ? 2048
        : isTablet(context) == 2
            ? 1024
            : 512;
    return 512;
  }

  static double fontScaleRatioForTablet(BuildContext context) {
    return isTablet(context) == 3
        ? 2
        : isTablet(context) == 2
            ? 1.5
            : 1;
  }

  static double sizeScaleRatioForTablet(BuildContext context) {
    return isTablet(context) == 3
        ? 2
        : isTablet(context) == 2
            ? 1.5
            : 1;
  }

  static double paddingScaleRatioForTablet(BuildContext context) {
    return isTablet(context) == 3
        ? 2
        : isTablet(context) == 2
            ? 1.5
            : 1;
  }

  static int isTablet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1400
        ? 3
        : diagonal > 1100
            ? 2
            : 1;
    return isTablet;
  }
}
