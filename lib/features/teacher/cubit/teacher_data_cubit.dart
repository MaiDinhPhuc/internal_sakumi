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
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    print(userId);

    if (userId == null) return;

    var user = await FireBaseProvider.instance.getUserById(userId);

    if (user.role == 'master') return;

    if (user.role == 'teacher') {
      classes = await FireBaseProvider.instance.getClassByTeacherId(userId);
    } else {
      classes = await FireBaseProvider.instance.getClassByAdmin();
    }

    debugPrint("======================> loadClass");

    emit(state + 1);
  }
}
