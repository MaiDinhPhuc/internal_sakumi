import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/alert_new_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/user_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ManageGeneralListStudent extends StatelessWidget {
  final ManageGeneralCubit cubit;

  const ManageGeneralListStudent(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...(cubit.listStudent!).map((e) => UserItem(e.name, e.phone)).toList(),
        SizedBox(height: Resizable.padding(context, 5)),
        Material(
            color: Colors.transparent,
            child: DottedBorderButton(
                AppText.titleAddStudent.text.toUpperCase(),
                isManageGeneral: true, onPressed: () async {
              selectionDialog(context, AppText.titleAddStudent.text, AppText.btnAddNewStudent.text, () {
                Navigator.pop(context);
                alertCheckBoxStudent(context, cubit);
              }, () {
                Navigator.pop(context);
                alertNewStudent(context, cubit);
              });
            })),
      ],
    );
  }
}
