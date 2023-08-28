import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/prefKey_configs.dart';
import '../../../repository/teacher_repository.dart';

class AppBarInfoTeacherCubit extends Cubit<TeacherModel?> {
  AppBarInfoTeacherCubit() : super(null);

  load(context) async {
    emit(null);
    debugPrint('=>>>>>>>>appBar');
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);
    SharedPreferences localData = await SharedPreferences.getInstance();
    var profileTeacher = await teacherRepository
        .getTeacher(localData.getString(PrefKeyConfigs.code).toString());
    emit(profileTeacher);
  }

  update(TeacherModel model) {
    emit(model);
  }
}