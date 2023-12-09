import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_date.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class VoucherForm extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherForm(this.cubit, {Key? key}) : super(key: key);

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
            Text(AppText.titleDiscount.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575))),
            InputDropdown(
                title: '',
                hint: cubit.priceVoucher,
                onChanged: (v) {
                  cubit.selectPrice(v.toString());
                },
                items: List.generate(
                    20, (index) => priceVND('${50000 * (index + 1)}')).toList())
          ],
        ),
        SizedBox(height: Resizable.size(context, 5)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.titleApplyCourse.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Resizable.font(context, 18),
                    color: const Color(0xff757575))),
            Row(
              children: [
                Expanded(
                    child: InputDropdown(
                        title: '',
                        hint: cubit.courseVoucher,
                        onChanged: (v) {
                          cubit.selectCourse(v.toString());
                        },
                        items: [
                          AppText.txtAllCourse.text,
                          AppText.txtJLPTCourse.text,
                          AppText.txtKaiwaCourse.text,
                          AppText.txtGeneralCourse.text,
                        ].toList())),
                Padding(
                  padding: EdgeInsets.only(left: Resizable.padding(context, 5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => cubit.selectFullCourse(),
                        child: cubit.isFullCourse
                            ? const Icon(
                                Icons.check_box,
                                color: primaryColor,
                              )
                            : const Icon(Icons.check_box_outline_blank),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Resizable.padding(context, 2)),
                        child: Text(AppText.txtFullCourse.text,
                            style: TextStyle(
                                color: const Color(0xff757575),
                                fontWeight: FontWeight.w500,
                                fontSize: Resizable.font(context, 18))),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        InputDate(
            title: AppText.titleExpiredDate.text,
            isVoucher: cubit.isVoucher,
            onPressed: () => cubit.buildUI(),
            errorText: AppText.txtErrorStartDate.text),
        // SizedBox(width: Resizable.size(context, 10)),
        InputItem(
          title: AppText.txtNote.text,
          controller: cubit.conNote,
          isExpand: true,
        ),
      ],
    );
  }
}
