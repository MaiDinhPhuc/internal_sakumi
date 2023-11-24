import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

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
                submit: TrackingItem(
                    cubit.checkSubmitted(e.userId, testId), isSubmit: true),
                status: Container(),
                mark: Container(),
                dropdown: Container())))
      ],
    );
  }
}
