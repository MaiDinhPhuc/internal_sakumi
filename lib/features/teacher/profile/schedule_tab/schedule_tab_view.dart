import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_tab_cubit.dart';
import 'package:internal_sakumi/features/teacher/profile/schedule_tab/schedule_with_date_view.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'collapse_register_schedule.dart';
import 'expand_register_schedule.dart';

class ScheduleTabView extends StatelessWidget {
  ScheduleTabView({super.key, required this.role})
      : cubit = ScheduleTabCubit(role),
        dropDownCubit = DropdownCubit();

  final ScheduleTabCubit cubit;
  final String role;
  final DropdownCubit dropDownCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleTabCubit, int>(
        bloc: cubit,
        builder: (c, s) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Resizable.size(context, 1),
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10)),
                  color: greyColor.shade300,
                ),
                BlocBuilder<DropdownCubit, int>(
                    bloc: dropDownCubit,
                    builder: (cc, state) => AnimatedCrossFade(
                        firstChild: CollapseRegisterSchedule(
                            dropDownCubit: dropDownCubit,
                            cubit: cubit,
                            role: role),
                        secondChild: Column(
                            children: [
                              CollapseRegisterSchedule(
                                  dropDownCubit: dropDownCubit,
                                  cubit: cubit,
                                  role: role),
                              ExpandRegisterSchedule(cubit: cubit)
                            ]
                        ),
                        crossFadeState: state % 2 == 1
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 100))),
                Container(
                  height: Resizable.size(context, 1),
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 10)),
                  color: greyColor.shade300,
                ),
                ScheduleWithDateView(cubit: cubit)
              ],
            ),
          );
        });
  }
}
