import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDataCubit extends Cubit<int> {
  List<ClassModel2>? classes;

  TeacherDataCubit() : super(0) {
    loadClass();
  }

  loadClass() async {
    classes = null;
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    if (userId == null || userId == -1) return;

    var user = await FireBaseProvider.instance.getUserById(userId);

    if (user.role == 'master') return;

    if (user.role == 'teacher') {
      loadClassForTeacherRole(userId);
    } else {
      loadClassForAdminRole();
    }

    debugPrint("======================> loadClass");
  }

  loadClassForTeacherRole(int userId) async {
    classes = await FireBaseProvider.instance.getClassByTeacherId(userId);
    emit(state + 1);
    List<int> listCourseIds = [];
    for (var i in classes!) {
      if (listCourseIds.contains(i.classModel.courseId) == false) {
        listCourseIds.add(i.classModel.courseId);
      }
      var lessonCount = await FireBaseProvider.instance.getCountWithCondition(
          "lesson_result", "class_id", i.classModel.classId);
      classes![classes!.indexOf(i)] = i.copyWith(null, null, lessonCount, null, null, null, null);
      emit(state + 1);
    }
    var courses =
        await FireBaseProvider.instance.getCourseByListId(listCourseIds);
    for (var i in classes!) {
      var course =
          courses.firstWhere((e) => e.courseId == i.classModel.courseId);
      classes![classes!.indexOf(i)] = i.copyWith(null, course, null, null, null, null, null);
      emit(state + 1);
    }
  }

  loadClassForAdminRole() async {
    classes = await FireBaseProvider.instance.getClassByAdmin();
    emit(state + 1);
  }
}
