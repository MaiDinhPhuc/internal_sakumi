import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  const InputField({required this.controller, this.errorText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if ((value == null ||
            controller.text.isEmpty ||
            controller.text == null)) {
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
            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
            borderSide: BorderSide(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 0.5))),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 10,
      onChanged: (v) {},
    );
  }
}
void alertInputField(BuildContext context, TextEditingController controller,
    Function()? onPressed) {

  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(Resizable.padding(context, 15)),
            child: Container(
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              width: MediaQuery.of(context).size.width*2/3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InputField(controller: controller),
                    SizedBox(height: Resizable.size(context, 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: onPressed, child: Text(AppText.btnVerify.text)),
                        SizedBox(width: Resizable.size(context, 10)),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              controller.text = '';
                            },
                            child: Text(AppText.btnRemove.text)),
                      ],
                    )
                  ],
                ),
              ),
            ));
      });
}

void alertEditField(BuildContext context, String text,
    {required Function() onPressed, required Function(String) onChanged}) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(Resizable.padding(context, 15)),
            child: Container(
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              width: MediaQuery.of(context).size.width/2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                          fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
                      autofocus: true,
                      initialValue: text,
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
                            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
                            borderSide: BorderSide(
                                color: const Color(0xffE0E0E0),
                                width: Resizable.size(context, 0.5))),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      onChanged: onChanged,
                    ),
                    SizedBox(height: Resizable.size(context, 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: onPressed, child: Text(AppText.btnEdit.text)),
                        SizedBox(width: Resizable.size(context, 10)),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text(AppText.txtExit.text)),
                      ],
                    )
                  ],
                ),
              ),
            ));
      });
}