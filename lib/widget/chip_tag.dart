import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';

import '../configs/text_configs.dart';
import '../utils/resizable.dart';

class ChipTag extends StatelessWidget {
  const ChipTag(
      {super.key,
      required this.onTap,
      required this.color,
      required this.name,
      this.onDelete, required this.description});

  final Function() onTap;
  final Function()? onDelete;
  final int color;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: EdgeInsets.all(Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: grey2,
              width: Resizable.size(context, 1)),
          borderRadius: BorderRadius.circular(
              Resizable.padding(context, 5))),
      richMessage: WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text:description,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Resizable.font(context, 18),
                      color: Colors.black),
                ),
              ),
            ],
          )),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        child: Chip(
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: Resizable.font(context, 14),
          ),
          deleteIcon: onDelete != null ? null :const Icon( Icons.close),
          deleteIconColor: Colors.white,
          onDeleted: onDelete,
          label: Text(name),
          deleteButtonTooltipMessage: AppText.btnRemove.text,
          backgroundColor: Color(color),
        ),
      ),
    );
  }
}
