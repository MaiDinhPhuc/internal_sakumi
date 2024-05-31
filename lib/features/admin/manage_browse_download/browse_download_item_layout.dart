import 'package:flutter/Material.dart';

class BrowseDownloadItemLayout extends StatelessWidget {
  const BrowseDownloadItemLayout(
      {super.key,
      required this.widgetTitle,
      required this.widgetSensei,
      required this.widgetClassCode,
      required this.widgetRequestDate,
      required this.widgetAcceptDate,
      required this.widgetDownloadDate,
      required this.widgetButton});
  final Widget widgetTitle,
      widgetSensei,
      widgetClassCode,
      widgetRequestDate,
      widgetAcceptDate,
      widgetDownloadDate,
      widgetButton;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 12,
            child: Container(
              alignment: Alignment.centerLeft,
              child: widgetTitle,
            )),
        Expanded(
            flex: 2,
            child: Container(alignment: Alignment.center, child: widgetSensei)),
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: widgetClassCode,
            )),
        Expanded(
            flex: 4,
            child: Container(
                alignment: Alignment.center, child: widgetRequestDate)),
        Expanded(
            flex: 4,
            child: Container(
                alignment: Alignment.center, child: widgetAcceptDate)),
        Expanded(
            flex: 6,
            child: Container(
                alignment: Alignment.center, child: widgetDownloadDate)),
        Expanded(
            flex: 4,
            child: Container(alignment: Alignment.center, child: widgetButton)),
      ],
    );
  }
}
