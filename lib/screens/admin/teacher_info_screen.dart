import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/info_teacher_view.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_class_view.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class TeacherInfoScreen extends StatelessWidget {
  TeacherInfoScreen({super.key}): cubit = TeacherInfoCubit();

  final TeacherInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    return Scaffold(
      body: Column(
        children: [
          const DetailAppBar(),
          Expanded(
              child: BlocBuilder(
                bloc: cubit..loadStudent(int.parse(TextUtils.getName()), dataController.searchCubit),
                builder: (c, s) {
                  return cubit.teacher == null || cubit.user == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 20),
                          horizontal: Resizable.padding(context, 30)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex:1,
                              child: InfoTeacherView(cubit: cubit, searchCubit: dataController.searchCubit)),
                          Expanded(
                              flex:2,
                              child: ListTeacherClassView(cubit: cubit))
                        ],
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}