import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class VoucherAppForm extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherAppForm(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputItem(
          title: AppText.titleVoucherCode.text,
          enabled: false,
          hintText: cubit.qrCode,
          controller: cubit.conCode,
        ),
        InputItem(
          title: AppText.txtRecipientCode.text,
          controller: cubit.conUser,
        ),
        // SizedBox(height: Resizable.size(context, 5)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.txtNumMonths.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575))),
            InputDropdown(
                hint: cubit.numMonths,
                onChanged: (v) {
                  cubit.selectMonths(v.toString());
                },
                items: const ["1","2","3","6","12","Trọn đời"])
          ],
        ),
        SizedBox(height: Resizable.size(context, 5)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.txtNumDevices.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575))),
            InputDropdown(
                hint: cubit.numDevices,
                onChanged: (v) {
                  cubit.selectDevices(v.toString());
                },
                items: List.generate(50, (index)=>(index+1).toString()).toList())
          ],
        ),
        InputDateVoucherApp(
            title: AppText.titleExpiredDate.text,
            cubit: cubit
        ),
        InputItem(
          title: AppText.txtNote.text,
          controller: cubit.conNote,
          isExpand: true,
        ),
      ],
    );
  }
}
