import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'manage_std_bill_view.dart';
import 'manage_std_class_view.dart';
import 'manage_std_tab_view.dart';

class ListStudentClassView extends StatelessWidget {
  const ListStudentClassView({super.key, required this.cubit});
  final StudentInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ManageStdTabView( cubit: cubit,),
        cubit.firstTab
            ? ManageStdClassView(cubit: cubit)
            : ManageStdBillView(cubit: cubit)
      ],
    );
  }
}
