import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_layout.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';
import 'package:intl/intl.dart';

import 'detail_bill_statistic_cubit.dart';

class DetailBillStatisticView extends StatelessWidget {
  const DetailBillStatisticView(
      {super.key,
        required this.onPressed,
        this.isExpand = false,
        required this.billModel,
        required this.cubit, });
  final Function() onPressed;
  final bool isExpand;
  final DetailBillStatisticCubit cubit;
  final BillModel billModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
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
                        "${NumberFormat('#,##0').format(billModel.payment)}${billModel.currency == "Tiền Việt(vnđ)" ? "đ" : "¥"}",
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
                            fontSize: Resizable.font(context, 15),
                            color: primaryColor)),
                    widgetCreator: Text(
                        billModel.creator,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Resizable.font(context, 18),
                            color: Colors.black)),
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
                                          text: "  ${NumberFormat('#,##0').format(billModel.refund)}${billModel.currency == "Tiền Việt(vnđ)" ? "đ" : "¥"}",
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
                                          text: "  ${NumberFormat('#,##0').format(billModel.payment - billModel.refund)}${billModel.currency == "Tiền Việt(vnđ)" ? "đ" : "¥"}",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: Resizable.font(context, 19)))])
                                ))
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 10)),child: Row(
                              mainAxisAlignment: billModel.delete?MainAxisAlignment.spaceBetween:MainAxisAlignment.end,
                              children: [
                                if(billModel.delete)
                                  Text(AppText.stsRemove.text,
                                    style: TextStyle(
                                        color: redColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))),
                                billModel.check == "notCheck"? Text(AppText.txtNotCheck.text,
                                    style: TextStyle(
                                        color: redColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19))) :Text(AppText.txtChecked.text,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 19)))
                              ],
                            ))
                          ],
                        ))
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                  right: Resizable.padding(context, 20),
                  top: Resizable.padding(context, 0)),
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