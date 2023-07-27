import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:internal_sakumi/features/teacher/chart_view.dart';
import 'package:internal_sakumi/features/teacher/class_overview.dart';
import 'package:internal_sakumi/features/teacher/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/card_item.dart';

class ClassItem extends StatelessWidget {
  final int index, classId;
  const ClassItem(this.index, this.classId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownCubit(),
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardItem(
                  widget: ClassOverView(index),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/overview/class?id=$classId");
                  },
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                    if (BlocProvider.of<TeacherCubit>(c).listPoint == null) {
                      BlocProvider.of<TeacherCubit>(c).loadStatisticClass(c);
                    }
                  }),
              secondChild: CardItem(
                  widget: Column(
                    children: [
                      ClassOverView(index),
                      (BlocProvider.of<TeacherCubit>(c).listStudentInClass ==
                              null)
                          ? const CircularProgressIndicator()
                          : ChartView(index)
                    ],
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=$classId");
                  },
                  onPressed: () => BlocProvider.of<DropdownCubit>(c).update()),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
