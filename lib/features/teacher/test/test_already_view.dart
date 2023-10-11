import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'collapse_test_item.dart';
import 'expand_test_item.dart';

class TestAlreadyView extends StatelessWidget {
  const TestAlreadyView({super.key, required this.e, required this.cubit, required this.role});
  final TestModel e;
  final TestCubit cubit;
  final String role;

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
                    child: cubit.listTest == null || cubit.listTest!.isEmpty
                        ? Transform.scale(
                            scale: 0.75,
                            child: const CircularProgressIndicator(),
                          )
                        : AnimatedCrossFade(
                            firstChild: CollapseTestItem(
                              index: cubit.listTest!.indexOf(e),
                              title: e.title,
                              testId: e.id,
                            ),
                            secondChild: Column(
                              children: [
                                CollapseTestItem(
                                  index: cubit.listTest!.indexOf(e),
                                  title: e.title,
                                  testId: e.id,
                                ),
                                ExpandTestItem(testId: e.id,)
                              ],
                            ),
                            crossFadeState: state % 2 == 1
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 100))),
                if(role == "teacher")
                  Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context,
                            "${Routes.teacher}/grading/class=${TextUtils.getName()}/type=test/parent=${e.id}");
                      },
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 5))),
                )),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 15),
                  ),
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
