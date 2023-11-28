import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class InfoField extends StatelessWidget {
  const InfoField({super.key, required this.value, required this.onChange, this.enable= true});

  final String value;
  final Function(String?) onChange;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
      child: TextFormField(
        onChanged: onChange,
        initialValue: value,
        enabled: enable,
        style: TextStyle(
            color: Colors.black,
            fontSize: Resizable.font(context, 18),
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
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
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Resizable.padding(context, 5)),
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5))),
          focusedBorder: OutlineInputBorder(
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
