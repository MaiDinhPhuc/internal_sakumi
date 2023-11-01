import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class Input2Field extends StatelessWidget {
  final String title1, title2;
  final TextEditingController con1, con2;
  final bool enable;
  const Input2Field(
      {super.key,
      required this.title1,
      required this.title2,
      required this.con1,
      required this.con2,
      this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title1,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: const Color(0xff757575))),
                      InputField(
                          controller: con1,
                          errorText: AppText.txtPleaseInput.text,
                          enabled: enable)
                    ],
                  )),
              SizedBox(width: Resizable.size(context, 20)),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title2,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: const Color(0xff757575))),
                      InputField(
                          controller: con2,
                          errorText: AppText.txtPleaseInput.text,
                          enabled: enable)
                    ],
                  ))
            ],
          ),
        ));
  }
}
