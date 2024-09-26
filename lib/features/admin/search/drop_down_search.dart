import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DropDownSearch extends StatelessWidget {
  const DropDownSearch({super.key, required this.items, required this.onChanged, required this.value});
  final List<String> items;
  final String value;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        menuItemStyleData: MenuItemStyleData(
          height: Resizable.size(context, 25)
        ),
        iconStyleData:const IconStyleData(
          icon:  Icon(Icons.keyboard_arrow_down)
        ),
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(
        vertical: Resizable.size(context, 10),
        horizontal: Resizable.padding(context, 10)),
          width: double.maxFinite
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
          )
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
    );
  }
}