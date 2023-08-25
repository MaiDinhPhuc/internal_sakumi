import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';
import 'input_custom.dart';

class InfoPass extends StatefulWidget {
  const InfoPass({Key? key}) : super(key: key);

  @override
  State<InfoPass> createState() => _InfoPassState();
}

class _InfoPassState extends State<InfoPass> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final profileCubit = context.watch<TeacherProfileCubit>();
    final listPass = profileCubit.listPassWordField!;
    return Form(
      key: _form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppText.txtPassLogin.text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Resizable.font(context, 20),
                    color: greyColor.shade600),
              ),
              profileCubit.isEditPassLogin
                  ? Container()
                  : IconButton(
                  onPressed: () {
                    profileCubit.editPass();
                    FocusScope.of(context)
                        .requestFocus(listPass[1]['focusNode']);
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
            padding: EdgeInsets.only(right:  Resizable.size(context, 100)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: InputCustom(
                          controller:
                          listPass[0]['controller'] as TextEditingController,
                          focusNode: listPass[0]['focusNode'] as FocusNode,
                          index: 0,
                          type: 'pass',
                          title: listPass[0]['title'],
                          item: listPass[0],
                          cubit: profileCubit,
                          isEdit: profileCubit.isEditPassLogin,
                          isFocus: listPass[0]['isFocus'],
                        )),
                    SizedBox(
                      width: Resizable.padding(context, 100),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                !profileCubit.isEditPassLogin ? Container() :  Row(
                  children: [
                    Expanded(
                        child: InputCustom(
                          controller:
                          listPass[1]['controller'] as TextEditingController,
                          focusNode: listPass[1]['focusNode'] as FocusNode,
                          index: 1,
                          type: 'pass',
                          title: listPass[1]['title'],
                          item: listPass[1],
                          cubit: profileCubit,
                          isEdit: profileCubit.isEditPassLogin,
                          isFocus: listPass[1]['isFocus'],
                        )),
                    SizedBox(
                      width: Resizable.padding(context, 100),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                !profileCubit.isEditPassLogin ? Container(): Row(
                  children: [
                    Expanded(
                        child: InputCustom(
                          controller:
                          listPass[2]['controller'] as TextEditingController,
                          focusNode: listPass[2]['focusNode'] as FocusNode,
                          index: 2,
                          type: 'pass',
                          title: listPass[2]['title'],
                          item: listPass[2],
                          cubit: profileCubit,
                          isEdit: profileCubit.isEditPassLogin,
                          isFocus: listPass[2]['isFocus'],
                        )),
                    SizedBox(
                      width: Resizable.padding(context, 100),
                    ),
                    Expanded(child: Container())
                  ],
                ),
              ],
            ),
          ),
          profileCubit.isEditPassLogin
              ? Row(
            children: [
              CustomButton(
                  onPress: () {
                    final isValid = _form.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    else{
                      _form.currentState!.save();
                      profileCubit.changePassWord(context);
                    }

                  },
                  bgColor: primaryColor.shade500,
                  foreColor:Colors.white,
                  text: AppText.txtChangePass.text),
              SizedBox(
                width: Resizable.size(context, 5),
              ),
              CustomButton(
                  onPress: () {
                    _form.currentState?.reset();
                    profileCubit.exit('pass');
                  },
                  bgColor: Colors.white,
                  foreColor: primaryColor.shade500,
                  text: AppText.txtExit.text),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}
