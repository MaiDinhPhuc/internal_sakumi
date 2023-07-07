import 'dart:html';

class TextUtils {
  static String getName() {
    dynamic uri = Uri.dataFromString(window.location.href).toString();
    String temp = Uri.decodeFull(uri).split("=").last;
    print("============> getName() $temp");
    return temp.trim();
  }

  static String getErrorAuth(String data) {
    int start = data.indexOf('(') + 1;
    int end = data.indexOf(')');
    return data.substring(start, end);
  }
}
