import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_group_tag_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
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
                    SizedBox(
                        height: Resizable.padding(context, 10)),
                    ...manageTagCubit.listGroupTags.map((e) {
                      final index =
                      manageTagCubit.listGroupTags.indexOf(e);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            Resizable.padding(context, 5)),
                        child: GroupItem(
                          isFocus: index ==
                              manageTagCubit.currentIndex,
                          title: e.name,
                          onDelete: () {

                            alertDeleteGroupTag(context, () async {
                              bool value = await manageTagCubit.deleteGroupTag(index);
                              if(context.mounted) {
                                if(value) {
                                  Fluttertoast.showToast(msg: AppText.txtDeleteSuccess.text);
                                }
                                else {
                                  Fluttertoast.showToast(msg: AppText.txtError.text);
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
        DottedBorderButton(
            '+ ${AppText.btnAddGroup.text.toUpperCase()}',
            isManageGeneral: true,
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AddGroupTagDialog(manageTagCubit: manageTagCubit);
              });
            }),
      ],
    );
  }

  void alertDeleteGroupTag(BuildContext context, Function() onSubmit) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.all(Resizable.padding(context, 20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_forever, color: primaryColor, size: Resizable.size(context, 100),)
,                    Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 20)),child: Text(
                      AppText.txtConfirmDeleteGroupTag.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButtonV1(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            border: Colors.black,
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            title: AppText.btnCancel.text),
                        SizedBox(
                          width: Resizable.padding(context, 15),
                        ),
                        CustomButtonV1(
                            onPressed: onSubmit,
                            textColor: Colors.white,
                            backgroundColor: primaryColor,
                            title: AppText.txtYes.text),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
