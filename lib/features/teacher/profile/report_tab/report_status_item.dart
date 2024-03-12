import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ReportStatusItem extends StatelessWidget {
  final String status;
  const ReportStatusItem(this.status, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            constraints: BoxConstraints(minWidth: Resizable.size(context, 80)),
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: getColor(status)),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Resizable.font(context, 12),
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          )
        ;
  }

  static Color getColor(String s) {
    switch (s) {
      case 'Tốt':
        return const Color(0xff33691E);
      case 'Bình thường':
        return const Color(0xffE65100);
      case 'Chưa tốt':
        return const Color(0xffF57F17);
      case 'Tệ':
        return const Color(0xffB71C1C);
      default:
        return const Color(0xff33691E);
    }
  }
}
