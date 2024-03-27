import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/list_report_in_profile_view.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_view.dart';

import 'class_tab/list_class_in_profile_view.dart';
import 'list_tab_profile_teacher.dart';
import 'manage_teacher_tab_cubit.dart';
import 'overview_tab/overview_in_profile.dart';

class ListTabView extends StatelessWidget {
  const ListTabView({super.key, required this.cubit});
  final ManageTeacherTabCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTabProfileTeacher(cubit: cubit,role: 'teacher'),
        Expanded(
            child: cubit.tabType == 'class'
                ? ListClassInProfileView()
                : cubit.tabType == 'schedule'
                    ? ScheduleTabView(role: 'teacher')
                    : cubit.tabType == 'overview'
                        ? OverViewTabInProfile(role: 'teacher')
                        : ListReportInProfileView(role: 'teacher', cubit: cubit.reportCubit))
      ],
    );
  }
}
