import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

class AddTeacherScreen extends StatelessWidget {
  final List<TextEditingController> controller;
  AddTeacherScreen({Key? key})
      : controller =
            List.generate(7, (index) => TextEditingController()).toList(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.btnAddTeacher.text),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 20)),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReusableTextField(
                  AppText.textEmail.text,
                  Icons.mail,
                  false,
                  controller: controller[0],
                  cursorColor: Colors.red,
                  iconColor: primaryColor,
                ),
                ReusableTextField(AppText.txtName.text, Icons.person, false,
                    controller: controller[1], iconColor: primaryColor),
                ReusableTextField(AppText.txtPhone.text, Icons.phone, false,
                    controller: controller[2],
                    isNumber: true,
                    iconColor: primaryColor),
                ReusableTextField(AppText.txtNote.text, Icons.edit, false,
                    controller: controller[3], iconColor: primaryColor),
                ReusableTextField(AppText.titleUserId.text, Icons.key, false,
                    controller: controller[5], iconColor: primaryColor),
                ReusableTextField(
                    AppText.txtTeacherCode.text, Icons.code, false,
                    controller: controller[4], iconColor: primaryColor),
                SizedBox(
                  height: Resizable.size(context, 30),
                ),
                ElevatedButton(
                  onPressed: () => AuthServices.signupUser(
                      controller[1].text,
                      controller[3].text,
                      controller[2].text,
                      controller[4].text,
                      false,
                      'teacher',
                      controller[0].text,
                      int.parse(controller[5].text),
                      context),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 30)))),
                  child: Text(AppText.btnSignUp.text),
                ),
              ]),
        ),
      ),
    );
  }
}
