import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_checkbox_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_new_student.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/student_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ManageGeneralListStudent extends StatelessWidget {
  final ManageGeneralCubit cubit;

  const ManageGeneralListStudent(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: cubit.listStudent == null ? Transform.scale(
      scale: 0.75,
      child: const Center(
        child:
        CircularProgressIndicator(),
      ),
    ) : Column(
      children: [
        ...(cubit.listStudent!).map((e) => StudentItem(student: e,cubit: cubit,)).toList(),
        SizedBox(height: Resizable.padding(context, 5)),
        if(cubit.listStudent!.isNotEmpty|| cubit.canAdd == true)
          Material(
              color: Colors.transparent,
              child: DottedBorderButton(
                  AppText.btnAddStudent.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () async {
                selectionDialog(context, AppText.btnAddStudent.text, AppText.btnAddNewStudent.text, () {
                  Navigator.pop(context);
                  alertCheckBoxStudent(context, cubit);
                }, () {
                  Navigator.pop(context);
                  alertNewStudent(context, cubit);
                });
              })),
      ],
    ));
  }
}
