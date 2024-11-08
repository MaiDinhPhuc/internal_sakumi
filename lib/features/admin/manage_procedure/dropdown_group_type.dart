import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DropDownProcedureGroup extends StatelessWidget {
  const DropDownProcedureGroup(
      {super.key,
        required this.items,
        required this.value,
        required this.onChanged});
  final List<String> items;
  final String value;
  final Function(String?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.size(context, 10)),
      padding: EdgeInsets.symmetric(vertical: Resizable.size(context, 5)),
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: greyColor.shade100)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down),
          ),
          buttonStyleData: ButtonStyleData(
            height: Resizable.size(context, 25),
              padding: EdgeInsets.symmetric(
                  vertical: Resizable.size(context, 5),
                  horizontal: Resizable.padding(context, 10)),
              width: double.maxFinite
          ),
          dropdownStyleData: DropdownStyleData(
              elevation: 0,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10))),
          menuItemStyleData: MenuItemStyleData(
            height:  Resizable.size(context, 25),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(item,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w700)),
              )))
              .toList(),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DropdownGroupDisable extends StatelessWidget {
  const DropdownGroupDisable({super.key, required this.value});
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: Resizable.size(context, 10)),
        padding: EdgeInsets.symmetric(
            vertical: Resizable.size(context, 10),
            horizontal: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: greyColor.shade100)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(value,
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  fontWeight: FontWeight.w500))
        ));
  }
}