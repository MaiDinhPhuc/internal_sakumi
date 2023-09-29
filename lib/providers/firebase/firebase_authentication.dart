import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthentication {
  FirebaseAuthentication._privateConstructor();
  static final FirebaseAuthentication instance = FirebaseAuthentication._privateConstructor();

  Future<bool> logInUser(TextEditingController emailController, TextEditingController passwordController, BuildContext context, ErrorCubit cubit)async{
    waitingDialog(context);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      UserModel user = await FireBaseProvider.instance.getUser(emailController.text);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (user.role == "admin") {
          AdminModel adminModel = await FireBaseProvider.instance.getAdminById(user.id);

          sharedPreferences.setString(
              PrefKeyConfigs.code, adminModel.adminCode);
          sharedPreferences.setInt(PrefKeyConfigs.userId, adminModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, adminModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, emailController.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
          Navigator.pushReplacementNamed(
              context, "${Routes.admin}?name=${adminModel.adminCode.trim()}");
        }
        if (user.role == "teacher") {
          TeacherModel teacherModel =
              await FireBaseProvider.instance.getTeacherById(user.id);
          sharedPreferences.setString(
              PrefKeyConfigs.code, teacherModel.teacherCode);
          sharedPreferences.setInt(PrefKeyConfigs.userId, teacherModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, teacherModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, emailController.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
          await context.read<AppBarInfoTeacherCubit>().load(context);
          Navigator.pushReplacementNamed(context,
              "${Routes.teacher}?name=${teacherModel.teacherCode.trim()}");
        }
        if (user.role == "master") {
          if (context.mounted) {
            Navigator.pop(context);
          }
          Navigator.pushReplacementNamed(context, Routes.master);
        }
        emailController.clear();
        passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are Logged in ${user.role}')));
      } else {
        FirebaseAuth.instance.signOut().then((value) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You don\'t have permission to access ')));
        });
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      debugPrint("code : ${e.code}");
      debugPrint("message : ${e.message}");
      if(AppConfigs.isRunningDebug){
        RegExp regex = RegExp(r'\((.*?)\)');

        Match? match = regex.firstMatch(e.message!);

        if (match != null) {
          String result = match.group(1)!;
          if(result == 'auth/user-not-found'){
            cubit.changeError(AppText.txtWrongAccount.text);
          }else if(result == 'auth/wrong-password'){
            cubit.changeError(AppText.txtWrongPassword.text);
            passwordController.clear();
          }else{
            cubit.changeError(AppText.txtInvalidLogin.text);
          }
        }
      }else{
        if(e.code == 'user-not-found'){
          cubit.changeError(AppText.txtWrongAccount.text);
        }else if(e.code == 'wrong-password'){
          cubit.changeError(AppText.txtWrongPassword.text);
          passwordController.clear();
        }else{
          cubit.changeError(AppText.txtInvalidLogin.text);
        }
      }

      return false;
    }
  }

  Future<bool> logOutUser(BuildContext context)async{
    final auth = FirebaseAuth.instance;
    await auth.signOut();
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setString(
        PrefKeyConfigs.code, '');
    sharedPreferences.setInt(PrefKeyConfigs.userId, -1);
    sharedPreferences.setString(PrefKeyConfigs.name, '');
    sharedPreferences.setString(PrefKeyConfigs.email, '');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    return true;
  }

  Future<bool> autoLogInUser(String email, BuildContext context)async{
    try {
      UserModel user = await FireBaseProvider.instance.getUser(email);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        if (user.role == "admin") {
          AdminModel adminModel = await FireBaseProvider.instance.getAdminById(user.id);
          Navigator.pushReplacementNamed(
              context, "${Routes.admin}?name=${adminModel.adminCode.trim()}");
        }
        if (user.role == "teacher") {
          TeacherModel teacherModel =
          await FireBaseProvider.instance.getTeacherById(user.id);
          Navigator.pushReplacementNamed(context,
              "${Routes.teacher}?name=${teacherModel.teacherCode.trim()}");
        }
        if (user.role == "master") {
          Navigator.pushReplacementNamed(context, Routes.master);
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("==========>login Error");
      return false;
    }
  }

  Future<bool> changePassword(String email, String oldPass, String newPass) async{

    final currentUser = FirebaseAuth.instance.currentUser;
    bool res = false;
    var cred = EmailAuthProvider.credential(email: email, password: oldPass);

    try {
      await currentUser!.reauthenticateWithCredential(cred);

      await currentUser.updatePassword(newPass);
      Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công');
      res = true;
    } catch (error) {
      debugPrint('=>>>>>>>>>>>>>error: $error');
      Fluttertoast.showToast(msg: 'Mật khẩu cũ không chính xác! Thử lại');
    }
    return res;
  }

  Future<String> uploadImageAndGetUrl(Uint8List data ,String folder) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final ref = FirebaseStorage.instance.ref().child('$folder/$now');
    await ref.putData(data, SettableMetadata(contentType: '.png'));
    return await ref.getDownloadURL();
  }
}