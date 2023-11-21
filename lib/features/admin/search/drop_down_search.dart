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
        icon: const Icon(Icons.keyboard_arrow_down),
        buttonPadding: EdgeInsets.symmetric(
            vertical: Resizable.size(context, 10),
            horizontal: Resizable.padding(context, 15)),
        dropdownElevation: 0,
          buttonDecoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10)),
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
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.w500)),
            )))
            .toList(),
        value: value,
        onChanged: onChanged,
        //buttonHeight: Resizable.size(context, 20),
        buttonWidth: double.maxFinite,
      ),
    );
  }
}