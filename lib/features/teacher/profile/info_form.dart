import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import 'input_custom.dart';

class InfoForm extends StatefulWidget {
  const InfoForm({Key? key}) : super(key: key);

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<TeacherProfileCubit>();
    final listInfo = profileCubit.listInfoTextField!;
    return Form(
      key: _form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppText.txtBaseInfo.text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Resizable.font(context, 20),
                    color: greyColor.shade600),
              ),
              profileCubit.isEditBaseInfo
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        profileCubit.editInfo();
                        FocusScope.of(context)
                            .requestFocus(listInfo[0]['focusNode']);
                      },
                      iconSize: Resizable.size(context, 20),
                      icon: Image.asset('assets/images/ic_edit.png'))
            ],
          ),
          Divider(
            thickness: 2,
            endIndent: Resizable.size(context, 100),
          ),
          Padding(
            padding: EdgeInsets.only(right: Resizable.padding(context, 100)),
            child: Row(
              children: [
                Expanded(
                    child: InputCustom(
                  controller:
                      listInfo[0]['controller'] as TextEditingController,
                  focusNode: listInfo[0]['focusNode'] as FocusNode,
                  index: 0,
                  type: 'info',
                  title: listInfo[0]['title'],
                  item: listInfo[0],
                  cubit: profileCubit,
                  isEdit: profileCubit.isEditBaseInfo,
                  isFocus: listInfo[0]['isFocus'],
                )),
                SizedBox(
                  width: Resizable.padding(context, 100),
                ),
                Expanded(
                    child: InputCustom(
                  controller:
                      listInfo[1]['controller'] as TextEditingController,
                  focusNode: listInfo[1]['focusNode'] as FocusNode,
                  index: 1,
                  type: 'info',
                  title: listInfo[1]['title'],
                  item: listInfo[1],
                  cubit: profileCubit,
                  isEdit: profileCubit.isEditBaseInfo,
                  isFocus: listInfo[1]['isFocus'],
                )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Resizable.padding(context, 100)),
            child: Row(
              children: [
                Expanded(
                    child: InputCustom(
                  controller:
                      listInfo[2]['controller'] as TextEditingController,
                  focusNode: listInfo[2]['focusNode'] as FocusNode,
                  index: 2,
                  type: 'info',
                  title: listInfo[2]['title'],
                  item: listInfo[2],
                  cubit: profileCubit,
                  isEdit: profileCubit.isEditBaseInfo,
                  isFocus: listInfo[2]['isFocus'],
                )),
                SizedBox(
                  width: Resizable.padding(context, 100),
                ),
                Expanded(
                    child: InputCustom(
                  controller:
                      listInfo[3]['controller'] as TextEditingController,
                  focusNode: listInfo[3]['focusNode'] as FocusNode,
                  index: 3,
                  type: 'info',
                  title: listInfo[3]['title'],
                  item: listInfo[3],
                  cubit: profileCubit,
                  isEdit: profileCubit.isEditBaseInfo,
                  isFocus: listInfo[3]['isFocus'],
                )),
              ],
            ),
          ),
          profileCubit.isEditBaseInfo
              ? Padding(
                  padding: EdgeInsets.only(top: Resizable.padding(context, 20)),
                  child: Row(
                    children: [
                      IgnorePointer(
                        ignoring: !profileCubit.isUpdate,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: Resizable.padding(context, 20)),
                          height: Resizable.size(context, 25),
                          width: Resizable.size(context, 100),
                          child: CustomButton(
                              onPress: () {
                                final isValid = _form.currentState!.validate();
                                if (!isValid) {
                                  return;
                                } else {
                                  _form.currentState!.save();
                                  profileCubit.updateProfile(context);
                                }
                              },
                              bgColor: profileCubit.isUpdate
                                  ? primaryColor.shade500
                                  : greyColor.shade50,
                              foreColor: profileCubit.isUpdate
                                  ? Colors.white
                                  : primaryColor.shade500,
                              text: 'Cập nhật'),
                        ),
                      ),
                      SizedBox(
                        width: Resizable.size(context, 5),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: Resizable.padding(context, 20)),
                        height: Resizable.size(context, 25),
                        width: Resizable.size(context, 100),
                        child: CustomButton(
                            onPress: () {
                              _form.currentState?.reset();
                              profileCubit.exit('info');
                            },
                            bgColor: Colors.white,
                            foreColor: primaryColor.shade500,
                            text: 'Thoát'),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
