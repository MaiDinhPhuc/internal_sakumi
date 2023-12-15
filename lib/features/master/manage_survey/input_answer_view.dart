import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_survey_cubit.dart';

class InputAnswerView extends StatelessWidget {
  const InputAnswerView(
      {super.key,
      required this.detailSurveyCubit,
      required this.type,
      required this.isExpand,
      this.hintText,
      this.onChange,
      required this.autoFocus,
      required this.enabled,
      required this.controller,
      required this.index});
  final TextEditingController controller;
  final DetailSurveyCubit detailSurveyCubit;
  final int type, index;
  final bool isExpand;
  final String? hintText;
  final Function(String)? onChange;
  final bool autoFocus, enabled;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Icon(
                type == 1
                    ? Icons.radio_button_off
                    : Icons.check_box_outline_blank,
                color: primaryColor,
                size: Resizable.size(context, 20))),
        Expanded(
            flex: 12,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
              child: TextFormField(
                enabled: enabled,
                controller: controller,
                style: TextStyle(
                    fontSize: Resizable.font(context, 18),
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    hintText: hintText,
                    hoverColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xffE0E0E0),
                          width: Resizable.size(context, 0.5)),
                      borderRadius:
                          BorderRadius.circular(Resizable.padding(context, 5)),
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            Resizable.padding(context, 5)),
                        borderSide: BorderSide(
                            color: const Color(0xffE0E0E0),
                            width: Resizable.size(context, 0.5))),
                    suffixIcon: enabled
                        ? InkWell(
                            onTap: () {
                              detailSurveyCubit.deleteAnswer(index);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                          )
                        : null),
                keyboardType: TextInputType.multiline,
                maxLines: isExpand ? null : 1,
                minLines: isExpand ? 1 : 1,
                onChanged: onChange,
              ),
            ))
      ],
    );
  }
}
