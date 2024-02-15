import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_layout.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_bill_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/class_item_shimmer.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shimmer/shimmer.dart';

import 'bill_item_std.dart';


class ManageStdBillView extends StatelessWidget {
  const ManageStdBillView({super.key, required this.cubit});
  final StudentInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    final shimmerList = List.generate(5, (index) => index);
    return BlocBuilder<ManageStdBillCubit, int>(
      bloc: cubit.billCubit,
      builder: (c, s) {
        return cubit.billCubit.loading ? Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Resizable.size(context, 10)),
                ...shimmerList.map((e) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.size(context, 0)),
                    child: const ItemShimmer()))
              ],
            ),
          ),
        ) : cubit.billCubit.listBill!.isEmpty
            ? Text(AppText.txtBillEmpty.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 17),
                color: greyColor.shade600))
            : Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Resizable.padding(
                        context, 10)),
                child: BillLayout(
                  widgetStdName: Text(
                      AppText.txtStdName.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetClassCode: Text(
                      AppText.txtClassCode.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetPaymentDate: Text(
                      AppText.txtPaymentDate.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetPayment: Text(
                      AppText.txtPayment.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetRenewDate: Text(
                      AppText.txtRenewDate.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetType: Text(
                      AppText.txtBillType.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  widgetStatus: Text(
                      AppText.titleStatus.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)), widgetDropdown: Container(),
                )),
            SingleChildScrollView(
              child: Column(
                children: [
                  ...cubit.billCubit.listBill!
                      .map((e) => BillItemStd(billModel: e, cubit: cubit.billCubit)).toList(),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
