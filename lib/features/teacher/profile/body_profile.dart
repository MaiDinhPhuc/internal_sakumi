import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/info_form.dart';
import 'package:internal_sakumi/features/teacher/profile/info_pass.dart';
import 'package:internal_sakumi/features/teacher/profile/log_out_dialog.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile_cubit.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:intl/intl.dart';

import '../../../configs/color_configs.dart';
import '../../../utils/resizable.dart';

class BodyProfile extends StatelessWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherProfileCubit()..load(context),
      child: BlocBuilder<TeacherProfileCubit, int>(
        builder: (context, state) {
          if (state == 0) return const CircularProgressIndicator();

          final profileCubit = context.read<TeacherProfileCubit>();
          final listInfo = profileCubit.listInfoTextField!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: Resizable.size(context, 80),
                    backgroundColor: primaryColor.shade50,
                    child: ImageNetwork(
                        key: Key(profileCubit.profileTeacher!.url),
                        image: profileCubit.profileTeacher!.url.isEmpty
                            ? AppConfigs.defaultImage
                            : profileCubit.profileTeacher!.url,
                        height: Resizable.size(context, 160),
                        borderRadius: BorderRadius.circular(1000),
                        width: Resizable.size(context, 160),
                        duration: 0,
                        onLoading: Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )),
                  ),
                  CustomButton(
                      onPress: () async {
                        Uint8List? imgData =
                            await ImagePickerWeb.getImageAsBytes();
                        if (imgData != null) {
                          profileCubit.changeAvatar(context, imgData!);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InfoForm(),
                      const InfoPass(),
                      CustomButton(
                          onPress: () async {
                            showDialog(
                                context: context,
                                builder: (context) => const LogOutDialog());

                            // final list = await TeacherRepository.fromContext(context).getAllLessonResult();
                            // for(var item in list) {
                            //   final random = Random();
                            //   DateFormat s = DateFormat('dd/MM/yyyy');
                            //   final DateTime currentDate = s.parse(item.date!);
                            //   final randomHour = random.nextInt(24);
                            //   final randomMinute = random.nextInt(60);
                            //   final randomSecond = random.nextInt(60);
                            //
                            //   final randomTime = DateTime(
                            //     currentDate.year,
                            //     currentDate.month,
                            //     currentDate.day,
                            //     randomHour,
                            //     randomMinute,
                            //     randomSecond,
                            //   );
                            //   final date = DateFormat('dd/MM/yyyy HH:mm:ss').format(randomTime);
                            //
                            //   await TeacherRepository.fromContext(context).changeDate(item.lessonId, item.classId, date);
                            // }
                          },
                          bgColor: primaryColor.shade500,
                          foreColor: Colors.white,
                          text: AppText.txtLogout.text),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
