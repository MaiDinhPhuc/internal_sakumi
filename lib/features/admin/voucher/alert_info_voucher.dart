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
  final TextEditingController conCode = TextEditingController();
  final TextEditingController conDiscount = TextEditingController();
  final TextEditingController conRecipient = TextEditingController();
  final TextEditingController conNote = TextEditingController();
  final TextEditingController conUser = TextEditingController();
  final TextEditingController conExpiredDate = TextEditingController();
  final TextEditingController conCourse = TextEditingController();

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
                    controller: conCode,
                    hintText: cubit.voucherModel!.voucherCode,
                    enabled: false,
                  ),
                  InputItem(
                      title: AppText.titleDiscount.text,
                      controller: conDiscount,
                      hintText: cubit.voucherModel!.price,
                      enabled: false),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InputItem(
                              title: AppText.txtRecipientCode.text,
                              controller: conRecipient,
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
                              title: AppText.titleApplyCourse.text,
                              controller: conCourse,
                              enabled: false,
                              hintText: cubit.voucherModel!.type)),
                      SizedBox(width: Resizable.padding(context, 15)),
                      Expanded(
                          child: InputItem(
                        title: AppText.titleExpiredDate.text,
                        controller: conExpiredDate,
                        hintText: cubit.voucherModel!.expiredDate,
                        enabled: false,
                      ))
                    ],
                  ),
                  InputItem(
                      title: AppText.txtNote.text,
                      controller: null,
                      enabled: cubit.voucherModel!.usedDate.isEmpty,
                      initialValue: cubit.voucherModel!.noted,
                      onChange: (v) {
                        cubit.updateNote(v);
                      },
                      isExpand: true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppText.titleStatus.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Resizable.font(context, 18),
                              color: const Color(0xff757575))),
                      InputDropdown(
                          onChanged: (v) => cubit.selectStatus(v.toString()),
                          title: '',
                          hint: items.first,
                          items: items),
                    ],
                  ),
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
                                String date = cubit.status != AppText.txtNew.text
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
                                    Navigator.pop(context);
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
