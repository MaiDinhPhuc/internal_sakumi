import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'bill_dialog_cubit.dart';

class SearchInBill extends StatelessWidget {
  const SearchInBill({super.key, required this.onDelete, required this.onChange, required this.controller, required this.enable});
  final Function() onDelete;
  final Function(String) onChange;
  final TextEditingController controller;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        TextFormField(
          controller: controller,
          enabled:enable ,
          onChanged: onChange,
          style: TextStyle(
              fontSize: Resizable.font(context, 18),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5)),
              borderRadius: BorderRadius.circular(
                  Resizable.padding(context, 5)),
            ),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    Resizable.padding(context, 5)),
                borderSide: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: Resizable.size(context, 0.5))),
          ),
        ),
        if(!enable)
          Padding(padding: EdgeInsets.only(right: Resizable.padding(context, 5)),child: InkWell(onTap: onDelete, child: const Icon(Icons.cancel, color: primaryColor))),
      ],
    );
  }
}

class SearchInBillV2 extends StatelessWidget {
  const SearchInBillV2({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        TextFormField(
          controller: controller,
          enabled:false,
          style: TextStyle(
              fontSize: Resizable.font(context, 18),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            hoverColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color(0xffE0E0E0),
                  width: Resizable.size(context, 0.5)),
              borderRadius: BorderRadius.circular(
                  Resizable.padding(context, 5)),
            ),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    Resizable.padding(context, 5)),
                borderSide: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: Resizable.size(context, 0.5))),
          ),
        ),
      ],
    );
  }
}
