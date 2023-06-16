import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/routes.dart';

class DetailStudentScreen extends StatelessWidget {
  final StudentModel studentModel;

  DetailStudentScreen({required this.studentModel, Key? key}) : super(key: key);

  var list = [AppText.btnRemove.text, AppText.btnEdit.text];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${studentModel.name}  ${studentModel.studentCode}"),
        actions: [
          PopupMenuButton(onSelected: (value) async {
            if (value == 0) {
              var nav = Navigator.popUntil(
                  context, ModalRoute.withName(Routes.admin));
              // var nav = Navigator.of(context, rootNavigator: true)
              //     .pushReplacementNamed(Routes.admin);
              await FirebaseFirestore.instance
                  .collection('class')
                  .doc("student_user_${studentModel.userId}")
                  .update({'status': 'remove'});
              await Future.delayed(const Duration(milliseconds: 1000));
              nav;
            }
            if (value == 1 && context.mounted) {
              Navigator.pushNamed(context, Routes.addStudent,
                  arguments: {'studentModel': studentModel});
            }
          }, itemBuilder: (BuildContext c) {
            return list
                .map((e) =>
                    PopupMenuItem(value: list.indexOf(e), child: Text(e)))
                .toList();
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //ReusableTextField(text, icon, isPasswordType, controller: controller)
          ],
        ),
      ),
    );
  }
}
