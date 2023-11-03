import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/chart_view_admin.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_overview.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/status_class_item.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/widget/card_item.dart';

class ClassItemInAdmin extends StatelessWidget {
  final int index, classId;
  const ClassItemInAdmin(this.index, this.classId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<LoadListClassCubit>(context);
    return BlocProvider(
        create: (context) => DropdownCubit(),
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardItem(
                widget: ClassOverviewInAdmin(index),
                onTap: () async {
                  await Navigator.pushNamed(
                      context, "${Routes.admin}/overview/class=$classId");
                },
                onPressed: () {
                  if (cubit.listLastLessonTitleNow[index] == null) {
                    cubit.loadLastLessonTitle(
                        classId, cubit.listCourseIds![index], index);
                  }
                  BlocProvider.of<DropdownCubit>(c).update();
                },
                widgetStatus: StatusClassItemAdmin(index: index),
              ),
              secondChild: CardItem(
                isExpand: true,
                widget: Column(
                  children: [
                    ClassOverviewInAdmin(index),
                    ChartInAdminView(index)
                  ],
                ),
                onTap: () async {
                  await Navigator.pushNamed(
                      context, "${Routes.admin}/overview/class=$classId");
                },
                onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                widgetStatus: StatusClassItemAdmin(index: index),
              ),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}
