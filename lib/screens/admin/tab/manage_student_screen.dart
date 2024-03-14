import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_student/alert_add_new_std_account.dart';

class ManageStudentScreen extends StatelessWidget {
  const ManageStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 9),
          Expanded(child: Center(child: AddButton(
            onTap: () {
              alertAddNewStdAccount(context);
            }, title: " + ${AppText.btnAddNewStudent.text}",
          )))
        ],
      ),
    );
  }
}
