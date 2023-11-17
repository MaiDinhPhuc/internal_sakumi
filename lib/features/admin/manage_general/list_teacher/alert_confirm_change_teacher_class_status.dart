import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

class ConfirmChangeTeacherStatus extends StatelessWidget {
  const ConfirmChangeTeacherStatus(this.newStatus, this.teacherClassModel,
      this.teacher, this.cubit, this.popupCubit,
      {Key? key})
      : super(key: key);
  final String newStatus;
  final TeacherClassModel teacherClassModel;
  final TeacherModel teacher;
  final ManageGeneralCubit cubit;
  final MenuPopupCubit popupCubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmChangeStatus.text
            .replaceAll("@", teacher.name)
            .replaceAll("#","Xoá" )
            .replaceAll("%", "Đang dạy"),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      titlePadding:
      EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset(
        'assets/images/ic_edit.png',
        height: Resizable.size(context, 120),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            onPress: () {
              Navigator.pop(context);
            },
            bgColor: Colors.white,
            foreColor: Colors.black,
            text: AppText.txtBack.text),
        CustomButton(
            onPress: () async {
              FirebaseFirestore.instance
                  .collection('teacher_class')
                  .doc(
                  'teacher_${teacher.userId}_class_${teacherClassModel.classId}')
                  .update({'class_status': newStatus}).whenComplete(() {
                cubit.loadAfterRemoveTeacher(teacher);
                Navigator.pop(context);
              });
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}