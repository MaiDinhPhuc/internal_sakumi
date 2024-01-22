import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_test_v2.dart';
import 'detail_test_cubit_v2.dart';
import 'expand_test_v2.dart';

class TestAlreadyV2 extends StatelessWidget {
  const TestAlreadyV2(
      {super.key, required this.detailCubit, required this.role, required this.index});
  final DetailTestV2 detailCubit;
  final String role;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 150),
          vertical: Resizable.padding(context, 5)),
      child: BlocProvider(
          create: (context) => DropdownCubit(),
          child: BlocBuilder<DropdownCubit, int>(
            builder: (c, state) => Stack(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 15),
                        vertical: Resizable.padding(context, 8)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: Resizable.size(context, 1),
                            color: state % 2 == 0
                                ? greyColor.shade100
                                : Colors.black),
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                    child: AnimatedCrossFade(
                        firstChild: CollapseTestV2(
                          detailCubit: detailCubit, index: index,
                        ),
                        secondChild: Column(
                          children: [
                            CollapseTestV2(
                              detailCubit: detailCubit, index: index,
                            ),
                            ExpandTestV2(detailCubit: detailCubit)
                          ],
                        ),
                        crossFadeState: state % 2 == 1
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 100))),
                if (role == "teacher")
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context,
                              "${Routes.teacher}/grading/class=${detailCubit.cubit.classId}/type=test/parent=${detailCubit.testModel.id}");
                        },
                        borderRadius:
                            BorderRadius.circular(Resizable.size(context, 5))),
                  )),
                Container(
                  padding: EdgeInsets.only(
                      right: Resizable.padding(context, 15),
                      top: Resizable.padding(context, 10)),
                  child: TestItemRowLayout(
                      test: Container(),
                      name: Container(),
                      submit: Container(),
                      status: Container(),
                      mark: Container(),
                      dropdown: IconButton(
                          onPressed: () {
                            BlocProvider.of<DropdownCubit>(c).update();
                          },
                          splashRadius: Resizable.size(context, 15),
                          icon: Icon(
                            state % 2 == 0
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                          ))),
                )
              ],
            ),
          )),
    );
  }
}
