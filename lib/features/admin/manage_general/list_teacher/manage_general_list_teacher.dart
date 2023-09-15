import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_teacher/alert_checkbox_teacher.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_teacher/alert_new_teacher.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/user_item.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';


class ManageGeneralListTeacher extends StatelessWidget {
  final ManageGeneralCubit cubit;

  const ManageGeneralListTeacher(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: cubit.listTeacher == null ? Transform.scale(
      scale: 0.75,
      child: const Center(
        child:
        CircularProgressIndicator(),
      ),
    ) : Column(
      children: [
        ...(cubit.listTeacher!).map((e) => UserItem(e.name, e.phone, e.url)).toList(),
        SizedBox(height: Resizable.padding(context, 5)),
        if(cubit.listTeacher!.isNotEmpty || cubit.canAdd == true)
          Material(
              color: Colors.transparent,
              child: DottedBorderButton(
                  AppText.btnAddTeacher.text.toUpperCase(),
                  isManageGeneral: true, onPressed: () async {
                selectionDialog(context, AppText.btnAddTeacher.text, AppText.btnAddNewTeacher.text, () {
                  Navigator.pop(context);
                  alertCheckBoxTeacher(context, cubit);
                }, () {
                  Navigator.pop(context);
                  alertNewTeacher(context, cubit);
                });
              })),
      ],
    ));
  }
}
