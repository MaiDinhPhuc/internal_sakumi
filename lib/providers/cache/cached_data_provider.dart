import 'package:internal_sakumi/model/class_model.dart';
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

  static Future<List<ClassModel>> classList(
      Map<AdminFilter, List> filter, int admin,
      {ClassModel? lastItem}) async {
    List? listType = filter[AdminFilter.type];
    List? listStatus = filter[AdminFilter.status];
    List<int> listTypeQuery = listType!.map((e) => type(e)).toList();
    List<String> listStatusQuery = listStatus!.map((e) => status(e)).toList();
    if(lastItem != null){
      var listClass = await FireBaseProvider.instance
          .getMoreClassWithFilter(listStatusQuery, listTypeQuery, lastItem.classId);
      return listClass;
    }
    return await FireBaseProvider.instance
        .getListClassWithFilter(listStatusQuery, listTypeQuery);
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
    var key = 'course_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
          await FireBaseProvider.instance.getCourseById(id);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> lessonResultByClassId(int classId, Function(Object) onLoaded)async{
    var key = 'lessonResult_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getLessonResultByClassId(classId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> stdClassByClassId(int classId, Function(Object) onLoaded)async{
    var key = 'stdClass_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getStudentClassInClass(classId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> lessonByCourseId(int courseId, Function(Object) onLoaded)async{
    var key = 'lessons_$courseId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getLessonsByCourseId(courseId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }

  static Future<void> stdLessonByClassId(int classId, Function(Object) onLoaded)async{
    var key = 'stdLessons_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
      await FireBaseProvider.instance.getAllStudentLessonsInClass(classId);
      for (var element in cached[key]!.callbacks) {
        element.call(cached[key]!.data!);
      }
      cached[key]!.callbacks = [];
    } else if (cached[key]!.data == null) {
      cached[key]!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached[key]!.data!);
    }
  }
}
