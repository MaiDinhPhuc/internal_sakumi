import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/app_bar/class_appbar.dart';
import 'package:internal_sakumi/features/teacher/profile/list_tab_view.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile/body_profile.dart';
import 'package:internal_sakumi/features/teacher/profile/manage_teacher_tab_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherProfile extends StatelessWidget {
  TeacherProfile({Key? key})
      : cubit = ManageTeacherTabCubit(),
        super(key: key);
  final ManageTeacherTabCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const HeaderTeacher(
          index: -1,
          classId: "empty",
          role: "teacher",
        ),
        Expanded(
            child:
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Resizable.padding(context, 20),
                    horizontal: Resizable.padding(context, 30)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: BodyProfile()),
                      Expanded(
                          flex: 9,
                          child: BlocBuilder<ManageTeacherTabCubit, int>(
                            bloc: cubit,
                            builder: (c, s) {
                              return ListTabView(cubit: cubit) ;
                            },
                          ))

                    ])))
      ],
    ));
  }
}
