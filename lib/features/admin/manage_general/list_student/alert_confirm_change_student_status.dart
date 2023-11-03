import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/features/teacher/overview/class_overview_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class ConfirmChangeStudentStatus extends StatelessWidget {
  const ConfirmChangeStudentStatus(this.newStatus, this.studentClassModel,
      this.student, this.cubit, this.popupCubit,
      {Key? key})
      : super(key: key);
  final String newStatus;
  final StudentClassModel studentClassModel;
  final StudentModel student;
  final ManageGeneralCubit cubit;
  final MenuPopupCubit popupCubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmChangeStatus.text
            .replaceAll("@", student.name)
            .replaceAll("#", vietnameseSubText(newStatus))
            .replaceAll("%", vietnameseSubText(studentClassModel.status)),
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
                  .collection('student_class')
                  .doc(
                      'student_${student.userId}_class_${studentClassModel.classId}')
                  .update({'class_status': newStatus}).whenComplete(() {
                if (newStatus == "Remove") {
                  cubit.loadAfterRemoveStudent(student);
                } else {
                  cubit.getStudentClass(student.userId).status = newStatus;
                  popupCubit.update();
                }
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

class ConfirmChangeStudentStatusOverView extends StatelessWidget {
  const ConfirmChangeStudentStatusOverView(this.newStatus,
      this.studentClassModel, this.student, this.cubit, this.popupCubit,
      {Key? key, required this.dataCubit})
      : super(key: key);
  final String newStatus;
  final StudentClassModel studentClassModel;
  final StudentModel student;
  final ClassOverviewCubit cubit;
  final MenuPopupCubit popupCubit;
  final DataCubit dataCubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppText.txtConfirmChangeStatus.text
            .replaceAll("@", student.name)
            .replaceAll("#", vietnameseSubText(newStatus))
            .replaceAll("%", vietnameseSubText(studentClassModel.status)),
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
                  .collection('student_class')
                  .doc(
                      'student_${student.userId}_class_${studentClassModel.classId}')
                  .update({'class_status': newStatus}).whenComplete(() {
                if (newStatus == "Remove") {
                  Navigator.pop(context);
                  waitingDialog(context);
                  cubit.loadAfterRemove();
                } else {
                  studentClassModel.status = newStatus;
                  dataCubit.updateStudentClass(
                      studentClassModel.classId,
                      StudentClassModel(
                          id: studentClassModel.id,
                          classId: studentClassModel.classId,
                          activeStatus: studentClassModel.activeStatus,
                          learningStatus: studentClassModel.learningStatus,
                          moveTo: studentClassModel.moveTo,
                          userId: studentClassModel.userId,
                          classStatus: newStatus,
                          date: studentClassModel.date));
                  popupCubit.update();
                }
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
