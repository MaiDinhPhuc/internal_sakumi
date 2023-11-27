import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/test/test_already_view.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/features/teacher/test/test_not_already_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class ListTest extends StatelessWidget {
  const ListTest({super.key, required this.cubit, required this.role});
  final TestCubit cubit;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (cubit.listTest!.isNotEmpty)
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20)),
              margin: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 150)),
              child: TestItemRowLayout(
                test: Text(AppText.txtTest.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                name: Text(AppText.titleSubject.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                submit: Text(AppText.txtRateOfSubmitTest.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                mark: Text(AppText.txtAveragePoint.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                status: Text(AppText.titleStatus.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff757575),
                        fontSize: Resizable.font(context, 17))),
                dropdown: Container(),
              )),
        if (cubit.listTest!.isEmpty)
          Center(
            child: Text(AppText.txtTestEmpty.text),
          ),
        if (cubit.listTest!.isNotEmpty)
          ...cubit.listTest!.map((e) => cubit.checkAlready(e.id)
              ? TestAlreadyView(
                  e: e,
                  cubit: cubit,
                  role: role,
                )
              : TestNotAlreadyView(
                  index: cubit.listTest!.indexOf(e),
                  title: e.title,
                  onTap: () async {
                    cubit.assignmentTest(context,
                        int.parse(TextUtils.getName()), e.courseId, e.id);
                  },
                  role: role,
                ))
      ],
    );
  }
}
