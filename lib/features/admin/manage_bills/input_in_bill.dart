import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';


class InputInBill extends StatelessWidget {
  const InputInBill({super.key, required this.enable, this.initialValue, required this.onChange, required this.isNote});
  final bool enable, isNote;
  final String? initialValue;
  final Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      child: TextFormField(
        enabled: enable,
        style: TextStyle(
            fontSize: Resizable.font(context, 18), fontWeight: FontWeight.w500),
        initialValue: initialValue,
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
        maxLines: isNote? 3 : 1,
        minLines: isNote? 3 : 1,
        onChanged: onChange,
      ),
    );
  }
}