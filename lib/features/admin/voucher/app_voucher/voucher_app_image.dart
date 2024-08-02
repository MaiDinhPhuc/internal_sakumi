import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/app_voucher/voucher_app_info_view.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/social_info_view.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/voucher_course_info_view.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/model/voucher_app_model.dart';
import 'package:internal_sakumi/model/voucher_course_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';

class VoucherAppImage extends StatelessWidget {
  final VoucherCubit cubit;
  final _globalKey = GlobalKey();
  VoucherAppImage(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 10)),
                  border: Border.all(
                      color: const Color(0xff757575),
                      width: Resizable.size(context, 0.5))),
              padding: EdgeInsets.all(Resizable.padding(context, 15)),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  borderRadius:
                  BorderRadius.circular(Resizable.padding(context, 15)),
                ),
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container()),
                      Expanded(
                          flex: 7,
                          child: Container(
                        padding: EdgeInsets.all(Resizable.padding(context, 5)),
                        color: primaryColor.shade300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 54,
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset('assets/images/img_voucher_app.png'),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container()),
                            Expanded(
                                flex: 110, child: VoucherAppInfoView(cubit)),
                          ],
                        ),
                      )),
                      Expanded(
                          flex: 1,
                          child: Container()),
                    ],
                  ),
                )
              ),
            )),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SubmitButton(
                    isActive: !cubit.isDownload,
                    onPressed: () async {
                      await cubit.createNewVoucherApp(
                          context,
                          VoucherAppModel(
                            id: cubit.numVoucher,
                            recipientCode: cubit.conUser.text,
                            usedUserCode: [],
                            voucherCode: cubit.qrCode,
                            createDate: cubit.createDate,
                            usedDate: '',
                            expiredDate:cubit.dateExpired,
                            noted: cubit.conNote.text,
                            price: priceVND('${256000 * (int.parse(cubit.numMonths))}'),
                          ));
                    },
                    title: AppText.btnCreateVoucher.text.toUpperCase()),
                SizedBox(width: Resizable.size(context, 10)),
                SubmitButton(
                    isActive: cubit.isDownload,
                    onPressed: () async {
                      RenderRepaintBoundary boundary =
                      _globalKey.currentContext!.findRenderObject()
                      as RenderRepaintBoundary;
                      await cubit.downloadVoucherCourse(boundary, context);
                    },
                    title: AppText.btnDownloadImage.text.toUpperCase())
              ],
            ))
      ],
    );
  }
}
