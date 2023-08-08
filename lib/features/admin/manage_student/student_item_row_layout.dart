import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StudentItemRowLayout extends StatelessWidget {
  final String name, phone, code;
  final bool isHeader;
  const StudentItemRowLayout({this.isHeader = false, required this.name, required this.phone, required this.code, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name, style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Resizable.font(context, 17),
              color: isHeader ? const Color(0xff757575) : const Color(0xff131111)
          )),
        )),
        Expanded(flex: 3, child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            phone, style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Resizable.font(context, 17),
              color: isHeader ? const Color(0xff757575) : const Color(0xff131111)
          ),
          ),
        )),
        Expanded(flex: 3, child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            code, style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Resizable.font(context, 17),
              color: isHeader ? const Color(0xff757575) : const Color(0xff131111)
          ),
          ),
        )),
        Expanded(flex: 1, child: Align(
          alignment: Alignment.center,
          child: Container(),
        )),
      ],
    );
  }
}
