import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_student/info_field.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/teacher_info_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherInfo extends StatelessWidget {
  const TeacherInfo({super.key, required this.cubit});
  final TeacherInfoCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppText.txtName.text,
            style: TextStyle(
                color: greyColor.shade500,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 16))),
        InfoField(
            value: cubit.name,
            onChange: (value) {
              cubit.changeName(value!);
            }),
        Text(AppText.txtTeacherCode.text,
            style: TextStyle(
                color: greyColor.shade500,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 16))),
        InfoField(
            value: cubit.teacherCode,
            onChange: (value) {
              cubit.changeTeacherCode(value!);
            },
            enable: true),
        Text(AppText.txtPhone.text,
            style: TextStyle(
                color: greyColor.shade500,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 16))),
        InfoField(
            value: cubit.phone,
            onChange: (value) {
              cubit.changePhone(value!);
            }),
        Text(AppText.textEmail.text,
            style: TextStyle(
                color: greyColor.shade500,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 16))),
        InfoField(
            value: cubit.user!.email,
            onChange: (value) {},
            enable: false),
        Text(AppText.txtNote.text,
            style: TextStyle(
                color: greyColor.shade500,
                fontWeight: FontWeight.w600,
                fontSize:
                Resizable.font(context, 16))),
        InfoField(
            value: cubit.note,
            onChange: (value) {
              cubit.changeNote(value!);
            },
            enable: true),
      ],
    );
  }
}
