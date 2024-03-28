import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/info_teacher_view.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/class_tab/list_teacher_class_view.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/list_tab_profile_teacher.dart';
import 'package:internal_sakumi/features/teacher/profile/manage_teacher_tab_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/overview_tab/overview_in_profile.dart';
import 'package:internal_sakumi/features/teacher/profile/report_tab/list_report_in_profile_view.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class TeacherInfoScreen extends StatelessWidget {
  TeacherInfoScreen({super.key})
      : cubit = TeacherInfoCubit(),
        tabCubit = ManageTeacherTabCubit();

  final TeacherInfoCubit cubit;
  final ManageTeacherTabCubit tabCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DetailAppBar(),
          Expanded(
              child: BlocBuilder(
            bloc: cubit..loadTeacher(int.parse(TextUtils.getName())),
            builder: (c, s) {
              return cubit.teacher == null || cubit.user == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 20),
                          horizontal: Resizable.padding(context, 30)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                  child: InfoTeacherView(cubit: cubit))),
                          Expanded(
                              flex: 2,
                              child: BlocBuilder<ManageTeacherTabCubit, int>(
                                bloc: tabCubit,
                                builder: (c, s) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTabProfileTeacher(cubit: tabCubit, role: 'admin'),
                                      Expanded(
                                          child: tabCubit.tabType == 'class'
                                              ? ListTeacherClassView(
                                                  cubit: cubit)
                                              : tabCubit.tabType == 'schedule'
                                                  ? ScheduleTabView(role: 'admin')
                                                  : tabCubit.tabType ==
                                                          'overview'
                                                      ? OverViewTabInProfile(role: 'admin')
                                                      : ListReportInProfileView(role: 'admin', cubit: tabCubit.reportCubit))
                                    ],
                                  );
                                },
                              ))
                        ],
                      ),
                    );
            },
          ))
        ],
      ),
    );
  }
}
