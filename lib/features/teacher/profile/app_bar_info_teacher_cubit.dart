import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/prefKey_configs.dart';

class AppBarInfoTeacherCubit extends Cubit<TeacherModel?> {
  AppBarInfoTeacherCubit() : super(null);

  TeacherModel? teacherModel;

  load() async {
    // emit(null);

    // if(state != null) return;
    SharedPreferences localData = await SharedPreferences.getInstance();
    int userId = localData.getInt(PrefKeyConfigs.userId)!;

    if (state != null && state!.userId == userId) return;

    var profileTeacher = await FireBaseProvider.instance
        .getTeacherById(localData.getInt(PrefKeyConfigs.userId)!);
    teacherModel = profileTeacher;
    emit(profileTeacher);
  }

  update(TeacherModel model) {
    emit(model);
  }
}
