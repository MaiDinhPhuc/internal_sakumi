import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import 'class_cubit_v2.dart';

class ConfirmChangeClassStatusV2 extends StatelessWidget {
  const ConfirmChangeClassStatusV2(
      this.newStatus, this.classModel, this.popupCubit,
      {Key? key, required this.classCubit})
      : super(key: key);
  final String newStatus;
  final ClassModel classModel;
  final MenuPopupCubit popupCubit;
  final ClassCubit classCubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmChangeStatus.text
            .replaceAll("@", classModel.classCode)
            .replaceAll("#", vietnameseSubText(newStatus))
            .replaceAll("%", vietnameseSubText(classModel.classStatus)),
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
                  .collection('class')
                  .doc(
                      'class_${classModel.classId}_course_${classModel.courseId}')
                  .update({'class_status': newStatus}).whenComplete(() {
                classCubit.updateClass(ClassModel(
                    classId: classModel.classId,
                    courseId: classModel.courseId,
                    description: classModel.description,
                    endTime: classModel.endTime,
                    startTime: classModel.startTime,
                    note: classModel.note,
                    classCode: classModel.classCode,
                    classStatus: newStatus,
                    classType: classModel.classType,
                    link: classModel.link));
                popupCubit.update();
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
