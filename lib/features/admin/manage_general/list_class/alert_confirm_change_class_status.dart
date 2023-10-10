import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_class/list_class_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ConfirmChangeClassStatus extends StatelessWidget {
  const ConfirmChangeClassStatus(this.newStatus, this.oldStatus, this.classCode,
      this.classId, this.courseId, this.popupCubit, this.cubit, this.index,
      {Key? key})
      : super(key: key);
  final String newStatus, oldStatus;
  final int classId, courseId, index;
  final String classCode;
  final MenuPopupCubit popupCubit;
  final LoadListClassCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmChangeStatus.text
            .replaceAll("@", classCode)
            .replaceAll("#", vietnameseSubText(newStatus))
            .replaceAll("%", vietnameseSubText(oldStatus)),
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
                  .doc('class_${classId}_course_$courseId')
                  .update({'class_status': newStatus}).whenComplete(() {
                cubit.listClassStatus![index] = newStatus;
                popupCubit.update();
                Navigator.pop(context);
                waitingDialog(context);
                cubit.updateData();
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
