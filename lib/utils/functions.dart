import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html';

import '../model/course_model.dart';
import '../model/tag_model.dart';
import '../providers/firebase/firebase_provider.dart';

class Functions {
  static String getValue(Map<int, String> map, int key) {
    return map[key] ?? '';
  }

  static Future<void> goPage(String route, BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(PrefKeyConfigs.routes);
    String uri = Uri.dataFromString(window.location.href).toString();

    List<String> listSplit = uri.substring(6).split("/");

    String link = "";

    for(int i = 3; i<listSplit.length; i++){
      link = "$link/${listSplit[i]}";
    }

    list!.add(link);
    prefs.setStringList(PrefKeyConfigs.routes, list);

    if(context.mounted){
      await Navigator.pushNamed(context, route);
    }
  }

  static Future<bool> checkPreviousPageEmpty()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(PrefKeyConfigs.routes);
    if(list == null || list.isEmpty) return true;
    return false;
  }

  static Future<void> goPreviousPage(BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(PrefKeyConfigs.routes);

    list!.removeLast();

    prefs.setStringList(PrefKeyConfigs.routes, list);

    if(context.mounted){
      Navigator.of(context).pop();
    }
  }


  static Future<List<CourseModel>> getCourses(List<int> list) async {
    List<Future<CourseModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getCourseById(item));
    }
    List<CourseModel> items = await Future.wait(futures);
    return items;
  }

  static Future<List<TagModel>> getTags(List<int> list) async {
    List<Future<TagModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getTagById(item));
    }
    List<TagModel> tags = await Future.wait(futures);
    return tags;
  }
}