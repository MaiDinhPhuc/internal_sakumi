import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

import 'detail_test_cubit_v2.dart';

class ExpandTestV2 extends StatelessWidget {
  const ExpandTestV2({super.key, required this.detailCubit});
  final DetailTestV2 detailCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...detailCubit.getStudent().map((e) => Padding(
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
                    detailCubit.checkSubmitted(e.userId), isSubmit: true),
                status: Container(),
                mark: Container(),
                dropdown: Container())))
      ],
    );
  }
}
