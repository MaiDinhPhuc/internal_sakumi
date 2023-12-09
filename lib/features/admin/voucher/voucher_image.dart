import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/social_info_view.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_info_view.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/model/voucher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';

class VoucherImage extends StatelessWidget {
  final VoucherCubit cubit;
  final _globalKey = GlobalKey();
  VoucherImage(this.cubit, {Key? key}) : super(key: key);

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
                padding: EdgeInsets.all(Resizable.padding(context, 15)),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 12,
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: Container(
                            color: Colors.white,
                            // width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(flex: 1, child: SocialInfoView()),
                                Expanded(
                                    flex: 7, child: VoucherInfoView(cubit)),
                                Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: [
                                        Container(
                                            color: primaryColor,
                                            alignment: Alignment.center),
                                        Container(
                                          color: Colors.white,
                                          height: Resizable.size(context, 2),
                                          margin: EdgeInsets.only(
                                              top: Resizable.padding(
                                                  context, 3)),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
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
                      await cubit.createNewVoucher(
                          context,
                          VoucherModel(
                            id: cubit.numVoucher,
                            recipientCode: cubit.conUser.text,
                            usedUserCode: '',
                            voucherCode: cubit.qrCode,
                            createDate: cubit.createDate,
                            usedDate: '',
                            expiredDate:
                                DateFormat('dd/MM/yyyy').format(DateTime(
                              cubit.expiredDate.year,
                              cubit.expiredDate.month +
                                  (cubit.isVoucher ? 3 : 0),
                              cubit.expiredDate.day,
                            )),
                            noted: cubit.conNote.text,
                            price: cubit.priceVoucher,
                            type: cubit.courseVoucher,
                            isFullCourse: cubit.isFullCourse,
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
                      await cubit.downloadVoucher(boundary, context);
                    },
                    title: AppText.btnDownloadImage.text.toUpperCase())
              ],
            ))
      ],
    );
  }
}
