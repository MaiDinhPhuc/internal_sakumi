import 'package:flutter/Material.dart';

class BillLayout extends StatelessWidget {
  const BillLayout(
      {super.key,
      required this.widgetStdName,
      required this.widgetClassCode,
      required this.widgetPaymentDate,
      required this.widgetPayment,
      required this.widgetRenewDate,
      required this.widgetType,
      required this.widgetStatus,
      required this.widgetDropdown});
  final Widget widgetStdName,
      widgetClassCode,
      widgetPaymentDate,
      widgetPayment,
      widgetRenewDate,
      widgetType,
      widgetStatus,
      widgetDropdown;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: widgetStdName,
            )),
        Expanded(
            flex: 2,
            child:
                Container(alignment: Alignment.center, child: widgetClassCode)),
        Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.center, child: widgetPaymentDate)),
        Expanded(
            flex: 3,
            child:
                Container(alignment: Alignment.center, child: widgetPayment)),
        Expanded(
            flex: 3,
            child:
                Container(alignment: Alignment.center, child: widgetRenewDate)),
        Expanded(
            flex: 3,
            child: Container(alignment: Alignment.center, child: widgetType)),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: widgetStatus)),
        Expanded(
            flex: 1,
            child:
                Container(alignment: Alignment.center, child: widgetDropdown))
      ],
    );
  }
}
