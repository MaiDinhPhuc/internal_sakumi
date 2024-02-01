import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/bill_model.dart';

import 'bill_view.dart';
import 'manage_bill_cubit.dart';

class BillItem extends StatelessWidget {
  const BillItem({super.key, required this.billModel, required this.cubit});
  final BillModel billModel;
  final ManageBillCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: BlocBuilder<DropdownCubit, int>(
        builder: (c, state) => AnimatedCrossFade(
            firstChild: CollapseBillView(
                onTap: () async {},
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(c).update();
                },
                billModel: billModel, cubit: cubit, isExpand: state % 2 == 1),
            secondChild: CollapseBillView(
                onTap: () async {},
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(c).update();
                },
                billModel: billModel, cubit: cubit,isExpand: state % 2 == 1),
            crossFadeState: state % 2 == 1
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 100)),
      ),
    );
  }
}
