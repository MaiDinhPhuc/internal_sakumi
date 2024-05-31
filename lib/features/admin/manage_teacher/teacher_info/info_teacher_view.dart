import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/teacher_info_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import '../../../../widget/tag_info.dart';
import '../class_tab/list_info_teacher.dart';

class InfoTeacherView extends StatelessWidget {
  const InfoTeacherView({super.key, required this.cubit});
  final TeacherInfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Resizable.padding(context, 30),
      ),
      padding: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 15),
          horizontal: Resizable.padding(context, 5)),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: const Color(0xffE0E0E0),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cubit.teacher!.url == ''
              ? Image.asset("assets/images/ic_avt.png")
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(1000)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    cubit.teacher!.url,
                    height: Resizable.size(context, 100),
                    width: Resizable.size(context, 100),
                    errorBuilder: (_, __, ___) => Container(),
                  ),
                ),

          Padding(
            padding:  EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 10),
              horizontal: Resizable.padding(context, 20),
            ),
            child: TagInfo(type: 1, ownId: cubit.teacher!.userId),
          ),
          Padding(
              padding: EdgeInsets.all(Resizable.padding(context, 5)),
              child: TeacherInfo(cubit: cubit)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SubmitButton(
                onPressed: () async {
                  waitingDialog(context);
                  var teacherModel = TeacherModel(
                      name: cubit.name,
                      url: cubit.teacher!.url,
                      note: cubit.note,
                      userId: cubit.teacher!.userId,
                      phone: cubit.phone,
                      status: cubit.teacherStatus,
                      teacherCode: cubit.teacherCode,
                      schedule: cubit.teacher!.schedule, email: cubit.teacher!.email);
                  Update.updateTeacherProfile(teacherModel);
                  // await FireBaseProvider.instance
                  //     .updateProfileTeacher(TextUtils.getName(), teacherModel);
                  DataProvider.updateTeacherInfo(
                      cubit.teacher!.userId, teacherModel);
                  Navigator.pop(context);
                  notificationDialog(
                      context, AppText.txtUpdateTeacherDone.text);
                },
                title: AppText.txtUpdate.text,
              )
            ],
          )
        ],
      ),
    );
  }
}
