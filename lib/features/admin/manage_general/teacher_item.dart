import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'collapse_teacher_item.dart';
import 'expand_teacher_item.dart';
import 'list_teacher/alert_confirm_change_teacher_class_status.dart';
import 'manage_general_cubit.dart';

class TeacherItem extends StatelessWidget {
  final TeacherModel teacher;
  const TeacherItem({Key? key, required this.cubit, required this.teacher}) : super(key: key);
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xffE0E0E0),
              width: Resizable.size(context, 1))),
      child:  BlocProvider(
          create: (context) => DropdownCubit(),
          child: BlocBuilder<DropdownCubit, int>(
              builder: (c, state) => AnimatedCrossFade(
                  firstChild: CollapseTeacherItem(
                    onPress: () {
                      BlocProvider.of<DropdownCubit>(c)
                          .update();
                    },
                    state: state, teacher: teacher
                  ),
                  secondChild: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      CollapseTeacherItem(
                          onPress: () {
                            BlocProvider.of<DropdownCubit>(c)
                                .update();
                          },
                          state: state, teacher: teacher
                      ),
                      ExpandTeacherItem(teacher: teacher, cubit: cubit)
                    ],
                  ),
                  crossFadeState: state % 2 == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration:
                  const Duration(milliseconds: 100))))
    );
  }
}



