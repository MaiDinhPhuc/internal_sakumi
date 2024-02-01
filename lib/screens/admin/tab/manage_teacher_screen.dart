import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';

class ManageTeacherScreen extends StatelessWidget {
  const ManageTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 7),
          Expanded(child: Center(child: Text(AppText.titleManageTeacher.text)))
        ],
      ),
    );
  }
}
