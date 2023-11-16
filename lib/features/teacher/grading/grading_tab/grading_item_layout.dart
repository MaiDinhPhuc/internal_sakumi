import 'package:flutter/Material.dart';

class GradingItemLayout extends StatelessWidget {
  const GradingItemLayout({super.key, required this.title, required this.receivedNUmber, required this.gradingNumber, required this.button, required this.dropdown});
  final Widget title, receivedNUmber, gradingNumber, button, dropdown;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 12,
            child: Align(alignment: Alignment.centerLeft,
              child: title,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: receivedNUmber,
            )),
        Expanded(
            flex: 4,
            child: Align(alignment: Alignment.center,
              child: gradingNumber,
            )),
        Expanded(
            flex: 6,
            child: Align(alignment: Alignment.center,
              child: button,
            )),
        Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: dropdown,
            )),
      ],
    );
  }
}
