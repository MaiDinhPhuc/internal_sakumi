import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InputNoteFeedBack extends StatelessWidget {
  const InputNoteFeedBack({super.key, required this.onChange});
  final Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      child: TextFormField(
        enabled: true,
        style: TextStyle(
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        initialValue: "",
        decoration: InputDecoration(
          hintText: AppText.txtPleaseInputFeedBack.text,
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
        maxLines: 5,
        minLines: 5,
        onChanged: onChange,
      ),
    );
  }
}