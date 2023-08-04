import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/login/login_field.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:internal_sakumi/utils/resizable.dart';
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(
                child: Container(
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...List.generate(2, (index) => Container()).toList(),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Container()),
                      Expanded(
                          flex: 3, child: SizedBox(width: double.maxFinite*3/7,
                        height: MediaQuery.of(context).size.height/2.5,
                        child: Image.asset('assets/images/img_logo.png'),
                      )),
                      Expanded(flex: 2, child: Container())
                    ],
                  ),
                  Container(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                          top: Resizable.size(context, 3),
                          left: Resizable.size(context, 8),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaY: Resizable.size(context, 2),
                                sigmaX: Resizable.size(context, 2)),
                            child: Text(
                                AppText.titleSakumiCenter.text.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.25),
                                    fontWeight: FontWeight.w800,
                                    fontSize: Resizable.font(context, 45))),
                          )),
                      Text(AppText.titleSakumiCenter.text.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 45),
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = Resizable.size(context, 2)
                                ..color = Colors.white)),
                      Text(AppText.titleSakumiCenter.text.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 45))),
                    ],
                  ),
                  Container(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                          top: Resizable.size(context, 1),
                          left: Resizable.size(context, 4),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaY: Resizable.size(context, 1),
                                sigmaX: Resizable.size(context, 1)),
                            child: Text(AppText.titleSlogan.text.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: Resizable.font(context, 24))
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.25))),
                          )),
                      Text(AppText.titleSlogan.text.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.font(context, 24))),
                    ],
                  ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [ImageFiltered(imageFilter: ImageFilter.blur(sigmaY: 4), child: Text(AppText.titleSlogan.text.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(
                  //       color: Colors.black.withOpacity(0.25),
                  //       fontWeight: FontWeight.w800, fontSize: Resizable.font(context, 24)))),
                  //     Text(AppText.titleSlogan.text.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w800, fontSize: Resizable.font(context, 24)))
                  //   ],
                  // ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     Text(AppText.titleSlogan.text.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(
                  //         foreground: Paint()
                  //           ..style = PaintingStyle.fill
                  //           ..color = Colors.black.withOpacity(0.5)
                  //           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                  //         fontWeight: FontWeight.w800, fontSize: Resizable.font(context, 24))),
                  //     Text(AppText.titleSlogan.text.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w800, fontSize: Resizable.font(context, 24)))
                  //   ],
                  // ),
                  ...List.generate(10, (index) => Container()).toList()
                ],
              ),
            )),
            Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...List.generate(8, (index) => Container()),
                            Text(AppText.btnLogin.text, textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 40),
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor)),
                            Container(),
                            Text(AppText.txtMessageLogin.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Resizable.font(context, 16))),
                            ...List.generate(2, (index) => Container()),
                            Container(
                              height: Resizable.size(context, 1),
                              color: primaryColor.withOpacity(0.45),
                              margin: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 70)),
                            ),
                            ...List.generate(2, (index) => Container()),
                            LoginField(
                              AppText.txtHintAccount.text,
                              txt: emailTextController,
                            ),
                            Container(),
                            PasswordField(txt: passwordTextController),
                            ...List.generate(4, (index) => Container()),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Resizable.padding(context, 1000)),
                                        )),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)))
                                ),
                                onPressed: () {
                                  AuthServices.logInUser(emailTextController.text,
                                      passwordTextController.text, context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(AppText.btnLogin.text, style: TextStyle(
                                      color: Colors.white, fontSize: Resizable.font(context, 20), fontWeight: FontWeight.w800
                                  ))],
                                )),
                            ...List.generate(20, (index) => Container())
                          ],
                        )),
                    Expanded(flex: 1, child: Container())
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
