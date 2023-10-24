import 'dart:html';

import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/resizable.dart';

class SplashScreen extends StatelessWidget {
  bool isInitialized = false;

  SplashScreen({super.key}) {
    debugPrint("=================================================> SplashScreen");

  }

  @override
  Widget build(BuildContext context) {


    if (!isInitialized) {
      isInitialized = true;
      applicationInitialize(context);
    }
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
    if (userId == "null" || userId == "-1") {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      if (Navigator.of(context).isCurrent("/")) {
        String userEmail = localData.getString(PrefKeyConfigs.email).toString();
        FireBaseProvider.instance.autoLogInUser(userEmail, context);
      }
    }
  }
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrent(routeName)) {
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
