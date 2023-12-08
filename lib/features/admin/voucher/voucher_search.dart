import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/drop_down_search.dart';
import 'package:internal_sakumi/features/admin/voucher/alert_info_voucher.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/features/admin/search/search_field.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class VoucherSearch extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherSearch(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchField(
      AppText.txtSearch.text,
      suffixIcon: IconButton(
          tooltip: AppText.txtSearch.text,
          onPressed: () {},
          icon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          )),
      widget: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Resizable.size(context, 135)),
        child: DropDownSearch(
            items: [
              AppText.txtRecipientCode.text,
              AppText.titleVoucherCode.text,
            ],
            onChanged: (value) {
              cubit.selectSearchType(value.toString());
            },
            value: cubit.searchType),
      ),
      onChanged: (value) {
        cubit.searchVoucher(value.toUpperCase());
      },
    );
  }
}

class VoucherSearchList extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherSearchList(this.cubit, {Key? key}) : super(key: key);

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
          child: Column(
            children: [
              ...cubit.listSearch.map((model) => SizedBox(
                    height: Resizable.size(context, 61),
                    child: InkWell(
                      onTap: () async {
                        waitingDialog(context);
                        await cubit.showInfoVoucher(model.voucherCode);
                        if (context.mounted) {
                          Navigator.pop(context);
                          alertInfoVoucher(context, cubit);
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
                                          color: const Color(0xffD9D9D9),
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
                                          ? const Color(0xff33691E)
                                          : const Color(0xffF57F17)),
                                  child: Text(
                                    model.usedDate.isEmpty
                                        ? AppText.txtNew.text
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
                          if (cubit.listSearch.indexOf(model) !=
                              cubit.listSearch.length - 1)
                            Container(
                              height: Resizable.size(context, 1),
                              color: const Color(0xffD9D9D9),
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
