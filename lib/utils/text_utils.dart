import 'dart:html';

import 'package:flutter/material.dart';

class TextUtils {
  static String getName({int? position}) {
    dynamic uri = Uri.dataFromString(window.location.href).toString();

    String temp = '';

    if (position == null) {
      temp = Uri.decodeFull(uri).split('=').last;
    } else {
      temp = Uri.decodeFull(uri)
          .split('=')[position]
          .replaceAll(RegExp(r'[^0-9]'), '');
    }

    print("============> getName() $temp");
    return temp.trim();
  }

  static String getClassId(){
    dynamic uri = Uri.dataFromString(window.location.href).toString();

    String temp = '';

    temp = Uri.decodeFull(uri).split('class?id=').last;

    debugPrint("============> classId = $temp");
    return temp.substring(0, 1).trim();
  }

  static String getErrorAuth(String data) {
    int start = data.indexOf('(') + 1;
    int end = data.indexOf(')');
    return data.substring(start, end);
  }
}
