import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/resizable.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    applicationInitialize(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.size(context, 20),
            ),
            child: Image.asset(
              'assets/images/ic_lg.png',
              fit: BoxFit.cover,
              height: Resizable.size(context, 300),
              width: Resizable.size(context, 300),
            ),
          ),
        ));
  }

  void applicationInitialize(BuildContext context) async {
    dynamic uri = Uri.dataFromString(window.location.href).toString();
    SharedPreferences localData = await SharedPreferences.getInstance();
    String userId = localData.getInt(PrefKeyConfigs.userId).toString();
    print("=======>uri: ${Uri.decodeFull(uri)}");
    if (userId == "null" || userId == "-1") {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      if (Navigator.of(context).isCurrent("/")) {
        String userEmail = localData.getString(PrefKeyConfigs.email).toString();
        AuthServices.autoLogInUser(userEmail, context);
      }
      // String userEmail = localData.getString(PrefKeyConfigs.email).toString();
      // AuthServices.autoLogInUser(userEmail, context);
    }
    // Navigator.pushReplacementNamed(context, "/login");
  }

}
extension NavigatorStateExtension on NavigatorState {

  void pushNamedIfNotCurrent( String routeName, { Object? arguments} ) {
    if (!isCurrent(routeName)) {
      pushNamed( routeName, arguments: arguments );
    }
  }

  bool isCurrent( String routeName ) {
    bool isCurrent = false;
    popUntil( (route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    } );
    return isCurrent;
  }

}