import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/class_info/test/test_already_v2.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/features/class_info/test/test_not_already_v2.dart';
import 'package:internal_sakumi/model/test_model.dart';

import 'detail_test_cubit_v2.dart';

class TestItemV2 extends StatelessWidget {
  TestItemV2(
      {super.key, required this.cubit, required this.test, required this.role})
      : detailCubit = DetailTestV2(cubit, test);
  final TestCubitV2 cubit;
  final DetailTestV2 detailCubit;
  final TestModel test;
  final String role;

  @override
  Widget build(BuildContext context) {
    return detailCubit.checkAlready(test.id)
        ? TestAlreadyV2(
            detailCubit: detailCubit,
            role: role,
            index: cubit.listTest!.indexOf(test))
        : TestNotAlreadyV2(
            detailCubit: detailCubit,
            role: role,
            index: cubit.listTest!.indexOf(test));
  }
}
