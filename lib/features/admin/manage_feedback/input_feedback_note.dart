import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputFeedBackNote extends StatelessWidget {
  const InputFeedBackNote(
      {super.key, required this.sendNote, required this.controller});
  final Function() sendNote;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: TextFormField(
        controller: controller,
        enabled: controller.text == "" ? true : false,
        style: TextStyle(
          color: Colors.black,
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: AppText.txtLetNote.text,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Resizable.font(context, 18)),
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
          suffixIcon: controller.text != ""
              ? const Icon(Icons.check_circle, color: primaryColor)
              : InkWell(
                  onTap: sendNote,
                  child: Container(
                      margin: EdgeInsets.all(Resizable.padding(context, 5)),
                      padding:
                          EdgeInsets.only(right: Resizable.padding(context, 5)),
                      child:
                          Image.asset('assets/images/ic_send.png', scale: 5)),
                ),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 5)),
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5))),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        minLines: 1,
      ),
    );
  }
}
