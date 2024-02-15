import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_student/info_student_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/list_student_class_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class StudentInfoScreen extends StatelessWidget {
  StudentInfoScreen({super.key}) : cubit = StudentInfoCubit();

  final StudentInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DetailAppBar(),
          Expanded(
              child: BlocBuilder(
            bloc: cubit..loadStudent(int.parse(TextUtils.getName())),
            builder: (c, s) {
              return cubit.student == null || cubit.user == null
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
                                flex: 3,
                                child: InfoStudentView(
                                    cubit: cubit)),
                            Expanded(
                                flex: 5,
                                child: ListStudentClassView(cubit: cubit))
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
