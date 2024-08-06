import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_dropdown.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

void alertInfoVoucherApp(BuildContext context, VoucherCubit cubit) {
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
                    hintText: cubit.voucherAppModel!.voucherCode,
                    enabled: false,
                  ),
                  InputItem(
                      title: AppText.titleDiscount.text,
                      hintText: cubit.voucherAppModel!.price,
                      enabled: false),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InputItem(
                              title: AppText.txtRecipientCode.text,
                              enabled: false,
                              hintText: cubit.voucherAppModel!.recipientCode)),
                      SizedBox(width: Resizable.padding(context, 15)),
                      Expanded(
                        child: InputItem(
                          title: AppText.titleUserId.text,
                          hintText: cubit.convertUsedCode(),
                          enabled: cubit.isActiveVoucherApp(),
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
                            hintText: cubit.voucherAppModel!.expiredDate,
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
                                    hint: items.first,
                                    items: items),
                              ],
                            ),
                          )),
                    ],
                  ),
                  InputItem(
                      title: AppText.txtNote.text,
                      enabled: cubit.isActiveVoucherApp(),
                      initialValue: cubit.voucherAppModel!.noted,
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
                              isActive: cubit.isActiveVoucherApp(),
                              onPressed: () async {

                                if (conUser.text.isEmpty) {
                                  if (context.mounted) {
                                    notificationDialog(context,
                                        AppText.txtPleaseInputStudentCode.text);
                                  }
                                } else {
                                  Navigator.pop(context);
                                  waitingDialog(context);
                                  await cubit.updateVoucherApp(
                                      conUser.text,
                                      cubit.noteValue,
                                      cubit.voucherAppModel!.voucherCode
                                      );
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
