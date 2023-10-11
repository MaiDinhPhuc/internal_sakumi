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

    debugPrint("============> getName() $temp");
    return temp.trim();
  }

  static String getClassId(){
    dynamic uri = Uri.dataFromString(window.location.href);

    String temp = '';

    temp = Uri.decodeFull(uri.toString()).split('=').last;

    debugPrint("============> classId = $temp === ${window.location.href} ${Uri.dataFromString(window.location.href)}");
    return temp.substring(0, 1).trim();
  }//http://localhost:49203/#/teacher?name=kimngan/lesson/class?id=0

  static String getErrorAuth(String data) {
    int start = data.indexOf('(') + 1;
    int end = data.indexOf(')');
    return data.substring(start, end);
  }
}
