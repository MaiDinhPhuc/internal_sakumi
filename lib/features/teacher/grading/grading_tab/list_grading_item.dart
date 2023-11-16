import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/grading/grading_tab/test_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'btvn_item.dart';
import 'grading_cubit.dart';

class ListGradingItem extends StatelessWidget {
  const ListGradingItem({super.key, required this.cubit});
  final GradingCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Resizable.padding(context, 10)),
        if (cubit.isBTVN)
          ...cubit.filterListLesson().map((e) => BTVNItem(e, cubit: cubit)),
        if (!cubit.isBTVN)
          ...cubit.filterListTest().map((e) => TestGradingItem(e, cubit: cubit)),
      ],
    );
  }
}
