import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/body_profile.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../features/teacher/app_bar/class_appbar.dart';
import '../../utils/text_utils.dart';

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderTeacher(
              index: -1,
              classId: "empty",
              role: "teacher",
            ),
            SizedBox(
              height: Resizable.size(context, 20),
            ),
            Text(AppText.txtTeacherProfile.text.toUpperCase() , style:
              TextStyle(
                fontSize: Resizable.font(context, 30),
                fontWeight: FontWeight.bold
              ),),
            SizedBox(
              height: Resizable.size(context, 20),
            ),
            const BodyProfile()
          ],
        ),
      ),
    );
  }
}
