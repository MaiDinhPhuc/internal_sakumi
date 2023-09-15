import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/teacher/list_class/teacher_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configs/prefKey_configs.dart';
import '../../../configs/text_configs.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppText.txtTeacherLogOut.text, style: const TextStyle(
        fontWeight: FontWeight.bold
      ),),
      titlePadding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 50)),
      icon: Image.asset('assets/images/ic_thumb_up.png' , height: Resizable.size(context, 120),),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(onPress: (){
          Navigator.pop(context);
        }, bgColor: Colors.white, foreColor: Colors.black, text: AppText.txtBack.text),

        CustomButton(onPress: () async{
          final _auth = FirebaseAuth.instance;
          await _auth.signOut();
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          sharedPreferences.setString(
              PrefKeyConfigs.code, '');
          sharedPreferences.setString(PrefKeyConfigs.password, '');
          sharedPreferences.setInt(PrefKeyConfigs.userId, -1);
          sharedPreferences.setString(PrefKeyConfigs.name, '');
          sharedPreferences.setString(PrefKeyConfigs.email, '');
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }, bgColor: primaryColor.shade500, foreColor: Colors.white, text: AppText.txtAgree.text),
      ],
    );
  }
}
