import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

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
              var classModel = await FireBaseProvider.instance.getClassById(studentClassModel.classId);
              Create.addNewLog(StudentClassLogModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  classId: studentClassModel.classId,
                  courseId: classModel.courseId,
                  from: studentClassModel.status,
                  to: newStatus,
                  userId: studentClassModel.userId,
                  classType: classModel.classType));
              Update.updateStudentClassStatus(student.userId, studentClassModel.classId, newStatus);
              if (newStatus == "Remove") {
                cubit.loadAfterRemoveStudent(student);
              } else {
                cubit.getStudentClass(student.userId).status = newStatus;
                popupCubit.update();
              }
              if(context.mounted){
                Navigator.pop(context);
              }
            },
            bgColor: primaryColor.shade500,
            foreColor: Colors.white,
            text: AppText.txtAgree.text),
      ],
    );
  }
}

