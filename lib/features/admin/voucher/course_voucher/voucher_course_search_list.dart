
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/app_voucher/alert_info_voucher_app.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'alert_info_voucher_course.dart';

class VoucherCourseSearchList extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherCourseSearchList(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Resizable.size(context, 61 * 5),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Resizable.size(context, 8)),
          border: Border.all(
              color: Colors.black, width: Resizable.size(context, 1)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, Resizable.size(context, 2)))
          ]),
      child: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: Resizable.padding(context, 20)),
          child: cubit.tab == AppText.txtCourse.text ? Column(
            children: [
              ...cubit.listSearchVoucherCourse.map((model) => SizedBox(
                height: Resizable.size(context, 61),
                child: InkWell(
                  onTap: () async {
                    waitingDialog(context);
                    await cubit.showInfoVoucherCourse(model.voucherCode);
                    if (context.mounted) {
                      Navigator.pop(context);
                      alertInfoVoucherCourse(context, cubit);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Resizable.padding(context, 15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.voucherCode,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                          Resizable.font(context, 20)),
                                    ),
                                    SizedBox(
                                        height: Resizable.padding(context, 5)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            constraints: BoxConstraints(
                                                minWidth: Resizable.size(
                                                    context, 140)),
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: AppText
                                                        .txtApplyFor.text
                                                        .replaceAll('@', ''),
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xff757575),
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize:
                                                        Resizable.font(
                                                            context, 17))),
                                                TextSpan(
                                                    text: model.type,
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffE33F64),
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize:
                                                        Resizable.font(
                                                            context, 17)))
                                              ]),
                                            )),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 10)),
                                          color: greyColor.shade300,
                                          width: Resizable.size(context, 1),
                                          height: Resizable.size(context, 10),
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                '${AppText.titleExpiredDate.text}:',
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xff757575),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            TextSpan(
                                                text: model.expiredDate,
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xffE33F64),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(
                                                        context, 17)))
                                          ]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                      minWidth: Resizable.size(context, 70),
                                      maxHeight: Resizable.size(context, 20)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: model.usedDate.isEmpty
                                          ? cubit.isExpired(model.expiredDate)
                                          ? const Color(0xffb71c1c)
                                          : const Color(0xff33691E)
                                          : const Color(0xffF57F17)),
                                  child: Text(
                                    model.usedDate.isEmpty
                                        ? cubit.isExpired(model.expiredDate)
                                        ? AppText.txtExpired.text
                                        : AppText.txtNew.text
                                        : AppText.txtUsed.text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 15)),
                                  ),
                                )
                              ],
                            ),
                          )),
                      if (cubit.listSearchVoucherCourse.indexOf(model) !=
                          cubit.listSearchVoucherCourse.length - 1)
                        Container(
                          height: Resizable.size(context, 1),
                          color: greyColor.shade300,
                        )
                    ],
                  ),
                ),
              )),
            ],
          ) : Column(
            children: [
              ...cubit.listSearchVoucherApp.map((model) => SizedBox(
                height: Resizable.size(context, 61),
                child: InkWell(
                  onTap: () async {
                    waitingDialog(context);
                    await cubit.showInfoVoucherApp(model.voucherCode);
                    if (context.mounted) {
                      Navigator.pop(context);
                      alertInfoVoucherApp(context, cubit);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Resizable.padding(context, 15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.voucherCode,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                          Resizable.font(context, 20)),
                                    ),
                                    SizedBox(
                                        height: Resizable.padding(context, 5)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                '${AppText.titleExpiredDate.text}:',
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xff757575),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            TextSpan(
                                                text: cubit.parseDate(model.expiredDate),
                                                style: TextStyle(
                                                    color:
                                                    const Color(0xffE33F64),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Resizable.font(
                                                        context, 17)))
                                          ]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                      minWidth: Resizable.size(context, 70),
                                      maxHeight: Resizable.size(context, 20)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: model.usedData.isEmpty
                                          ? cubit.isExpired(cubit.parseDate(model.expiredDate))
                                          ? const Color(0xffb71c1c)
                                          : const Color(0xff33691E)
                                          : const Color(0xffF57F17)),
                                  child: Text(
                                    model.usedData.isEmpty
                                        ? cubit.isExpired(cubit.parseDate(model.expiredDate))
                                        ? AppText.txtExpired.text
                                        : AppText.txtNew.text
                                        : AppText.txtUsed.text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Resizable.font(context, 15)),
                                  ),
                                )
                              ],
                            ),
                          )),
                      if (cubit.listSearchVoucherApp.indexOf(model) !=
                          cubit.listSearchVoucherApp.length - 1)
                        Container(
                          height: Resizable.size(context, 1),
                          color: greyColor.shade300,
                        )
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}