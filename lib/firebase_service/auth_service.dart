import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/firebase_service/firestore_service.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';

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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: "Aa@12345");
      await FirebaseAuth.instance.currentUser!.updatePassword("Aa@12345");
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(email, role, uid);
      role == AppText.selectorStudent.text
          ? await FirestoreServices.addStudent(
              uid, name, note, phone, code, "", inJapan)
          : await FirestoreServices.addSensei(name, note, phone, uid, code, "");

      if (context.mounted) {
        userCredential;
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

  static logInUser(String email, String password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await UserRepository.getUser(email);
      //UserRepository.saveLogin(user, password);
      TeacherModel teacherModel =
          await TeacherRepository.getTeacherById(user.id);
      debugPrint(
          "============== TeacherModel teacher ${teacherModel.teacherCode}");

      if (user.role == "admin" ||
          user.role == "master" ||
          user.role == "teacher") {
        debugPrint("======== ${user.role} ==========");
        // Routes.router.navigateTo(
        //     context, "${Routes.teacher}?name=${teacherModel.teacherCode}");

        Navigator.pushReplacementNamed(
            context,
            user.role == "admin"
                ? Routes.admin
                : user.role == "teacher"
                    ? "${Routes.teacher}?name=${teacherModel.teacherCode.trim()}"
                    : Routes.master);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are Logged in ${user.role}')));
      } else {
        FirebaseAuth.instance.signOut().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You don\'t have permission to access ')));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      }
    }
  }
}
