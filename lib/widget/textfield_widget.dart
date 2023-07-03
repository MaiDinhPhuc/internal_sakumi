import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TextFieldWidget extends StatelessWidget {
  final String text, hintText;
  final IconData icon;
  final bool isPasswordType;
  final bool enableEditing;
  final TextEditingController? controller;
  final Color cursorColor;
  final Color iconColor;
  final bool isNumber, isUpdate;

  const TextFieldWidget(this.text, this.icon, this.isPasswordType,
      {required this.controller,
      this.enableEditing = true,
      this.cursorColor = Colors.white,
      this.iconColor = Colors.white70,
      this.isNumber = false,
      this.isUpdate = false,
      this.hintText = '',
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
      child: TextField(
        enabled: enableEditing,
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: cursorColor,
        //style: TextStyle(color: iconColor.withOpacity(0.9)),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: Resizable.size(context, 1), color: Colors.black38),
            borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: Resizable.size(context, 1), color: Colors.black38),
            borderRadius: BorderRadius.circular(Resizable.padding(context, 8)),
          ),
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          labelText: text,
          labelStyle: TextStyle(color: iconColor.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: isUpdate
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          fillColor: iconColor.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
        ),
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
            : [],
        keyboardType: !isNumber
            ? isPasswordType
                ? TextInputType.visiblePassword
                : TextInputType.emailAddress
            : const TextInputType.numberWithOptions(
                decimal: true,
              ),
      ),
    );
  }
}
