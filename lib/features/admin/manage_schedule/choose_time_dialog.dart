import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'add_cyclic_schedule_cubit.dart';

class ChooseTimeDialog extends StatelessWidget {
  const ChooseTimeDialog({super.key, required this.addCubit, required this.index});
  final AddCyclicScheduleCubit addCubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
      child: Container(
        height: Resizable.size(context, 140),
        width: Resizable.size(context, 270),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(
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
                          child:  TextFormField(
                            initialValue: addCubit.fromHour,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: addCubit.fromHour,
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
                          child: TextFormField(
                            initialValue: addCubit.fromMinute,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
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
                          child:  TextFormField(
                            initialValue: addCubit.toHour,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
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
                          child:  TextFormField(
                            initialValue: addCubit.toMinute,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
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
                )],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      title: AppText.txtUpdate.text),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10)),
                  constraints: BoxConstraints(
                      minWidth: Resizable.size(context, 100)),
                  child: SubmitButton(
                      onPressed: () async {
                        addCubit.cancelDay(index);
                        Navigator.pop(context);
                      },
                      title: AppText.txtCancelChoose.text),
                ),
                Container(
                  constraints: BoxConstraints(
                      minWidth: Resizable.size(context, 100)),
                  child: DialogButton(
                      AppText.textCancel.text.toUpperCase(),
                      onPressed: () =>
                          Navigator.pop(context)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
