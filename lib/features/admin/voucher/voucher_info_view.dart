import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherInfoView extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherInfoView(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(flex: 3, child: Container()),
          Expanded(
            flex: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: Resizable.size(context, 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/img_logo_voucher.png', height: Resizable.size(context, 24)),
                    SizedBox(width: Resizable.size(context, 5)),
                    Text(AppText.titleSakumi.text.toUpperCase(),
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: Resizable.font(context, 30),
                            fontWeight: FontWeight.w800))
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 5)),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5))),
                  child: Text(AppText.txtDirectDiscountVoucher.text,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 22))),
                ),
                Column(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: cubit.priceVoucher,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 76))),
                          TextSpan(
                              text: 'đ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 43)))
                        ])),
                    Container(
                      // margin: EdgeInsets.only(top: Resizable.padding(context, 3)),
                      height: Resizable.size(context, 3),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1000)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Resizable.padding(context, 5)),
                      child: Text(
                          AppText.txtApplyFor.text
                              .replaceAll('@', cubit.courseVoucher.toUpperCase()),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 17),
                              color: Colors.black)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.txtVoucherNote1.text,
                            style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 14))),
                        Text(AppText.txtVoucherNote2.text,
                            style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 14))),
                      ],
                    )
                  ],
                ),
                SizedBox(height: Resizable.size(context, 10)),
              ],
            ),
          ),
          Expanded(flex: 3, child: Container()),
          Expanded(
              flex: 14,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: Resizable.size(context, 10)),
                  AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding:
                        EdgeInsets.all(Resizable.padding(context, 10)),
                        decoration: BoxDecoration(
                            color: const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 10))),
                        child: cubit.qrCode == '' ? Transform.scale(
                          scale: 0.2,
                          child: CircularProgressIndicator(strokeWidth: Resizable.size(context, 15),),
                        ) : Container(
                          padding: EdgeInsets.all(Resizable.padding(context, 10)),
                          color: Colors.white,
                          child: QrImageView(
                              data: cubit.qrCode,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.zero),
                        ),
                      )),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Resizable.padding(context, 2)),
                        child: Text(
                            '${AppText.txtCode.text}: ${cubit.qrCode}'
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.font(context, 15))),
                      ),
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${AppText.titleExpiredDate.text}: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 14))),
                            TextSpan(
                                text: DateFormat('dd/MM/yyyy').format(DateTime(
                                  cubit.expiredDate.year,
                                  cubit.expiredDate.month +
                                      (cubit.isVoucher ? 3 : 0),
                                  cubit.expiredDate.day,
                                )),
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 14)))
                          ]))
                    ],
                  ),
                  SizedBox(height: Resizable.size(context, 10)),
                ],
              )),
          Expanded(flex: 3, child: Container()),
        ],
      ),
    );
  }
}
