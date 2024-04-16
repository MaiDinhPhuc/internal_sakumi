import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_color_dialog.dart';
import 'package:internal_sakumi/features/admin/manage_tag/add_tag_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';
import 'package:internal_sakumi/model/tag_model.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../model/group_tag_model.dart';
import '../../../utils/enum.dart';
import '../../../utils/resizable.dart';
import '../manage_general/input_form/input_field.dart';
import 'add_group_tag_cubit.dart';
import 'custom_button_v1.dart';

class AddGroupTagDialog extends StatefulWidget {
  const AddGroupTagDialog({super.key, required this.manageTagCubit});

  final ManageTagCubit manageTagCubit;

  @override
  State<AddGroupTagDialog> createState() => _AddGroupTagDialogState();
}

class _AddGroupTagDialogState extends State<AddGroupTagDialog> {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GroupTagModel? groupTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddGroupTagCubit(),
      child: BlocConsumer<AddGroupTagCubit, int>(
        listener: (context, state) {
          final addTagCubit = context.read<AddGroupTagCubit>();
          if (addTagCubit.status == SubmitStatus.success) {
            widget.manageTagCubit
                .updateGroupTag(groupTag!);
            Fluttertoast.showToast(msg: AppText.txtAddGroupTagSuccess.text);
          } else if (addTagCubit.status == SubmitStatus.error) {
            Fluttertoast.showToast(msg: AppText.txtError.text);
          }
        },
        builder: (context, state) {
          return BlocBuilder<AddGroupTagCubit, int>(
            builder: (context, state) {
              final addGroupTagCubit = context.read<AddGroupTagCubit>();
              return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Resizable.size(context, 16))),
                  child: Container(
                      padding: EdgeInsets.all(Resizable.padding(context, 20)),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 10)),
                              child: Text(
                                AppText.btnAddGroupTag.text.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: InputItem(
                                      title: AppText.txtNameGroup.text,
                                      controller: nameCon,
                                      errorText:
                                      AppText.txtPleaseInputGroupTagName.text),
                                ),
                                SizedBox(
                                  width: Resizable.padding(context, 10),
                                ),
                                Flexible(
                                  child: InputItem(
                                    title: AppText.txtCode.text,
                                    controller: codeCon,
                                    onValidate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppText
                                            .txtPleaseInputGroupTagCode.text;
                                      }
                                      if (widget.manageTagCubit
                                          .checkCodeGroupTagExist(value)) {
                                        return AppText.txtCodeExist.text;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            InputItem(
                              title: AppText.txtDescription.text,
                              controller: desCon,
                              onValidate: (value) {
                                return null;
                              },
                              isExpand: true,
                            ),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButtonV1(
                                      onPressed: () {
                                        if (addGroupTagCubit.status !=
                                            SubmitStatus.none) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                      },
                                      border: Colors.black,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      title: AppText.btnCancel.text),
                                  SizedBox(
                                    width: Resizable.padding(context, 5),
                                  ),
                                  CustomButtonV1(
                                      onPressed: () async {
                                        if (addGroupTagCubit.status !=
                                            SubmitStatus.none) {
                                          return;
                                        }
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          groupTag = GroupTagModel(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              name: nameCon.text,
                                              description: desCon.text,
                                              code: codeCon.text, tags: []);

                                          await addGroupTagCubit.addGroupTag(
                                              groupTag!);

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      textColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      title: AppText.btnAddNew.text),
                                ],
                              ),
                            ),
                            if (addGroupTagCubit.status == SubmitStatus.loading)
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppText.txtLoadingAdd.text),
                                    SizedBox(
                                      width: Resizable.padding(context, 10),
                                    ),
                                    SizedBox(
                                        height: Resizable.padding(context, 20),
                                        width: Resizable.padding(context, 20),
                                        child: const CircularProgressIndicator(
                                          color: primaryColor,
                                        )),
                                  ],
                                ),
                              )
                          ],
                        ),
                      )));
            },
          );
        },
      ),
    );
  }
}
