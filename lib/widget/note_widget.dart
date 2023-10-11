import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class NoteWidget extends StatelessWidget {
  final String text;
  const NoteWidget(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(Resizable.size(context, 10))),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      padding: EdgeInsets.all(Resizable.padding(context, 10)),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Resizable.font(context, 19))),
    );
  }
}

class TrackingItem extends StatelessWidget {
  final bool isSubmit;
  final int? condition;
  const TrackingItem(this.condition, {this.isSubmit = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: Resizable.size(context, 50)),
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: isSubmit
              ? condition == null
                  ? const Color(0xff9E9E9E)
                  : condition! == -1
                      ? const Color(0xffF57F17)
                      : condition! > -1
                          ? const Color(0xff33691E)
                          : const Color(0xffB71C1C)
              : condition == null || condition == 0
                  ? const Color(0xff9E9E9E)
                  : (condition! > 0 && condition! < 6)
                      ? const Color(0xff33691E)
                      : const Color(0xffB71C1C)),
      child: Text(
        (isSubmit
                ? condition == null
                    ? AppText.txtNotAttendance.text
                    : condition! == -1
                        ? AppText.textNotMarked.text
                        : condition! > -1
                            ? condition.toString()
                            : AppText.txtNotSubmit.text
                : condition == null || condition == 0
                    ? AppText.txtNotAttendance.text
                    : (condition! > 0 && condition! < 5)
                        ? AppText.txtPresent.text
                        : AppText.txtNotPresent.text)
            .toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Resizable.font(context, 12),
            fontWeight: FontWeight.w800,
            color: Colors.white),
      ),
    );
  }
}
