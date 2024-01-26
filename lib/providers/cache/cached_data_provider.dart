import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/model/test_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';

import 'filter_admin_provider.dart';
import 'filter_teacher_provider.dart';

class CacheObject {
  Object? data;
  DateTime time;

  CacheObject(this.time, {this.callbacks = const []});

  List<Function(Object)> callbacks;
}

class DataProvider {
  static Map<String, CacheObject> cached = {};

  static Future<List<ClassModel>> classListAdmin(
      Map<AdminFilter, List> filter, int admin, List<int> listCourseId,
      {ClassModel? lastItem}) async {
    List? listType = filter[AdminFilter.type];
    List? listStatus = filter[AdminFilter.status];
    List<int> listTypeQuery = listType!.map((e) => type(e)).toList();
    List<String> listStatusQuery =
        listStatus!.map((e) => statusAdmin(e)).toList();
    if (lastItem != null) {
      var listClass = await FireBaseProvider.instance.getMoreClassWithFilter(
          listStatusQuery, listTypeQuery, lastItem.classId, listCourseId);
      return listClass;
    }
    return await FireBaseProvider.instance
        .getListClassWithFilter(listStatusQuery, listTypeQuery, listCourseId);
  }

  static Future<List<ClassModel>> classListTeacher(
      int teacherId, Map<TeacherFilter, List> filter) async {
    var teacherClassIDs =
        (await FireStoreDb.instance.getTeacherClassById(teacherId))
            .docs
            .map((e) => e.data()['class_id'] as int)
            .toList();
    List? listStatus = filter[TeacherFilter.status];
    List<String> listStatusQuery =
        listStatus!.map((e) => statusTeacher(e)).toList();
    var classes = (await FireBaseProvider.instance
            .getListClassForTeacherV2(teacherClassIDs,listStatusQuery))
        .where((e) => listStatusQuery.contains(e.classStatus))
        .toList();

    return classes;
  }

  static String statusTeacher(FilterTeacherClassStatus status) {
    switch (status) {
      case FilterTeacherClassStatus.preparing:
        return "Preparing";
      case FilterTeacherClassStatus.completed:
        return "Completed";
      case FilterTeacherClassStatus.studying:
        return "InProgress";
    }
  }

  static String statusAdmin(FilterClassStatus status) {
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

  static Future<void> courseById(int id, Function(Object) onLoaded,
      {CourseModel? course}) async {
    var key = 'course_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      if (course == null) {
        cached[key]!.data = await FireBaseProvider.instance.getCourseById(id);
      } else {
        cached[key]!.data = course;
      }
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

  static void updateLessonResult(
      int classId, List<LessonResultModel> lessonResults) {
    var key = 'lessonResult_$classId';
    cached[key]!.data = lessonResults;
  }

  static Future<void> lessonResultByClassId(
      int classId, Function(Object) onLoaded) async {
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

  static void updateStdClass(int classId, List<StudentClassModel> stdClass) {
    var key = 'stdClass_$classId';
    cached[key]!.data = stdClass;
  }

  static Future<void> stdClassByClassId(
      int classId, Function(Object) onLoaded) async {
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

  static void updateTestResult(
      int classId, List<TestResultModel> testResults) {
    var key = 'testResult_$classId';
    cached[key]!.data = testResults;
  }

  static Future<void> testResultByClassId(
      int classId, Function(Object) onLoaded) async {
    var key = 'testResult_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
          await FireBaseProvider.instance.getListTestResult(classId);
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

  static void updateStudentTest(
      int classId, List<StudentTestModel> stdTests) {
    var key = 'stdTest_$classId';
    cached[key]!.data = stdTests;
  }

  static Future<void> stdTestByClassId(
      int classId, Function(Object) onLoaded) async {
    var key = 'stdTest_$classId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
          await FireBaseProvider.instance.getAllStudentTest(classId);
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

  static Future<void> testByCourseId(
      int courseId, Function(Object) onLoaded) async {
    var key = 'test_$courseId';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data =
          await FireBaseProvider.instance.getListTestByCourseId(courseId);
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

  static Future<void> teacherById(int id, Function(Object) onLoaded) async {
    var key = 'teacher_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data = await FireBaseProvider.instance.getTeacherById(id);
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

  static Future<void> studentById(int id, Function(Object) onLoaded) async {
    var key = 'student_$id';
    if (cached[key] == null) {
      cached[key] = CacheObject(DateTime.now(), callbacks: [onLoaded]);
      cached[key]!.data = await FireBaseProvider.instance.getStudentById(id);
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

  static Future<void> lessonByCourseAndClassId(
      int courseId,int classId, Function(Object) onLoaded) async {
    var key = 'lessons_${classId}_$courseId';
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

  static Future<void> lessonByCourseId(
      int courseId, Function(Object) onLoaded) async {
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

  static Future<void> customLessons(
      int courseId, Function(Object) onLoaded) async {
    var key = 'custom_lessons_$courseId';
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

  static void updateStdLesson(
      int classId, List<StudentLessonModel> stdLessons) {
    var key = 'stdLessons_$classId';

    cached[key]!.data = stdLessons;
  }

  static void addNewStdLesson(int classId, StudentLessonModel stdLessons) {
    var key = 'stdLessons_$classId';

    List<StudentLessonModel> list =
        cached[key]!.data as List<StudentLessonModel>;

    list.add(stdLessons);

    cached[key]!.data = list;
  }

  static Future<void> stdLessonByClassId(
      int classId, Function(Object) onLoaded) async {
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
