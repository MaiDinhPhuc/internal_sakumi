import 'dart:html';

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

  static String getErrorAuth(String data) {
    int start = data.indexOf('(') + 1;
    int end = data.indexOf(')');
    return data.substring(start, end);
  }
}
