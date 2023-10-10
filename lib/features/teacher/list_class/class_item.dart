import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/chart_view.dart';
import 'package:internal_sakumi/features/teacher/list_class/class_overview.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/features/teacher/list_class/status_class_item.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
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
                  widget: ClassOverview(index),
                  onTap: () async {
                    await Navigator.pushNamed(context,
                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/role?role=teacher/overview/class?id=$classId");
                  },
                  onPressed: () {
                    BlocProvider.of<DropdownCubit>(c).update();
                  },
                  widgetStatus: StatusClassItem(index: index)),
              secondChild: CardItem(
                isExpand: true,
                widget: Column(
                  children: [ClassOverview(index), ChartView(index)],
                ),
                onTap: () async {
                  await Navigator.pushNamed(context,
                      "${Routes.teacher}?name=${TextUtils.getName().trim()}/role?role=teacher/overview/class?id=$classId");
                },
                onPressed: () => BlocProvider.of<DropdownCubit>(c).update(),
                widgetStatus: StatusClassItem(index: index),
              ),
              crossFadeState: state % 2 == 1
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100)),
        ));
  }
}

class ClassItemInAdmin extends StatelessWidget {
  final int index, classId;
  const ClassItemInAdmin(this.index, this.classId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DropdownCubit(),
        child: BlocBuilder<DropdownCubit, int>(
          builder: (c, state) => AnimatedCrossFade(
              firstChild: CardItem(
                widget: ClassOverviewInAdmin(index),
                onTap: () async {
                  await Navigator.pushNamed(context,
                      "${Routes.admin}?name=${TextUtils.getName().trim()}/role?role=admin/overview/class?id=$classId");
                },
                onPressed: () {
                  BlocProvider.of<DropdownCubit>(c).update();
                },
                widgetStatus: StatusClassItemAdmin(index: index),
              ),
              secondChild: CardItem(
                isExpand: true,
                widget: Column(
                  children: [
                    ClassOverviewInAdmin(index),
                    CharInAdminView(index)
                  ],
                ),
                onTap: () async {
                  await Navigator.pushNamed(context,
                      "${Routes.admin}?name=${TextUtils.getName().trim()}/role?role=admin/overview/class?id=$classId");
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
