import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final Widget suffixIcon;
  final TextEditingController txt;
  final ValueChanged<String> onChanged;
  final Widget widget;

  const SearchField(this.hintText,
      {super.key,
      required this.txt,
      required this.onChanged,
      required this.suffixIcon,
      required this.widget});

  @override
  Widget build(BuildContext context) => TextFormField(
        onChanged: onChanged,
        controller: txt,
        initialValue: null,
        cursorColor: Colors.black,
        style: TextStyle(
            fontSize: Resizable.font(context, 25), color: Colors.black),
        decoration: InputDecoration(
          fillColor: const Color(0xffF4F6FD),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Resizable.font(context, 20),
              color: const Color(0xFF461220).withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
          ),
          constraints: BoxConstraints(maxHeight: Resizable.size(context, 40)),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget,
              Container(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    top: Resizable.padding(context, 8),
                    bottom: Resizable.padding(context, 8)),
                width: Resizable.size(context, 1),
                color: Colors.black,
              )
            ],
          ),
          labelStyle: TextStyle(
              fontSize: Resizable.font(context, 18),
              color: Colors.grey.shade900),
          errorMaxLines: 2,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
      );
}
