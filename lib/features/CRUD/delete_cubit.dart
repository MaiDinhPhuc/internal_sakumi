import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class Delete{

  static removeClass(ClassModel classModel) async {
    await FireBaseProvider.instance.changeClassStatus(classModel, "Remove");
  }

  static deleteLesson(int lessonId, int courseId) async {
    await FireBaseProvider.instance.deleteLesson(lessonId, courseId);
  }

  static deleteTest(int testId, int courseId) async {
    await FireBaseProvider.instance.deleteTest(testId, courseId);
  }

  static deleteSurvey(int id) async {
    await FireBaseProvider.instance.deleteSurvey(id);
  }
}
