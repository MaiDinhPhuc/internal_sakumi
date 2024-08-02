import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/drop_down_search.dart';
import 'package:internal_sakumi/features/admin/voucher/course_voucher/alert_info_voucher_course.dart';
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
        cubit.searchVoucherCourse(value.toUpperCase());
      },
    );
  }
}

