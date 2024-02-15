import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_bill_cubit.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'bill_dialog_cubit.dart';
import 'confirm_delete_bill.dart';
import 'info_bill_view.dart';
import 'manage_bill_cubit.dart';

class BillDialog extends StatelessWidget {
  BillDialog(
      {Key? key, required this.isEdit, this.billModel, required this.cubit})
      : billDialogCubit = BillDialogCubit(billModel, null),
        super(key: key);

  final bool isEdit;
  final BillModel? billModel;
  final ManageBillCubit cubit;
  final BillDialogCubit billDialogCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillDialogCubit, int>(
        bloc: billDialogCubit,
        builder: (c,s){
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
                        child: InfoBillView(billDialogCubit: billDialogCubit, isEdit: isEdit)),
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin:
                          EdgeInsets.only(top: Resizable.padding(context, 20)),
                          child: Row(
                            mainAxisAlignment: isEdit && !billModel!.delete
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                            children: [
                              if (isEdit && !billModel!.delete)
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
                                        onPressed: ()async{
                                          if(isEdit){
                                            await billDialogCubit.updateBill(cubit);
                                          }else{
                                            await billDialogCubit.addNewBill(cubit);
                                          }
                                          Navigator.pop(context);
                                        },
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
    });
  }
}

class BillDialogV2 extends StatelessWidget {
  BillDialogV2(
      {Key? key, required this.isEdit, this.billModel, required this.cubit})
      : billDialogCubit = BillDialogCubit(billModel,cubit.student!),
        super(key: key);

  final bool isEdit;
  final BillModel? billModel;
  final ManageStdBillCubit cubit;
  final BillDialogCubit billDialogCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillDialogCubit, int>(
        bloc: billDialogCubit,
        builder: (c,s){
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
                            child: InfoBillViewV2(billDialogCubit: billDialogCubit, isEdit: isEdit)),
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin:
                              EdgeInsets.only(top: Resizable.padding(context, 20)),
                              child: Row(
                                mainAxisAlignment: isEdit && !billModel!.delete
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isEdit && !billModel!.delete)
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth: Resizable.size(context, 100)),
                                      child: DeleteButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ConfirmDeleteBillV2(cubit: cubit, billModel: billModel!));
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
                                            onPressed: ()async{
                                              if(isEdit){
                                                await billDialogCubit.updateBillV2(cubit);
                                              }else{
                                                await billDialogCubit.addNewBillV2(cubit);
                                              }
                                              Navigator.pop(context);
                                            },
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
        });
  }
}
