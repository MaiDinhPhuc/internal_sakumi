import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
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

class InputPaymentInBill extends StatelessWidget {
  const InputPaymentInBill({super.key, this.initialValue, required this.onChange});
  final String? initialValue;
  final Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      child: TextFormField(
        inputFormatters: [ThousandsInputFormatter()],
        enabled: true,
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
        maxLines:  1,
        minLines:  1,
        onChanged: onChange,
      ),
    );
  }
}

class ThousandsInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }
    return newValue;
  }
}