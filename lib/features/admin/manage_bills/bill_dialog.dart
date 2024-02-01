import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'bill_dialog_cubit.dart';
import 'confirm_check_bill.dart';
import 'confirm_delete_bill.dart';
import 'info_bill_view.dart';
import 'manage_bill_cubit.dart';

class BillDialog extends StatelessWidget {
  BillDialog(
      {Key? key, required this.isEdit, this.billModel, required this.cubit})
      : billDialogCubit = BillDialogCubit(billModel),
        super(key: key);

  final bool isEdit;
  final BillModel? billModel;
  final ManageBillCubit cubit;
  final BillDialogCubit billDialogCubit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
        child: Form(
            child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.all(Resizable.padding(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin:
                        EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                    child: Text(
                      AppText.titleBillDialog.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child: InfoBillView(billDialogCubit: billDialogCubit)),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: Resizable.padding(context, 20)),
                    child: Row(
                      mainAxisAlignment: isEdit
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (isEdit)
                          Container(
                            constraints: BoxConstraints(
                                minWidth: Resizable.size(context, 100)),
                            child: DeleteButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ConfirmDeleteBill(cubit: cubit, billModel: billModel!));
                                },
                                title: AppText.txtDeleteBill.text),
                          ),
                        Row(
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
                                  onPressed: () async {},
                                  title: isEdit
                                      ? AppText.btnUpdate.text
                                      : AppText.btnAdd.text),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
