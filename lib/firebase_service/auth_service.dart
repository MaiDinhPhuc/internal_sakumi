import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/firestore_service.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static signupUser(
      String name,
      String note,
      String phone,
      String code,
      bool inJapan,
      String email,
      String role,
      int uid,
      BuildContext context) async {
    try {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: "Aa@12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("abc12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(email, role, uid);
      role == AppText.selectorStudent.text
          ? await FirestoreServices.addStudent(
              uid, name, note, phone, code, "", inJapan)
          : await FirestoreServices.addSensei(name, note, phone, uid, code, "");

      if (context.mounted) {
        //userCredential;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static logInUser(TextEditingController emailController, TextEditingController passwordController, context, ErrorCubit cubit) async {
    waitingDialog(context);
    try {
      var userRepo = UserRepository.fromContext(context);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      UserModel user = await userRepo.getUser(emailController.text);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        AdminRepository adminRepository = AdminRepository.fromContext(context);

        if (user.role == "admin") {
          AdminModel adminModel = await adminRepository.getAdminById(user.id);

          sharedPreferences.setString(
              PrefKeyConfigs.code, adminModel.adminCode);
          sharedPreferences.setString(PrefKeyConfigs.password, passwordController.text);
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
          TeacherRepository teacherRepository =
              TeacherRepository.fromContext(context);
          TeacherModel teacherModel =
              await teacherRepository.getTeacherById(user.id);
          sharedPreferences.setString(
              PrefKeyConfigs.code, teacherModel.teacherCode);
          sharedPreferences.setString(PrefKeyConfigs.password, passwordController.text);
          sharedPreferences.setInt(PrefKeyConfigs.userId, teacherModel.userId);
          sharedPreferences.setString(PrefKeyConfigs.name, teacherModel.name);
          sharedPreferences.setString(PrefKeyConfigs.email, emailController.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
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
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
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
    }
  }
  static autoLogInUser(String email,context) async {
    try {
      var userRepo = UserRepository.fromContext(context);
      UserModel user = await userRepo.getUser(email);

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        if (user.role == "admin") {
          AdminRepository adminRepository = AdminRepository.fromContext(context);
          AdminModel adminModel = await adminRepository.getAdminById(user.id);
          Navigator.pushReplacementNamed(
              context, "${Routes.admin}?name=${adminModel.adminCode.trim()}");
        }
        if (user.role == "teacher") {
          TeacherRepository teacherRepository =
          TeacherRepository.fromContext(context);
          TeacherModel teacherModel =
          await teacherRepository.getTeacherById(user.id);
          Navigator.pushReplacementNamed(context,
              "${Routes.teacher}?name=${teacherModel.teacherCode.trim()}");
        }
        if (user.role == "master") {
          Navigator.pushReplacementNamed(context, Routes.master);
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("==========>login Error");
    }
  }
}
