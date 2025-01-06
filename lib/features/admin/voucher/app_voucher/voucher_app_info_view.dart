import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherAppInfoView extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherAppInfoView(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          flex: 2, child: Image.asset('assets/images/img_voucher_text.png')),
      Expanded(
          flex: 3,
          child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(Resizable.padding(context, 5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Padding(padding: EdgeInsets.only(top: Resizable.padding(context, 15)),child: Image.asset('assets/images/img_border_app_voucher.png')),
                                Text(
                                  cubit.numMonths == "1000" ? "MIỄN PHÍ" :'MIỄN PHÍ ${cubit.numMonths} THÁNG',
                                  style: TextStyle(
                                    fontSize: Resizable.font(context, 42),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(padding:EdgeInsets.only(top: Resizable.padding(context, 25)) ,child: Text(
                                  cubit.numMonths == "1000" ? "TRỌN ĐỜI" : '${priceVND('${256000 * (int.parse(cubit.numMonths))}')}Đ',
                                  style: TextStyle(
                                    fontSize: Resizable.font(context, 70),
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    shadows:const [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.grey,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            Text(
                              'Học online vượt ngàn chông gai',
                              style: TextStyle(
                                fontSize: Resizable.font(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '[Kích hoạt tối đa ${cubit.numDevices} thiết bị]',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: Resizable.font(context, 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right:Resizable.padding(context, 5)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        Resizable.padding(context, 5)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffeeeeee),
                                        borderRadius: BorderRadius.circular(
                                            Resizable.size(context, 10))),
                                    child: cubit.qrCode == ''
                                        ? Transform.scale(
                                            scale: 0.2,
                                            child: CircularProgressIndicator(
                                              strokeWidth:
                                                  Resizable.size(context, 15),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(
                                                Resizable.padding(context, 5)),
                                            color: Colors.white,
                                            child: QrImageView(
                                                data: cubit.qrCode,
                                                backgroundColor: Colors.white,
                                                padding: EdgeInsets.zero),
                                          ),
                                  )),
                              Text(AppText.titleExpiredDate.text,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 18))),
                              Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime(
                                    cubit.expiredVoucherAppDate.year,
                                    cubit.expiredVoucherAppDate.month,
                                    cubit.expiredVoucherAppDate.day,
                                  )),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 16))),
                            ]),
                      ))
                ],
              )))
    ]);
  }
}
