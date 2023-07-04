import 'dart:html';

class TextUtils {
  static String getName() {
    dynamic uri = Uri.dataFromString(window.location.href).toString();
    String temp = Uri.decodeFull(uri).split("=").last;
    print("============> getName() $temp");
    return temp.trim();
  }
}
