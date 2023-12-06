import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isExpand;
  final String? errorText, hintText, initialValue;
  final Function(String)? onChange;
  final bool autoFocus, enabled;
  const InputField(
      {required this.controller,
      this.isExpand = false,
      this.autoFocus = true,
      this.enabled = true,
      this.errorText, this.hintText, this.initialValue,
      this.onChange,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: TextFormField(
        enabled: enabled,
        validator: (value) {
          if ((value == null ||
                  ((controller!.text.isEmpty ||
                  controller!.text == null) && controller != null)) &&
              !isExpand) {
            return errorText;
          }
          return null;
        },
        style: TextStyle(
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        controller: controller,
        autofocus: autoFocus,
        initialValue: initialValue,
        decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
          hintText: hintText,
          hoverColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5)),
            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          ),
          filled: true,
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 5)),
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5))),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: isExpand ? null : 1,
        minLines: isExpand ? 3 : 1,
        onChanged: onChange,
      ),
    );
  }
}

class InputItem extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String? errorText, hintText, initialValue;
  final bool isExpand;
  final bool autoFocus, enabled;
  final Function(String)? onChange;
  const InputItem(
      {required this.title,
      required this.controller,
      this.isExpand = false,
      this.autoFocus = true,
      this.enabled = true,
      this.errorText, this.hintText, this.initialValue,
      this.onChange,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575))),
            InputField(
              controller: controller,
              initialValue: initialValue,
              isExpand: isExpand,
              errorText: errorText,
              hintText: hintText,
              autoFocus: autoFocus,
              onChange: onChange,
              enabled: enabled,
            ),
          ],
        ));
  }
}
