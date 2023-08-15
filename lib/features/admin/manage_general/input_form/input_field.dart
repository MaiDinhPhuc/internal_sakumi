import 'package:flutter/material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isExpand;
  final String? errorText;
  const InputField(
      {required this.controller,
      this.isExpand = false,
      this.errorText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: TextFormField(
        validator: (value) {
          if ((value == null ||
                  controller.text.isEmpty ||
                  controller.text == null) &&
              !isExpand) {
            return errorText;
          }
          return null;
        },
        style: TextStyle(
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        controller: controller,
        autofocus: true,
        //initialValue: '',
        decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
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
        onChanged: (v) {},
      ),
    );
  }
}

class InputItem extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? errorText;
  final bool isExpand;
  const InputItem(
      {required this.title,
      required this.controller,
      this.isExpand = false,
      this.errorText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
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
              isExpand: isExpand,
              errorText: errorText,
            ),
          ],
        ));
  }
}
