import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_dashboard_tab.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_class_tab.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_student_tab.dart';
import 'package:internal_sakumi/screens/admin/tab/manage_tag_tab.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<TeacherDataCubit>(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: CustomAppbar(buttonList: [
            AppText.titleManageStudent.text,
            AppText.titleManageClass.text,
            AppText.titleStatistics.text,
            AppText.titleManageTag.text
          ], widgets: [
            const ManageStudentTab(),
            const ManageClassTab(),
            const ManageDashboardTab(),
            ManageTagTab(),
          ]),
        ));
  }
}
