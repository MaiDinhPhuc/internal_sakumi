import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'class_overview_cubit_v2.dart';

class ConfirmChangeStudentClassStatusV2 extends StatelessWidget {
  const ConfirmChangeStudentClassStatusV2(
      this.newStatus, this.studentClassModel, this.student, this.popupCubit,
      {Key? key, required this.cubit})
      : super(key: key);
  final String newStatus;
  final StudentClassModel studentClassModel;
  final StudentModel student;
  final MenuPopupCubit popupCubit;
  final ClassOverViewCubitV2 cubit;

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
                  .update({'class_status': newStatus, "last_time_change": DateTime.now().millisecondsSinceEpoch}).whenComplete(() async {
                if (newStatus == "Remove") {
                  List<StudentClassModel> list = [];

                  for (var i in cubit.listStdClass!) {
                    if (i.userId != student.userId) {
                      list.add(i);
                    }
                  }

                  DataProvider.updateStdClass(
                      studentClassModel.classId, list);
                  Navigator.pop(context);
                  waitingDialog(context);
                } else {
                  List<StudentClassModel> list = [];

                  for (var i in cubit.listStdClass!) {
                    if (i.userId != student.userId) {
                      list.add(i);
                    } else {
                      list.add(StudentClassModel(
                          id: studentClassModel.id,
                          classId: studentClassModel.classId,
                          activeStatus: studentClassModel.activeStatus,
                          learningStatus: studentClassModel.learningStatus,
                          moveTo: studentClassModel.moveTo,
                          userId: studentClassModel.userId,
                          classStatus: newStatus,
                          date: studentClassModel.date, timeChange: studentClassModel.timeChange));
                    }
                  }
                  DataProvider.updateStdClass(
                      studentClassModel.classId, list);
                  cubit.update();
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
