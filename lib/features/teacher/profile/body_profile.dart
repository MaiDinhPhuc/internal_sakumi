import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/info_form.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import '../../../configs/color_configs.dart';
import '../../../utils/resizable.dart';
import '../lecture/teacher_cubit.dart';

class BodyProfile extends StatelessWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TeacherProfileCubit()..load(context),
      child: BlocBuilder<TeacherProfileCubit, int>(
        builder: (context, state) {
          if (state == 0) return const CircularProgressIndicator();

          final profileCubit = context.read<TeacherProfileCubit>();
          final listInfo = profileCubit.listInfoTextField!;
          return Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  CircleAvatar(
                    radius: Resizable.size(context, 80),
                    backgroundColor: greyColor.shade300,
                    backgroundImage: profileCubit.fromPicker!.image,
                  ),
                  SizedBox(height: Resizable.size(context, 20)),
                  CustomButton(
                      onPress: () async {
                        Image? img = await ImagePickerWeb.getImageAsWidget();
                        if(img != null) {
                          profileCubit.changeAvatar(img);
                        }
                      },
                      bgColor: Colors.white,
                      foreColor: Colors.black,
                      text: AppText.txtChangeImage.text)
                ],
              )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const InfoForm(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              IconButton(
                                  onPressed: () {},
                                  iconSize: Resizable.size(context, 20),
                                  icon:
                                      Image.asset('assets/images/ic_edit.png'))
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            endIndent: Resizable.size(context, 100),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
