import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class DropDownSurveyType extends StatelessWidget {
  const DropDownSurveyType(
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: greyColor.shade100)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          icon: const Icon(Icons.keyboard_arrow_down),
          buttonPadding: EdgeInsets.symmetric(
              vertical: Resizable.size(context, 5),
              horizontal: Resizable.padding(context, 15)),
          dropdownElevation: 0,
          buttonDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(10)),
          dropdownDecoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          itemHeight: Resizable.size(context, 25),
          items: items
              .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        item == AppText.txtSurveyType1.text
                            ? const Icon(Icons.radio_button_checked,
                                color: primaryColor)
                            : item == AppText.txtSurveyType2.text
                                ? const Icon(Icons.check_box_rounded,
                                    color: primaryColor)
                                : const Icon(Icons.menu,
                                    color: primaryColor),
                        Padding(padding: EdgeInsets.only(left: Resizable.padding(context, 10)),child: Text(item,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 20),
                                fontWeight: FontWeight.w700)))
                      ],
                    ),
                  )))
              .toList(),
          value: value,
          onChanged: onChanged,
          //buttonHeight: Resizable.size(context, 20),
          buttonWidth: double.maxFinite,
        ),
      ),
    );
  }
}
