import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'add_schedule_cubit.dart';

class ChooseTimeDialog extends StatelessWidget {
  const ChooseTimeDialog({super.key, required this.addCubit, required this.index});
  final AddScheduleCubit addCubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
      child: Container(
        height: Resizable.size(context, 162),
        width: Resizable.size(context, 270),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Từ",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 20)),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
              width: Resizable.size(context, 100),
              height: Resizable.size(context, 30),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "00",
                          isDense: true,
                          fillColor: Colors.white,
                          hoverColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5)),
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Resizable.padding(context, 5)),
                              borderSide: BorderSide(
                                  color: const Color(0xffE0E0E0),
                                  width: Resizable.size(context, 0.5))),
                        ),
                        onChanged: (value) {
                          addCubit.inputFromHour(value);
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5)),
                      child: Text(
                        ":",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 20)),
                      )),
                  Expanded(
                      flex: 1,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "00",
                          isDense: true,
                          fillColor: Colors.white,
                          hoverColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5)),
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Resizable.padding(context, 5)),
                              borderSide: BorderSide(
                                  color: const Color(0xffE0E0E0),
                                  width: Resizable.size(context, 0.5))),
                        ),
                        onChanged: (value) {
                          addCubit.inputFromMinute(value);
                        },
                      ))
                ],
              ),
            ),
            Text(
              "Đến",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Resizable.font(context, 20)),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
              width: Resizable.size(context, 100),
              height: Resizable.size(context, 30),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "00",
                          isDense: true,
                          fillColor: Colors.white,
                          hoverColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5)),
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Resizable.padding(context, 5)),
                              borderSide: BorderSide(
                                  color: const Color(0xffE0E0E0),
                                  width: Resizable.size(context, 0.5))),
                        ),
                        onChanged: (value) {
                          addCubit.inputToHour(value);
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5)),
                      child: Text(
                        ":",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Resizable.font(context, 20)),
                      )),
                  Expanded(
                      flex: 1,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "00",
                          isDense: true,
                          fillColor: Colors.white,
                          hoverColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5)),
                            borderRadius: BorderRadius.circular(
                                Resizable.padding(context, 5)),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Resizable.padding(context, 5)),
                              borderSide: BorderSide(
                                  color: const Color(0xffE0E0E0),
                                  width: Resizable.size(context, 0.5))),
                        ),
                        onChanged: (value) {
                          addCubit.inputToMinute(value);
                        },
                      ))
                ],
              ),
            ),
            SizedBox(height: Resizable.padding(context, 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(
                      minWidth: Resizable.size(context, 100)),
                  margin: EdgeInsets.only(
                      right: Resizable.padding(context, 20)),
                  child: DialogButton(
                      AppText.textCancel.text.toUpperCase(),
                      onPressed: () =>
                          Navigator.pop(context)),
                ),
                Container(
                  constraints: BoxConstraints(
                      minWidth: Resizable.size(context, 100)),
                  child: SubmitButton(
                      onPressed: () async {
                        if (addCubit.checkTime() ==
                            true) {
                          addCubit.chooseDay(index);
                          Navigator.pop(context);
                        }
                      },
                      title: AppText.txtOK.text),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
