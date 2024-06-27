import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DropDownGrading extends StatelessWidget {
  const DropDownGrading(
      {super.key,
      required this.items,
      required this.onChanged,
      required this.value});
  final List<String> items;
  final String value;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
        buttonStyleData: ButtonStyleData(
          height: Resizable.size(context, 20),
          width: double.maxFinite,
          padding:
              EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
          decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: Resizable.size(context, 2),
                      color: greyColor.shade100)
                ],
                border: Border.all(
                    color: greyColor.shade100),
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000)
          )
        ),
        menuItemStyleData: MenuItemStyleData(
          height: Resizable.size(context, 25)
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10)),

        ),
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
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
