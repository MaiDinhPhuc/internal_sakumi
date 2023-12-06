import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/voucher/alert_info_voucher.dart';
import 'package:internal_sakumi/features/admin/voucher/voucher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:searchfield/searchfield.dart';

class VoucherSearch extends StatelessWidget {
  final VoucherCubit cubit;
  const VoucherSearch(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchField(
        offset: Offset(0, Resizable.size(context, 40)),
        maxSuggestionsInViewPort: cubit.listSearch.length,
        itemHeight: Resizable.size(context, 52),
        onSearchTextChanged: (v) {
          cubit.searchVoucher(v.toUpperCase());
        },
        searchInputDecoration: InputDecoration(
          fillColor: const Color(0xffF4F6FD),
          filled: true,
          hintText: AppText.txtSearch.text,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Resizable.font(context, 20),
              color: const Color(0xFF461220).withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
          ),
          constraints: BoxConstraints(maxHeight: Resizable.size(context, 40)),
          labelStyle: TextStyle(
              fontSize: Resizable.font(context, 18),
              color: Colors.grey.shade900),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Resizable.size(context, 8)),
            borderSide: BorderSide(
                color: Colors.black, width: Resizable.size(context, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 1)),
            borderRadius: BorderRadius.circular(Resizable.size(context, 8)),
          ),
          suffixIcon: IconButton(
              tooltip: AppText.txtSearch.text,
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
              )),
        ),
        suggestionsDecoration: SuggestionDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Resizable.size(context, 8)),
            border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 1))),
        suggestions: cubit.listSearch
            .map((e) => SearchFieldListItem(e.voucherCode,
                child: InkWell(
                  onTap: () async {
                    waitingDialog(context);
                    await cubit.showInfoVoucher(e.voucherCode);
                    if (context.mounted) {
                      Navigator.pop(context);
                      alertInfoVoucher(context, cubit);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Resizable.padding(context, 12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.voucherCode,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 20)),
                            ),
                            SizedBox(height: Resizable.size(context, 3)),
                            Expanded(
                                child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    constraints: BoxConstraints(
                                        minWidth: Resizable.size(context, 140)),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: AppText.txtApplyFor.text
                                                .replaceAll('@', ''),
                                            style: TextStyle(
                                                color: const Color(0xff757575),
                                                fontWeight: FontWeight.w600,
                                                fontSize: Resizable.font(
                                                    context, 17))),
                                        TextSpan(
                                            text: e.type,
                                            style: TextStyle(
                                                color: const Color(0xffE33F64),
                                                fontWeight: FontWeight.w600,
                                                fontSize: Resizable.font(
                                                    context, 17)))
                                      ]),
                                    )),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          Resizable.padding(context, 10)),
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
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17))),
                                    TextSpan(
                                        text: e.expiredDate,
                                        style: TextStyle(
                                            color: const Color(0xffE33F64),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                Resizable.font(context, 17)))
                                  ]),
                                )
                              ],
                            ))
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                              minWidth: Resizable.size(context, 70),
                              maxHeight: Resizable.size(context, 20)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: e.usedDate.isEmpty
                                  ? const Color(0xff33691E)
                                  : const Color(0xffF57F17)),
                          child: Text(
                            e.usedDate.isEmpty
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
                  ),
                )))
            .toList());
  }
}
