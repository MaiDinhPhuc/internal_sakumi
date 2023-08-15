import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputDropdown extends StatelessWidget {
  final List<String> items;
  final String title, hint;
  final String? errorText;
  final Function(String?) onChanged;

  const InputDropdown(
      {required this.onChanged,
      required this.title,
      required this.hint,
      required this.items,
      this.errorText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5)),
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 5)),
            ),
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Resizable.padding(context, 5)),
                borderSide: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: Resizable.size(context, 0.5))),
          ),
          buttonOverlayColor: MaterialStateProperty.all(Colors.transparent),
          dropdownElevation: Resizable.size(context, 5).toInt(),
          dropdownDecoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: Resizable.size(context, 4),
                    offset: Offset(0, Resizable.size(context, 4)))
              ],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5)),
          icon: Padding(
            padding: EdgeInsets.only(right: Resizable.padding(context, 10)),
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          buttonPadding: EdgeInsets.symmetric(
              vertical: Resizable.size(context, 5),
              horizontal: Resizable.padding(context, 0)),
          hint: Container(
              alignment: Alignment.centerLeft,
              height: Resizable.size(context, 36),
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
              child: Text(
                hint,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575)),
              )),
          buttonHeight: Resizable.size(context, 36),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return errorText;
            }
            return null;
          },
          onChanged: onChanged),
    );
  }
}
