import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_layout.dart';
import 'package:internal_sakumi/model/bill_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'bill_item_statistic.dart';
import 'detail_bill_statistic_cubit.dart';

class DetailBillStatisticDialog extends StatelessWidget {
  DetailBillStatisticDialog({super.key, required this.listBill})
      : detailCubit = DetailBillStatisticCubit(listBill);
  final List<BillModel> listBill;
  final DetailBillStatisticCubit detailCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBillStatisticCubit, int>(
        bloc: detailCubit,
        builder: (c, s) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.textDetail.text.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 25),
                                color: greyColor.shade600)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/ic_dropped.png',
                            color: greyColor.shade600,
                            height: Resizable.size(context, 15),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 10)),
                            child: BillLayout(
                              widgetStdName: Text(AppText.txtStdName.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetClassCode: Text(AppText.txtClassCode.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetPaymentDate: Text(
                                  AppText.txtPaymentDate.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetPayment: Text(AppText.txtPayment.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetRenewDate: Text(AppText.txtRenewDate.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetType: Text(AppText.txtBillType.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetCreator: Text(AppText.txtCreator.text,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: greyColor.shade600)),
                              widgetDropdown: Container(),
                            )),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...detailCubit.listBill
                                  .map((e) => BillItemStatistic(
                                      billModel: e, detailCubit: detailCubit))
                                  .toList(),
                            ],
                          ),
                        ))
                      ],
                    ))
                  ],
                ),
              ));
        });
  }
}
