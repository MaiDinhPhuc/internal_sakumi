import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/class_info/over_view/student_item_overview_cubit.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'class_overview_cubit_v2.dart';
import 'collapse_overview_student_v2.dart';
import 'expanded_overview_student_v2.dart';

class StudentItemOverView extends StatelessWidget {
  StudentItemOverView(
      {super.key,
      required this.cubit,
      required this.stdClass,
      required this.role})
      : studentCubit = StudentItemOverViewCubit(cubit, stdClass);
  final StudentItemOverViewCubit studentCubit;
  final ClassOverViewCubitV2 cubit;
  final StudentClassModel stdClass;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentItemOverViewCubit, int>(
        bloc: studentCubit,
        builder: (c, s) {
          return Container(
            margin:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            child: BlocProvider(
                create: (context) => DropdownCubit(),
                child: BlocBuilder<DropdownCubit, int>(
                    builder: (c, state) => Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: Resizable.size(context, 1),
                                color: state % 2 == 0
                                    ? greyColor.shade100
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(
                                Resizable.size(context, 5))),
                        child: AnimatedCrossFade(
                            firstChild: CollapseOverviewStudentV2(
                                cubit: cubit,
                                role: role,
                                stdClass: stdClass,
                                studentCubit: studentCubit),
                            secondChild: Column(
                              children: [
                                CollapseOverviewStudentV2(
                                    cubit: cubit,
                                    role: role,
                                    stdClass: stdClass,
                                    studentCubit: studentCubit),
                                ExpandedOverViewStudentV2(
                                    stdClass: stdClass,
                                    cubit: cubit,
                                    studentCubit: studentCubit)
                              ],
                            ),
                            crossFadeState: state % 2 == 1
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 100))))),
          );
        });
  }
}
