import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';

import 'bill_layout.dart';
import 'manage_bill_cubit.dart';

class BillView extends StatelessWidget {
  const BillView(
      {super.key,
      required this.onTap,
      required this.onPressed,
      this.isExpand = false,
      required this.billModel,
      required this.cubit, required this.onCheck});
  final Function() onPressed;
  final Function() onTap;
  final Function() onCheck;
  final bool isExpand;
  final ManageBillCubit cubit;
  final BillModel billModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1),
              color: isExpand ? Colors.black : greyColor.shade100),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Stack(
        children: [
          Container(
              padding:
                  EdgeInsets.symmetric(vertical: Resizable.padding(context, 9)),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  BillLayout(
                    widgetStdName: Text(cubit.getStudent(billModel.userId),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
                    widgetClassCode: Text(cubit.getClassCode(billModel.classId),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
                    widgetPaymentDate: Text(
                        cubit.convertDate(billModel.paymentDate),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
                    widgetPayment: Text(
                        "${NumberFormat('#,##0').format(billModel.payment)}đ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
                    widgetRenewDate: Text(
                        cubit.convertDate(billModel.renewDate),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
                    widgetType: Text(billModel.type,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: primaryColor)),
                    widgetStatus: Image.asset(
                      billModel.check == "notCheck"
                          ? "assets/images/ic_not_check_bill.png"
                          : "assets/images/ic_check_bill.png",
                      height: Resizable.size(context, 30),
                      width: Resizable.size(context, 30),
                    ),
                    widgetDropdown: Container(),
                  ),
                  if (isExpand)
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.padding(context, 15),
                            vertical: Resizable.padding(context, 5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppText.txtNote.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 19))),
                            NoteWidget(billModel.note),
                            Row(
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: AppText.txtRefund.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                            Resizable.font(context, 19)), children: [
                                      TextSpan(
                                          text: "  ${NumberFormat('#,##0').format(billModel.refund)}đ",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 19)))])
                                    ),
                                Padding(padding: EdgeInsets.only(left: Resizable.size(context, 10)),child: RichText(
                                    text: TextSpan(
                                        text: AppText.txtRevenue.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                            Resizable.font(context, 19)), children: [
                                      TextSpan(
                                          text: "  ${NumberFormat('#,##0').format(billModel.payment - billModel.refund)}đ",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 19)))])
                                ))
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 10)),child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                billModel.delete ? Text(AppText.stsRemove.text,
                                    style: TextStyle(
                                        color: redColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))) :
                                SubmitButton(
                                    onPressed: onTap, title: AppText.txtEdit.text),
                                SubmitButton(
                                    isActive: billModel.check == "notCheck",
                                    onPressed: onCheck, title: billModel.check == "notCheck" ? AppText.txtCheck.text :AppText.txtChecked.text)
                              ],
                            ))
                          ],
                        ))
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                  right: Resizable.padding(context, 20),
                  top: Resizable.padding(context, 10)),
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: onPressed,
                  splashRadius: Resizable.size(context, 15),
                  icon: Icon(
                    isExpand
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ))),
        ],
      ),
    );
  }
}
