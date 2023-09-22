import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
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
                TextFieldWidget(
                  AppText.textEmail.text,
                  Icons.mail,
                  false,
                  controller: controller[0],
                  cursorColor: Colors.red,
                  iconColor: primaryColor,
                ),
                TextFieldWidget(AppText.txtName.text, Icons.person, false,
                    controller: controller[1], iconColor: primaryColor),
                TextFieldWidget(AppText.txtPhone.text, Icons.phone, false,
                    controller: controller[2],
                    isNumber: true,
                    iconColor: primaryColor),
                TextFieldWidget(AppText.txtNote.text, Icons.edit, false,
                    controller: controller[3], iconColor: primaryColor),
                TextFieldWidget(AppText.titleUserId.text, Icons.key, false,
                    controller: controller[5], iconColor: primaryColor),
                TextFieldWidget(AppText.txtTeacherCode.text, Icons.code, false,
                    controller: controller[4], iconColor: primaryColor),
                SizedBox(
                  height: Resizable.size(context, 30),
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint(
                        "============>${controller[1].text}\n${controller[3].text}\n${controller[2].text}\n${controller[4].text}\n${controller[0].text}\n${controller[5].text}");
                    // AuthServices.signupUser(
                    //     controller[1].text,
                    //     controller[3].text,
                    //     controller[2].text,
                    //     controller[4].text,
                    //     false,
                    //     controller[0].text,
                    //     'teacher',
                    //     int.parse(controller[5].text),
                    //     context);
                  },
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
