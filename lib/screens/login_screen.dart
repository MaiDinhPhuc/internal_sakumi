import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

class LogInScreen extends StatelessWidget {
  final TextEditingController passwordTextController, emailTextController;
  LogInScreen({Key? key})
      : passwordTextController = TextEditingController(),
        emailTextController = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [secondaryColor, primaryColor, secondaryColor.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ReusableTextField(
                    AppText.textEmail.text, Icons.person_outline, false,
                    controller: emailTextController),
                const SizedBox(
                  height: 20,
                ),
                ReusableTextField(
                    AppText.textPassword.text, Icons.lock_outline, true,
                    controller: passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      AuthServices.logInUser(emailTextController.text,
                          passwordTextController.text, context);
                    },
                    child: Text(AppText.btnLogin.text))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
