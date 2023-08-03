import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DropDownGrading extends StatelessWidget {
  const DropDownGrading({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        icon: const Icon(Icons.keyboard_arrow_down),
        buttonPadding: EdgeInsets.symmetric(
            vertical: Resizable.size(context, 0),
            horizontal: Resizable.padding(context, 10)),
        buttonDecoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: Resizable.size(context, 2),
                  color: greyColor.shade100)
            ],
            border: Border.all(
                color: greyColor.shade100),
            color: Colors.white,
            borderRadius: BorderRadius.circular(1000)),
        dropdownElevation: 0,
        dropdownDecoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        itemHeight: Resizable.size(context, 25),
        items: items
            .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Center(
              child: Text(item,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 18),
                      fontWeight: FontWeight.w500)),
            )))
            .toList(),
        value: items[0],
        onChanged: (v) {
        },
        buttonHeight: Resizable.size(context, 20),
        buttonWidth: double.maxFinite,
      ),
    );
  }
}
