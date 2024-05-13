import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_schedule/manage_schedule_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/back_button.dart';

import '../../../features/admin/manage_schedule/schedule_view.dart';

class ManageScheduleScreen extends StatelessWidget {
  ManageScheduleScreen({super.key}) : cubit = ManageScheduleCubit();

  final ManageScheduleCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 70)),
                child: Column(
                  children: [
                    SizedBox(height: Resizable.size(context, 20)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomBackTeacherScreenButton(),
                      ],
                    ),
                    SizedBox(height: Resizable.size(context, 10)),
                    Text(AppText.txtScheduleTeacher.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: Resizable.font(context, 30),
                            color: Colors.black)),
                    SizedBox(height: Resizable.size(context, 10)),
                    ScheduleView(cubit: cubit)
                  ],
                ))));
  }
}
