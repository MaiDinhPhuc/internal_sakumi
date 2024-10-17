import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_student/info_student_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_procedure_student_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_bill_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_class_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/manage_std_tab_view.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class StudentInfoScreen extends StatelessWidget {
  StudentInfoScreen({super.key}) : cubit = StudentInfoCubit();

  final StudentInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                flex: 4, child: InfoStudentView(cubit: cubit)),
                            Expanded(
                                flex: 9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ManageStdTabView(cubit: cubit),
                                    cubit.tab == AppText.titleManageClass.text
                                        ? ManageStdClassView(cubit: cubit)
                                        : cubit.tab ==
                                                AppText.txtProcedure.text
                                            ? const ManageProcedureStudentView(
                                                role: 'admin')
                                            : ManageStdBillView(cubit: cubit)
                                  ],
                                ))
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
