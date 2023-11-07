import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../lecture/list_lesson/lesson_item_row_layout.dart';

class ExpandTestItem extends StatelessWidget {
  const ExpandTestItem({super.key, required this.testId, required this.cubit});
  final int testId;
  final TestCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...cubit.listStudents!.map((e) => Padding(
            padding: EdgeInsets.symmetric(vertical: Resizable.size(context, 5)),
            child: TestItemRowLayout(
                test: Container(),
                name: Text(
                  e.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.size(context, 10)),
                ),
                submit: cubit.checkSubmitted(e.userId, testId) == -2
                    ? Text(
                        AppText.txtNotSubmit.text,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 15),
                            fontWeight: FontWeight.w800,
                            color: redColor),
                      )
                    : cubit.checkSubmitted(e.userId, testId) == -1
                        ? Text(AppText.txtNotGrading.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 15),
                                fontWeight: FontWeight.w800,
                                color: redColor))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 4),
                                horizontal: Resizable.padding(context, 10)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10000),
                                color: cubit.checkSubmitted(e.userId, testId) >=
                                        8
                                    ? greenColor
                                    : cubit.checkSubmitted(e.userId, testId) >=
                                            5
                                        ? orangeColor.shade900
                                        : redColor),
                            child: Text(
                              cubit.checkSubmitted(e.userId, testId).toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Resizable.font(context, 22),
                                  fontWeight: FontWeight.w800),
                            )),
                status: Container(),
                mark: Container(),
                dropdown: Container())))
      ],
    );
  }
}
