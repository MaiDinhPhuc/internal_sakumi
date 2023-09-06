import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/lecture/list_lesson/lesson_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/test/test_already_view.dart';
import 'package:internal_sakumi/features/teacher/test/test_cubit.dart';
import 'package:internal_sakumi/features/teacher/test/test_not_already_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../utils/text_utils.dart';

class ClassTestTab extends StatelessWidget {
  const ClassTestTab(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestCubit()..init(context),
      child: Scaffold(
        body: Column(
          children: [
            HeaderTeacher(
              index: 2,
              classId: TextUtils.getName(position: 2),
              name: name,
            ),
            BlocBuilder<TestCubit, int>(builder: (cc, s) {
              var cubit = BlocProvider.of<TestCubit>(cc);
              return cubit.classModel == null
                  ? Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Resizable.padding(context, 20)),
                              child: Text(
                                  '${AppText.txtClassCode.text} ${cubit.classModel!.classCode}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 30))),
                            ),
                            cubit.listTest == null ||
                                    cubit.listTestResult == null
                                ? Transform.scale(
                                    scale: 0.75,
                                    child: const CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      if(cubit.listTest!.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 20)),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 150)),
                                          child: TestItemRowLayout(
                                            test: Text(AppText.txtTest.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            name: Text(
                                                AppText.titleSubject.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            submit: Text(
                                                AppText
                                                    .txtRateOfSubmitTest.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            mark: Text(
                                                AppText.txtAveragePoint.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            status: Text(
                                                AppText.titleStatus.text,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff757575),
                                                    fontSize: Resizable.font(
                                                        context, 17))),
                                            dropdown: Container(),
                                          )),
                                      if (cubit.listTest!.isEmpty)
                                        Center(
                                          child:
                                              Text(AppText.txtTestEmpty.text),
                                        ),
                                      if (cubit.listTest!.isNotEmpty)
                                        ...cubit.listTest!.map((e) => cubit
                                                .checkAlready(e.id)
                                            ? TestAlreadyView(
                                                e: e, cubit: cubit, name: name,)
                                            : TestNotAlreadyView(
                                                index:
                                                    cubit.listTest!.indexOf(e),
                                                title: e.title,
                                                onTap: () async {
                                                  cubit.assignmentTest(
                                                      context,
                                                      int.parse(
                                                          TextUtils.getName()),
                                                      e.courseId,
                                                      e.id);
                                                },
                                              ))
                                    ],
                                  )
                          ],
                        ),
                      ));
            })
          ],
        ),
      ),
    );
  }
}
