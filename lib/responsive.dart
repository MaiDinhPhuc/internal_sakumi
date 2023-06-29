import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget phone;
  final Widget tablet;
  final Widget computer;

  const Responsive({
    super.key,
    required this.phone,
    required this.tablet,
    required this.computer,
  });

  static const int phoneLimit = 600;
  static const int tabletLimit = 1100;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < phoneLimit) {
          return phone;
        }
        if (constraints.maxWidth < tabletLimit &&
            constraints.maxHeight >= phoneLimit) {
          return tablet;
        } else {
          return computer;
        }
      },
    );
  }
}
