import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_group_tag_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../manage_general/dotted_border_button.dart';
import 'custom_button_v1.dart';
import 'group_item.dart';

class GroupTagView extends StatelessWidget {
  const GroupTagView({super.key, required this.manageTagCubit});

  final ManageTagCubit manageTagCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            AppText.txtGroup.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w600,
                color: darkPrimaryColor),
          ),
        ),
        if (manageTagCubit.listGroupTags.isNotEmpty)
          Flexible(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Resizable.padding(context, 10)),
                ...manageTagCubit.listGroupTags.map((e) {
                  final index = manageTagCubit.listGroupTags.indexOf(e);
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                    child: GroupItem(
                      isFocus: index == manageTagCubit.currentIndex,
                      title: e.name,
                      onEdit: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AddGroupTagDialog(
                                  manageTagCubit: manageTagCubit,
                                  groupTagModel: e,
                              );
                            });

                      },
                      onDelete: () {
                        Dialogs.alertDelete(
                            context, AppText.txtConfirmDeleteGroupTag.text,
                            () async {
                          bool value =
                              await manageTagCubit.deleteGroupTag(index);
                          if (context.mounted) {
                            if (value) {
                              Fluttertoast.showToast(
                                  msg: AppText.txtDeleteSuccess.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg: AppText.txtError.text);
                            }
                            Navigator.pop(context);
                          }
                        });
                      },
                      onClick: () {
                        manageTagCubit.setCurrentIndex(index);
                      },
                    ),
                  );
                })
              ],
            ),
          )),
        SizedBox(height: Resizable.padding(context, 10)),
        DottedBorderButton('+ ${AppText.btnAddGroup.text.toUpperCase()}',
            isManageGeneral: true, onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddGroupTagDialog(manageTagCubit: manageTagCubit);
              });
        }),
      ],
    );
  }
}
