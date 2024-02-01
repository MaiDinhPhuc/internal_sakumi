import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import 'manage_bill_cubit.dart';

class ConfirmCheckBill extends StatelessWidget {
  const ConfirmCheckBill(
      {Key? key, required this.billModel, required this.cubit})
      : super(key: key);
  final BillModel billModel;
  final ManageBillCubit cubit;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmCheckBill.text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      titlePadding:
          EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset(
        'assets/images/ic_edit.png',
        height: Resizable.size(context, 120),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            onPress: () {
              Navigator.pop(context);
            },
            bgColor: Colors.white,
            foreColor: Colors.black,
            text: AppText.txtBack.text),
        CustomButton(
            onPress: () async {
              FirebaseFirestore.instance
                  .collection('bill')
                  .doc('bill_${billModel.createDate}')
                  .update({'check': !billModel.check}).whenComplete(() {
                cubit.updateListBill(
                    billModel,
                    BillModel(
                        classId: billModel.classId,
                        userId: billModel.userId,
                        paymentDate: billModel.paymentDate,
                        renewDate: billModel.renewDate,
                        payment: billModel.payment,
                        note: billModel.note,
                        refund: billModel.refund,
                        type: billModel.type,
                        status: billModel.status,
                        check: !billModel.check,
                        createDate: billModel.createDate,
                        delete: billModel.delete));
                Navigator.pop(context);
              });
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}
