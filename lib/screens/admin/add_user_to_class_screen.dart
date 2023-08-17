import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';
import 'package:intl/intl.dart';

class AddUserToClassScreen extends StatelessWidget {
  //final bool isStudent;
  final String classId;
  final TextEditingController controller;
  AddUserToClassScreen(this.classId,
      { //required this.isStudent, required this.classId,
      Key? key})
      : controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(isStudent
      //       ? AppText.btnAddStudent.text
      //       : AppText.btnAddTeacher.text),
      // ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 20)),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldWidget(AppText.titleUserId.text, Icons.key, false,
                    controller: controller, iconColor: primaryColor),
                SizedBox(
                  height: Resizable.size(context, 30),
                ),
                ElevatedButton(
                  onPressed: () async {
                    AdminRepository adminRepository =
                        AdminRepository.fromContext(context);
                    // List<TeacherClassModel> listTeacherClass =
                    //     await adminRepository.getAllTeacherInClass();
                    List<StudentClassModel> listStudentClass =
                        await adminRepository.getAllStudentInClass();
                    await FirebaseFirestore.instance
                        .collection('student_class')
                        .doc("student_${controller.text}_class_$classId")
                        .set({
                      'class_id': classId,
                      'user_id': int.parse(controller.text),
                      'active_status': 5,
                      'learning_status': 5,
                      'class_status': AppText.statusInProgress.text,
                      'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      'move_to': 0,
                      'id': listStudentClass.length + 1,
                    });
                    // isStudent
                    //     ? await FirebaseFirestore.instance
                    //         .collection('student_class')
                    //         .doc("student_${controller.text}_class_$classId")
                    //         .set({
                    //         'class_id': classId,
                    //         'user_id': int.parse(controller.text),
                    //         'active_status': 5,
                    //         'learning_status': 5,
                    //         'class_status': 'InProgress',
                    //         'date':
                    //             DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    //         'move_to': 0,
                    //         'id': listStudentClass.length + 1,
                    //       })
                    //     : await FirebaseFirestore.instance
                    //         .collection('teacher_class')
                    //         .doc("teacher_${controller.text}_class_$classId")
                    //         .set({
                    //         'class_id': classId,
                    //         'user_id': int.parse(controller.text),
                    //         'class_status': 'InProgress',
                    //         'date':
                    //             DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    //         'id': listTeacherClass.length + 1,
                    //       });
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 30)))),
                  child: Text(//isStudent
                      // ?
                      AppText.btnAddNewStudent.text
                      //:
                      //AppText.btnAddTeacher.text
                      ),
                ),
              ]),
        ),
      ),
    );
  }
}
