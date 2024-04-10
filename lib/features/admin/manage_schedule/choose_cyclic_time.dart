import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'add_schedule_cubit.dart';

class ChooseCyclicTime extends StatelessWidget {
  const ChooseCyclicTime({super.key, required this.addCubit});
  final AddScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Resizable.size(context, 275),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade300),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(Resizable.size(context, 10)),
            height: Resizable.size(context, 250),
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: greyColor.shade300),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Column(
              children: [
                ...addCubit.listDay.map((e) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(e,
                          style:
                              TextStyle(fontSize: Resizable.font(context, 20))),
                      value: addCubit.listDayChoose.contains(e),
                      onChanged: (newValue) {
                        addCubit.chooseDay(e);
                      },
                    ))
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(Resizable.size(context, 10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Từ",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Resizable.font(context, 20)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                    width: Resizable.size(context, 100),
                    height: Resizable.size(context, 30),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: TextField(
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
                                addCubit.inputFromHour(value);
                              },
                            )),
                        Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),child: Text(
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
                    margin: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
                    width: Resizable.size(context, 100),
                    height: Resizable.size(context, 30),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: TextField(
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
                        Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),child: Text(
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
                ],
              )),
        ],
      ),
    );
  }
}
