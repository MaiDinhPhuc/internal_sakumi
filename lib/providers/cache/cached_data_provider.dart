import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
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

  static Future<void> lessonResultByClassId(int classId, Function(Object) onLoaded)async{
    if (cached['lessonResult_$classId'] == null) {
      cached['lessonResult_$classId'] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached['lessonResult_$classId']!.data =
      await FireBaseProvider.instance.getLessonResultByClassId(classId);
      for (var element in cached['lessonResult_$classId']!.callbacks) {
        element.call(cached['lessonResult_$classId']!.data!);
      }
      cached['lessonResult_$classId']!.callbacks = [];
    } else if (cached['lessonResult_$classId']!.data == null) {
      cached['lessonResult_$classId']!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached['lessonResult_$classId']!.data!);
    }
  }

  static Future<void> stdClassByClassId(int classId, Function(Object) onLoaded)async{
    if (cached['stdClass_$classId'] == null) {
      cached['stdClass_$classId'] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached['stdClass_$classId']!.data =
      await FireBaseProvider.instance.getStudentClassInClass(classId);
      for (var element in cached['stdClass_$classId']!.callbacks) {
        element.call(cached['stdClass_$classId']!.data!);
      }
      cached['stdClass_$classId']!.callbacks = [];
    } else if (cached['stdClass_$classId']!.data == null) {
      cached['stdClass_$classId']!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached['stdClass_$classId']!.data!);
    }
  }

  static Future<void> lessonByCourseId(int courseId, Function(Object) onLoaded)async{
    if (cached['lessons_$courseId'] == null) {
      cached['lessons_$courseId'] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached['lessons_$courseId']!.data =
      await FireBaseProvider.instance.getLessonsByCourseId(courseId);
      for (var element in cached['lessons_$courseId']!.callbacks) {
        element.call(cached['lessons_$courseId']!.data!);
      }
      cached['lessons_$courseId']!.callbacks = [];
    } else if (cached['lessons_$courseId']!.data == null) {
      cached['lessons_$courseId']!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached['lessons_$courseId']!.data!);
    }
  }

  static Future<void> stdLessonByClassId(int classId, Function(Object) onLoaded)async{
    if (cached['stdLessons_$classId'] == null) {
      cached['stdLessons_$classId'] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached['stdLessons_$classId']!.data =
      await FireBaseProvider.instance.getAllStudentLessonsInClass(classId);
      for (var element in cached['stdLessons_$classId']!.callbacks) {
        element.call(cached['stdLessons_$classId']!.data!);
      }
      cached['stdLessons_$classId']!.callbacks = [];
    } else if (cached['stdLessons_$classId']!.data == null) {
      cached['stdLessons_$classId']!.callbacks.add(onLoaded);
    } else {
      onLoaded.call(cached['stdLessons_$classId']!.data!);
    }
  }
}
