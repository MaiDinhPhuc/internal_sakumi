import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_item.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_layout.dart';
import 'package:internal_sakumi/features/admin/manage_bills/filter_manage_bill.dart';
import 'package:internal_sakumi/features/admin/manage_bills/manage_bill_cubit.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ManageBillScreen extends StatelessWidget {
  ManageBillScreen({super.key}) : cubit = ManageBillCubit();
  final ManageBillCubit cubit;

  @override
  Widget build(BuildContext context) {
    var filterController = BlocProvider.of<BillFilterCubit>(context);
    if (filterController.filter.keys.isNotEmpty) {
      cubit.loadData(filterController);
    }
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 8),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
                top: Resizable.padding(context, 20),
                bottom: Resizable.padding(context, 40),
                left: Resizable.padding(context, 100),
                right: Resizable.padding(context, 100)),
            child: BlocBuilder<ManageBillCubit, int>(
              bloc: cubit,
              builder: (c, s) {
                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppText.titleManageBill.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 30))),
                                AddBillButton(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => BillDialog(isEdit: false, cubit: cubit));
                                  },
                                )
                              ],
                            ))),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 30),
                              vertical: Resizable.padding(context, 15)),
                          decoration: BoxDecoration(
                              color: lightGreyColor,
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 5))),
                          child: FilterManageBill(
                              cubit: cubit, filterController: filterController),
                        )),
                    Expanded(
                        flex: 5,
                        child: cubit.listBill == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : cubit.listBill!.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: Resizable.padding(context, 50)),
                                    child: Text(AppText.txtNotBill.text))
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
                                            ...cubit.listBill!
                                                .map((e) => BillItem(billModel: e, cubit: cubit)).toList()
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                  ],
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
