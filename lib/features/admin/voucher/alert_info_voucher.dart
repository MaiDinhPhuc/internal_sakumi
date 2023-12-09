import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

void alertInfoVoucher(BuildContext context, VoucherCubit cubit) {
  final TextEditingController conUser = TextEditingController();

  var items = [AppText.txtNew.text, AppText.txtUsed.text];

  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(Resizable.padding(context, 20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                        EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                    child: Text(
                      AppText.titleInfoVoucher.text.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  ),
                  InputItem(
                    title: AppText.titleVoucherCode.text,
                    hintText: cubit.voucherModel!.voucherCode,
                    enabled: false,
                  ),
                  InputItem(
                      title: AppText.titleDiscount.text,
                      hintText: cubit.voucherModel!.price,
                      enabled: false),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InputItem(
                              title: AppText.titleApplyCourse.text,
                              enabled: false,
                              hintText: cubit.voucherModel!.type)),
                      SizedBox(width: Resizable.padding(context, 15)),
                      Expanded(
                          child: Row(
                        children: [
                          InkWell(
                              child: cubit.isFullCourse
                                  ? const Icon(
                                      Icons.check_box,
                                      color: Color(0xffE0E0E0),
                                    )
                                  : const Icon(Icons.check_box_outline_blank,
                                      color: Color(0xffE0E0E0))),
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
                      ))
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InputItem(
                              title: AppText.txtRecipientCode.text,
                              enabled: false,
                              hintText: cubit.voucherModel!.recipientCode)),
                      SizedBox(width: Resizable.padding(context, 15)),
                      Expanded(
                        child: InputItem(
                          title: AppText.titleUserId.text,
                          hintText: cubit.voucherModel!.usedUserCode,
                          enabled: cubit.voucherModel!.usedDate.isEmpty,
                          controller: conUser,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InputItem(
                        title: AppText.titleExpiredDate.text,
                        hintText: cubit.voucherModel!.expiredDate,
                        enabled: false,
                      )),
                      SizedBox(width: Resizable.padding(context, 15)),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                            bottom: Resizable.padding(context, 5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.titleStatus.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 18),
                                    color: const Color(0xff757575))),
                            InputDropdown(
                                onChanged: (v) =>
                                    cubit.selectStatus(v.toString()),
                                title: '',
                                hint: items.first,
                                items: items),
                          ],
                        ),
                      )),
                    ],
                  ),
                  InputItem(
                      title: AppText.txtNote.text,
                      enabled: cubit.voucherModel!.usedDate.isEmpty,
                      initialValue: cubit.voucherModel!.noted,
                      onChange: (v) {
                        cubit.updateNote(v);
                      },
                      isExpand: true),
                  Container(
                    margin:
                        EdgeInsets.only(top: Resizable.padding(context, 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth: Resizable.size(context, 100)),
                          margin: EdgeInsets.only(
                              right: Resizable.padding(context, 20)),
                          child: DialogButton(
                              AppText.textCancel.text.toUpperCase(),
                              onPressed: () => Navigator.pop(context)),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              minWidth: Resizable.size(context, 100)),
                          child: SubmitButton(
                              isActive: cubit.voucherModel!.usedDate.isEmpty,
                              onPressed: () async {
                                String date =
                                    cubit.status != AppText.txtNew.text
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now())
                                        : '';
                                if (date.isNotEmpty && conUser.text.isEmpty) {
                                  if (context.mounted) {
                                    notificationDialog(context,
                                        AppText.txtPleaseInputStudentCode.text);
                                  }
                                } else {
                                  Navigator.pop(context);
                                  waitingDialog(context);
                                  await cubit.updateVoucher(
                                      conUser.text,
                                      cubit.initialValue,
                                      cubit.voucherModel!.voucherCode,
                                      date);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    notificationDialog(
                                        context,
                                        AppText
                                            .txtSuccessfullyUpdateVoucher.text);
                                  }
                                }
                              },
                              title: AppText.btnUpdate.text),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
