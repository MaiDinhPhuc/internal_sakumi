import '../model/course_model.dart';
import '../model/tag_model.dart';
import '../providers/firebase/firebase_provider.dart';

class Functions {
  static String getValue(Map<int, String> map, int key) {
    return map[key] ?? '';
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