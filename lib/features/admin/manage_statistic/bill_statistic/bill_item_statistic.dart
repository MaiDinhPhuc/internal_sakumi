import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/bill_model.dart';

import 'detail_bill_statistic_cubit.dart';
import 'detail_statistic_bill_view.dart';

class BillItemStatistic extends StatelessWidget {
  const BillItemStatistic({super.key, required this.billModel, required this.detailCubit});
  final BillModel billModel;
  final DetailBillStatisticCubit detailCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: BlocBuilder<DropdownCubit, int>(
        builder: (c, state) => AnimatedCrossFade(
            firstChild: DetailBillStatisticView(
              onPressed: () {
                BlocProvider.of<DropdownCubit>(c).update();
              },
              billModel: billModel,
              cubit: detailCubit,
              isExpand: state % 2 == 1,
            ),
            secondChild: DetailBillStatisticView(
              onPressed: () {
                BlocProvider.of<DropdownCubit>(c).update();
              },
              billModel: billModel,
              cubit: detailCubit,
              isExpand: state % 2 == 1,
            ),
            crossFadeState: state % 2 == 1
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 100)),
      ),
    );
  }
}