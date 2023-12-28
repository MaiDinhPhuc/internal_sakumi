import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'filter_admin_provider.dart';

class CacheObject {
  Object? data;
  DateTime time;

  CacheObject(this.time, {this.callbacks = const []});

  List<Function(Object)> callbacks;
}

class DataProvider {
  static Map<String, CacheObject> cached = {};

  static Future<List<ClassModel>> clasList(
      Map<AdminFilter, List> filter, int admin,
      {ClassModel? lastItem}) async {
    List? listType = filter[AdminFilter.type];
    List? listStatus = filter[AdminFilter.status];
    List<int> listTypeQuery = listType!.map((e) => type(e)).toList();
    List<String> listStatusQuery = listStatus!.map((e) => status(e)).toList();
    var listClass = await FireBaseProvider.instance
        .getClassWithFilter(listStatusQuery, listTypeQuery);
    return listClass;
  }

  static String status(FilterClassStatus status) {
    switch (status) {
      case FilterClassStatus.preparing:
        return "Preparing";
      case FilterClassStatus.completed:
        return "Completed";
      case FilterClassStatus.studying:
        return "InProgress";
      case FilterClassStatus.cancel:
        return "Cancel";
    }
  }

  static int type(FilterClassType type) {
    switch (type) {
      case FilterClassType.group:
        return 0;
      case FilterClassType.one:
        return 1;
    }
  }

  static Future<void> courseById(int id, Function(Object) onLoaded) async {

    if (cached['course_$id'] == null) {
      cached['course_$id'] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached['course_$id']!.data =
          await FireBaseProvider.instance.getCourseById(id);

      for (var element in cached['course_$id']!.callbacks) {
        element.call(cached['course_$id']!.data!);
      }
      cached['course_$id']!.callbacks = [];
    } else if (cached['course_$id']!.data == null) {
      cached['course_$id']!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached['course_$id']!.data!);
    }


  }
}
