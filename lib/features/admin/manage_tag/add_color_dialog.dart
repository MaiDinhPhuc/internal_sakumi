import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_tag_cubit.dart';

import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import '../../../widget/submit_button.dart';
import '../manage_general/input_form/input_field.dart';
import 'custom_button_v1.dart';

class AddColorDialog extends StatefulWidget {
  const AddColorDialog({super.key, required this.addTagCubit});

  final AddTagCubit addTagCubit;

  @override
  State<AddColorDialog> createState() => _AddColorDialogState();
}

class _AddColorDialogState extends State<AddColorDialog> {
  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  final TextEditingController colorCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Color? color;

  @override
  void initState() {
    super.initState();
    colorCon.addListener(() {
      if (colorCon.text.length == 7) {
        setState(() {
          color = fromHex(colorCon.text);
        });
      } else {
        setState(() {
          color = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Resizable.size(context, 16))),
        child: Container(
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          constraints: BoxConstraints(
            maxWidth: Resizable.size(context, 200),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputItem(
                    title: AppText.txtNameColor.text,
                    controller: colorCon,
                    hintText: '',
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return AppText.txtPleaseInputNameColor.text;
                      }
                      if(color == null) {
                        return AppText.txtColorWrong.text;
                      }
                      if(widget.addTagCubit.colors.contains(color!)) {
                        return AppText.txtColorExist.text;
                      }
                      return null;
                    }),
                if (color != null)
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppText.txtView.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 18),
                                color: primaryColor)),
                      ),
                      ...[
                        SizedBox(
                          width: Resizable.size(context, 5),
                        ),
                        Container(
                          width: Resizable.size(context, 25),
                          height: Resizable.size(context, 25),
                          padding:
                              EdgeInsets.all(Resizable.padding(context, 1)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color!,
                          ),
                          child: Container(),
                        ),
                      ]
                    ],
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppText.txtNoteForAddColor.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 18),
                          color: primaryColor)),
                ),
                SizedBox(
                  height: Resizable.padding(context, 10),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButtonV1(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          border: Colors.black,
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          title: AppText.btnCancel.text),
                      SizedBox(
                        width: Resizable.padding(context, 5),
                      ),
                      CustomButtonV1(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              widget.addTagCubit.addNewColor(color!);
                              Navigator.pop(context);
                            }
                          },
                          textColor: Colors.white,
                          backgroundColor: primaryColor,
                          title: AppText.btnAddNew.text),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
