import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_bills/bill_view.dart';
import 'package:internal_sakumi/features/admin/manage_bills/confirm_check_bill.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/bill_model.dart';

import 'manage_std_bill_cubit.dart';

class BillItemStd extends StatelessWidget {
  const BillItemStd({super.key, required this.billModel, required this.cubit});
  final BillModel billModel;
  final ManageStdBillCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: BlocBuilder<DropdownCubit, int>(
        builder: (c, state) => AnimatedCrossFade(
            firstChild: BillViewV2(
              onTap: () {},
              onPressed: () {
                BlocProvider.of<DropdownCubit>(c).update();
              },
              billModel: billModel,
              cubit: cubit,
              isExpand: state % 2 == 1,
              onCheck: () {},
            ),
            secondChild: BillViewV2(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) =>
                        BillDialogV2(isEdit: true, cubit: cubit, billModel: billModel));
              },
              onPressed: () {
                BlocProvider.of<DropdownCubit>(c).update();
              },
              billModel: billModel,
              cubit: cubit,
              isExpand: state % 2 == 1,
              onCheck: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ConfirmCheckBillV2(cubit: cubit, billModel: billModel));
              },
            ),
            crossFadeState: state % 2 == 1
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 100)),
      ),
    );
  }
}