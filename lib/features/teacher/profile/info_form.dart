import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/resizable.dart';

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
          GridView.builder(
              padding: EdgeInsets.only(right: Resizable.padding(context, 100)),
              itemCount: listInfo.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (Resizable.width(context) * 2 / 3 - Resizable.size(context, 150)) / (2 * Resizable.size(context, 100) ) ,
                  crossAxisSpacing: Resizable.padding(context, 100),
              ),
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: (context, constraint) {
                    final focusNode = listInfo[index]['focusNode'] as FocusNode;
                    final controller = listInfo[index]['controller'] as TextEditingController;
                    focusNode.addListener(() {
                      if (focusNode
                          .hasFocus) {
                        profileCubit.setFocus(true, index);
                      } else {
                        profileCubit.setFocus(false, index);
                      }
                    });
                    controller.addListener(() {
                      profileCubit.checkText(controller.text, index);
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listInfo[index]['title'],
                          style: TextStyle(
                              fontSize: Resizable.font(context, 20),
                              fontWeight: FontWeight.bold,
                              color: greyColor.shade600),
                        ),
                        SizedBox(
                          height: Resizable.size(context, 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            boxShadow: (profileCubit.isEditBaseInfo &&
                                    listInfo[index]['isFocus'])
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0,
                                          4), // changes the position of the shadow
                                    ),
                                  ]
                                : null,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              fillColor: profileCubit.isEditBaseInfo
                                  ? Colors.white
                                  : greyColor.shade50,
                              filled: true,
                              enabled: !(profileCubit.isEditBaseInfo &&
                                  !listInfo[index]['isEdit']),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 5),
                                  vertical: Resizable.padding(context, 5)),
                            ),
                            style: TextStyle(
                                fontSize: Resizable.font(context, 18),
                                fontWeight: FontWeight.bold),
                            readOnly: !profileCubit.isEditBaseInfo,
                            focusNode: focusNode,
                            controller: controller,
                            validator: (value) {
                              if (value == null ||
                                  controller.text.isEmpty ||
                                  controller.text == null) {
                                return 'Dữ liệu không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: Resizable.size(context, 5),
                        ),
                      ],
                    );
                  },
                );
              }),
          profileCubit.isEditBaseInfo
              ? Row(
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
                              }
                              else{
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
                            profileCubit.exit();
                          },
                          bgColor: Colors.white,
                          foreColor: primaryColor.shade500,
                          text: 'Thoát'),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
